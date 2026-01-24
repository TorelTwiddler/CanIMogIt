-- Overlay for the crafting windows.

local scrollFrame = nil

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

    for _, button in ipairs(scrollFrame:GetFrames()) do
        local recipeInfo = button:GetElementData().data.recipeInfo or nil
        if recipeInfo then
            local recipeID = recipeInfo.recipeID
            local text = button.Label:GetText() or ""
            local itemLink = C_TradeSkillUI.GetRecipeItemLink(recipeID)
            if itemLink ~= nil then
                local icon = CanIMogIt:GetIconText(itemLink)
                if icon ~= nil and not string_starts(text, icon) then
                    text = icon .. text
                    button.Label:SetText(text)
                    button.Label:SetWidth(button.Label:GetWidth(text) + 20)
                end
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
    if event == "ADDON_LOADED" and addonName == "Blizzard_Professions" then
        if _G["ProfessionsFrame"] == nil then return end

        if not scrollFrame then
            local recipeListFrame = _G["ProfessionsFrame"].CraftingPage.RecipeList
            recipeListFrame:HookScript("OnUpdate", CIMI_UpdateTradeSkillIcons)

            scrollFrame = recipeListFrame.ScrollBox
        end
    end
end

CanIMogIt.eventFrame:AddSmartEvent(TradeSkillEvents, {"ADDON_LOADED"})

CanIMogIt:RegisterMessage("OptionUpdate", TradeSkillEvents)
