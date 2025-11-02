-- Overlay for the crafting windows.


-- Cached tradeskill recipe button frames in the main list
local buttons = {}

-- Cached scroll frame and scroll offset
local scrollFrame = nil
local scrollFrameOffset = 0


----------------------------
-- UpdateIcon functions   --
----------------------------


local function string_starts(String,Start)
    String = String or ""
    return string.sub(String,1,string.len(Start))==Start
end


local function RemoveTradeSkillIcons()
    for i, button in ipairs(buttons) do
        local itemLink = GetTradeSkillItemLink(button:GetID())
        if itemLink ~= nil then
            local text = button.text:GetText() or ""
            local icon = CanIMogIt:GetIconText(itemLink)
            if icon ~= nil and string_starts(text, icon) then
                button.text:SetText(string.gsub(text, icon, ""))
            end
        end
    end
end

function CIMI_UpdateTradeSkillIcons(self)
    if not CIMI_CheckOverlayIconEnabled() then
        if self == "OptionUpdate" then RemoveTradeSkillIcons() end
        return
    end

    -- Add icon to all visible trade skill recipes
    for i, button in ipairs(buttons) do
        local itemLink = GetTradeSkillItemLink(button:GetID())
        if itemLink == nil then
            CIMI_SetIcon(button.CanIMogItOverlay, nil, nil, nil)
        else
            CIMI_SetIcon(button.CanIMogItOverlay, nil, CanIMogIt:GetTooltipText(itemLink))
        end
    end
end


------------------------
-- Event functions    --
------------------------


local function TradeSkillEvents(event, addonName)
    if event == "TRADE_SKILL_SHOW" or event == "ADDON_LOADED" and addonName == "Blizzard_TradeSkillUI" then
        if _G["TradeSkillFrame"] == nil then return end
        if _G["TradeSkillListScrollFrame"] == nil then return end

        -- Cache scroll frame
        if not scrollFrame then scrollFrame = _G["TradeSkillListScrollFrame"] end

        -- Cache buttons
        if not next(buttons) then 
            -- Using constant TRADE_SKILLS_DISPLAYED as max value - other addons can expand crafting UI which also modifies this value
            for i=1, TRADE_SKILLS_DISPLAYED do
                local button = _G["TradeSkillSkill"..i]
                CIMI_AddToFrame(button, nil, "TradeSkill"..i, "TRADESKILL")
                AuctionHouseFrame_CIMIUpdateIcon(button.CanIMogItOverlay)
                buttons[i] = button
            end
        end
        

        -- Hook update on button click
        for i, button in ipairs(buttons) do
            button:HookScript("OnClick", CIMI_UpdateTradeSkillIcons)
        end
        
        -- Hook update when scroll frame offset has changed (i.e. player has scrolled up or down)
        scrollFrame:HookScript("OnUpdate", function()
            if (scrollFrameOffset ~= scrollFrame.offset) then
                scrollFrameOffset = scrollFrame.offset
                CIMI_UpdateTradeSkillIcons()
            end
        end)
    end
end
CanIMogIt.frame:AddSmartEvent(TradeSkillEvents, {"TRADE_SKILL_SHOW", "ADDON_LOADED"})
CanIMogIt.frame:AddSmartEvent(CIMI_UpdateTradeSkillIcons, {"TRADE_SKILL_SHOW", "TRADE_SKILL_UPDATE", "TRADE_SKILL_FILTER_UPDATE"})


CanIMogIt:RegisterMessage("OptionUpdate", CIMI_UpdateTradeSkillIcons)
