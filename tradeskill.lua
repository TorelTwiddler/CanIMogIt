

function CIMI_UpdateTradeSkillIcons()
    local tradeSkillFrame = _G["TradeSkillFrame"]
    local buttons = tradeSkillFrame.RecipeList.buttons

    for i, button in ipairs(buttons) do
        if button ~= nil and button.tradeSkillInfo ~= nil and button.tradeSkillInfo.recipeID ~= nil then
            local recipeID = button.tradeSkillInfo.recipeID
            local text = button:GetText()
            local itemLink = C_TradeSkillUI.GetRecipeItemLink(recipeID)
            if itemLink ~= nil then
                local icon = CanIMogIt:GetIcon(itemLink)
                if icon ~= nil then
                    text = icon .. text
                    button:SetText(text)
                end
            end
        end
    end
end


function CanIMogIt.frame:TradeSkillEvents(event, addon)
    if event == "ADDON_LOADED" and addon == "Blizzard_TradeSkillUI" then
        local tradeSkillFrame = _G["TradeSkillFrame"]
        local scrollBar = tradeSkillFrame.RecipeList.scrollBar
        scrollBar:HookScript("OnValueChanged", CIMI_UpdateTradeSkillIcons)
    end
end