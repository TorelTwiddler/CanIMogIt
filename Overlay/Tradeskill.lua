-- Overlay for the crafting windows.


----------------------------
-- UpdateIcon functions   --
----------------------------

local function string_starts(String,Start)
    String = String or ""
    return string.sub(String,1,string.len(Start))==Start
end


function CIMI_UpdateTradeSkillIcons(_, elapsed)
    if not CanIMogIt.FrameShouldUpdate("TradeskillOverlay", elapsed or 1) then return end
    if not CIMI_CheckOverlayIconEnabled() then
        return
    end

    -- Add icon to all visible trade skill recipes
    -- (Using constant TRADE_SKILLS_DISPLAYED here - other addons can expand crafting UI which also modifies this value)
    for i=1, TRADE_SKILLS_DISPLAYED do
        local button = _G["TradeSkillSkill"..i]
        local itemLink = GetTradeSkillItemLink(button:GetID())
        if itemLink ~= nil then
            local text = button.text:GetText() or ""
            local icon = CanIMogIt:GetIconText(itemLink)
            if icon ~= nil and not string_starts(text, icon) then
                text = icon .. text
                button.text:SetText(text)
            end
        end
    end
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


------------------------
-- Event functions    --
------------------------


local function TradeSkillEvents(event, addonName)
    if event == "TRADE_SKILL_SHOW" or event == "ADDON_LOADED" and addonName == "Blizzard_TradeSkillUI" then
        if _G["TradeSkillFrame"] == nil then return end
        local tradeSkillFrame = _G["TradeSkillFrame"]
        tradeSkillFrame:HookScript("OnUpdate", CIMI_UpdateTradeSkillIcons)
    end
end

CanIMogIt.frame:AddSmartEvent(TradeSkillEvents, {"TRADE_SKILL_SHOW", "ADDON_LOADED"})

CanIMogIt:RegisterMessage("OptionUpdate", TradeSkillEvents)
