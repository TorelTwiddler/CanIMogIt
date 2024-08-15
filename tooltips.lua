-----------------------------
-- Adding to tooltip       --
-----------------------------

local function addDoubleLine(tooltip, left_text, right_text)
    tooltip:AddDoubleLine(left_text, right_text)
    tooltip:Show()
end


local function addLine(tooltip, text)
    tooltip:AddLine(text, nil, nil, nil, true)
    tooltip:Show()
end


-----------------------------
-- Debug functions         --
-----------------------------


local function printDebug(tooltip, itemLink, tooltipData)
    -- Add debug statements to the tooltip, to make it easier to understand
    -- what may be going wrong.

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "Addon Version:", C_AddOns.GetAddOnMetadata("CanIMogIt", "Version"))
    local playerClass = select(2, UnitClass("player"))
    local playerLevel = UnitLevel("player")
    local playerSpecName
    if CanIMogIt.isRetail then
        local playerSpec = GetSpecialization()
        playerSpecName = playerSpec and select(2, GetSpecializationInfo(playerSpec)) or "None"
    else
        playerSpecName = "Classic, unknown"
    end

    addDoubleLine(tooltip, "Player Class:", playerClass)
    addDoubleLine(tooltip, "Player Spec:", playerSpecName)
    addDoubleLine(tooltip, "Player Level:", playerLevel)

    addLine(tooltip, '--------')

    local itemID = CanIMogIt:GetItemID(itemLink)
    if not itemID then
        if string.find(itemLink, "battlepet:") then
            local _, _, petSpeciesID = string.find(itemLink, "battlepet:(%d+):")
            addDoubleLine(tooltip, "BattlePet Species ID:", tostring(petSpeciesID))
            local collected, total = C_PetJournal.GetNumCollectedInfo(tonumber(petSpeciesID) or 0)
            addDoubleLine(tooltip, "Number Collected:", collected .. "/" .. total)
            addLine(tooltip, '--------')
            return
        end
        -- Keystones don't have an itemID...
        addLine(tooltip, 'No ItemID found. Is this a Keystone or Battle Pet?')
        addLine(tooltip, '--------')
        return
    end
    addDoubleLine(tooltip, "Item ID:", tostring(itemID))
    local _, _, quality, _, _, itemClass, itemSubClass, _, equipSlot, _, _, _, _, _, expansion = C_Item.GetItemInfo(itemID)
    addDoubleLine(tooltip, "Item class:", tostring(itemClass))
    addDoubleLine(tooltip, "Item subClass:", tostring(itemSubClass))
    addDoubleLine(tooltip, "Item equipSlot:", tostring(equipSlot))
    addDoubleLine(tooltip, "Item expansion:", tostring(expansion or "nil"))

    local sourceID, sourceIDSource = CanIMogIt:GetSourceID(itemLink)
    addDoubleLine(tooltip, "Item sourceID:", tostring(sourceID))
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    addDoubleLine(tooltip, "Item appearanceID:", tostring(appearanceID))

    local setID = CanIMogIt:SetsDBGetSetFromSourceID(sourceID) or "nil"
    addDoubleLine(tooltip, "Item setID:", tostring(setID))

    local baseSetID = setID ~= nil and setID ~= "nil" and C_TransmogSets.GetBaseSetID(setID) or "nil"
    addDoubleLine(tooltip, "Item baseSetID:", tostring(setID))

    addLine(tooltip, '--------')

    if sourceID then
        local playerCanCollectIsReady = select(1, C_TransmogCollection.PlayerCanCollectSource(sourceID))
        if playerCanCollectIsReady ~= nil then
            addDoubleLine(tooltip, "BLIZZ PlayerCanCollectSource_1_IsReady:", tostring(playerCanCollectIsReady))
        end
    end

    if sourceID then
        local playerCanCollect = select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID))
        if playerCanCollect ~= nil then
            addDoubleLine(tooltip, "BLIZZ PlayerCanCollectSource_2_CanCollect:", tostring(playerCanCollect))
        end
    end

    local playerHasTransmog = C_TransmogCollection.PlayerHasTransmog(itemID)
    if playerHasTransmog ~= nil then
        addDoubleLine(tooltip, "BLIZZ PlayerHasTransmog:", tostring(playerHasTransmog))
    end

    if sourceID then
        local playerHasTransmogItem = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
        if playerHasTransmogItem ~= nil then
            addDoubleLine(tooltip, "BLIZZ PlayerHasTransmogItemModifiedAppearance:", tostring(playerHasTransmogItem))
        end
    end

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "IsTransmogable:", tostring(CanIMogIt:IsTransmogable(itemLink)))
    local playerKnowsTransmogFromItem = CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
    if playerKnowsTransmogFromItem ~= nil then
        addDoubleLine(tooltip, "PlayerKnowsTransmogFromItem:", tostring(playerKnowsTransmogFromItem))
    end

    local playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmog(itemLink)
    if playerKnowsTransmog ~= nil then
        addDoubleLine(tooltip, "PlayerKnowsTransmog:", tostring(playerKnowsTransmog))
    end
    local characterCanLearnTransmog = CanIMogIt:CharacterCanLearnTransmog(itemLink)
    if characterCanLearnTransmog ~= nil then
        addDoubleLine(tooltip, "CharacterCanLearnTransmog:", tostring(characterCanLearnTransmog))
    end

    addLine(tooltip, '--------')

    local isMountItem = CanIMogIt:IsItemMount(itemLink)
    if isMountItem ~= nil then
        addDoubleLine(tooltip, "IsMountItem:", tostring(isMountItem))
        if isMountItem then
            addDoubleLine(tooltip, "PlayerKnowsMount:", tostring(CanIMogIt:PlayerKnowsMount(itemLink)))
        end
    end
    local isPetItem = CanIMogIt:IsItemPet(itemLink)
    if isPetItem ~= nil then
        addDoubleLine(tooltip, "IsPetItem:", tostring(isPetItem))
        if isPetItem then
            addDoubleLine(tooltip, "PlayerKnowsPet:", tostring(CanIMogIt:PlayerKnowsPet(itemLink)))
        end
    end
    local isToyItem = CanIMogIt:IsItemToy(itemLink)
    if isToyItem ~= nil then
        addDoubleLine(tooltip, "IsToyItem:", tostring(isToyItem))
        if isToyItem then
            addDoubleLine(tooltip, "PlayerKnowsToy:", tostring(CanIMogIt:PlayerKnowsToy(itemLink)))
        end
    end
    local isEnsembleItem = CanIMogIt:IsItemEnsemble(itemLink)
    if isEnsembleItem ~= nil then
        addDoubleLine(tooltip, "IsEnsembleItem:", tostring(isEnsembleItem))
        if isEnsembleItem then
            local known, total = CanIMogIt:EnsembleItemsKnown(itemLink)
            addDoubleLine(tooltip, "EnsembleItemsKnown:", known .. "/" .. total)
        end
    end

    addDoubleLine(tooltip, "IsItemSoulbound:", tostring(CanIMogIt:IsItemSoulbound(itemLink)))
    addDoubleLine(tooltip, "IsItemWarbound:", tostring(CanIMogIt:IsItemWarbound(itemLink)))
    local bindData = CanIMogIt.BindData:new(itemLink)
    if bindData ~= nil then
        addDoubleLine(tooltip, "BindType:", tostring(bindData.type))
    else
        addDoubleLine(tooltip, "BindType:", 'nil')
    end
    addDoubleLine(tooltip, "IsValidAppearanceForCharacter:", tostring(CanIMogIt:IsValidAppearanceForCharacter(itemLink)))

    local classesRequired = CIMIScanTooltip:GetClassesRequired(itemLink)
    if classesRequired ~= nil then
        addDoubleLine(tooltip, "Required Classes:", tostring(table.concat(classesRequired, ", ") ))
    else
        addDoubleLine(tooltip, "Required Classes:", 'nil')
    end

    addLine(tooltip, '--------')

    local calculatedTooltipText, unmodified = CanIMogIt:CalculateTooltipText(itemLink, nil, nil, tooltipData)
    if calculatedTooltipText ~= nil then
        -- Iterate over the constants in CanIMogIt and find the matching one
        for key, value in pairs(CanIMogIt) do
            if type(value) == "string" and value == unmodified then
                addDoubleLine(tooltip, "Matching Constant:", key)
                break
            end
        end
        addDoubleLine(tooltip, "Tooltip:", tostring(calculatedTooltipText))
    else
        addDoubleLine(tooltip, "Tooltip:", 'nil')
    end

    addLine(tooltip, '--------')

end


-----------------------------
-- Tooltip hooks           --
-----------------------------

local itemLinks = {}

local function addToTooltip(tooltip, itemLink, tooltipData)
    -- Does the calculations for determining what text to
    -- display on the tooltip.
    if tooltip.CIMI_tooltipWritten then return end
    if not itemLink then return end
    if not CanIMogIt:IsReadyForCalculations(itemLink) then
        return
    end

    if CanIMogItOptions["debug"] then
        printDebug(tooltip, itemLink, tooltipData)
        tooltip.CIMI_tooltipWritten = true
    end

    -- If it's a battlepet, then don't add any lines. Battle Pet uses a
    -- different tooltip frame than normal.
    local isBattlepet = string.match(itemLink, ".*(battlepet):.*") == "battlepet"
    if isBattlepet then
        tooltip.CIMI_tooltipWritten = true
        return
    end

    local text;
    text = CanIMogIt:GetTooltipText(itemLink, nil, nil, tooltipData)
    if text and text ~= "" then
        addDoubleLine(tooltip, " ", text)
        tooltip.CIMI_tooltipWritten = true
    end

    if CanIMogItOptions["showSetInfo"] then
        local setFirstLineText, setSecondLineText = CanIMogIt:GetSetsText(itemLink)
        if setFirstLineText and setFirstLineText ~= "" then
            addDoubleLine(tooltip, " ", setFirstLineText)
            tooltip.CIMI_tooltipWritten = true
        end
        if setSecondLineText and setSecondLineText ~= "" then
            addDoubleLine(tooltip, " ", setSecondLineText)
            tooltip.CIMI_tooltipWritten = true
        end
    end

    if CanIMogItOptions["showSourceLocationTooltip"] then
        local sourceTypesText = CanIMogIt:GetSourceLocationText(itemLink)
        if sourceTypesText and sourceTypesText ~= "" then
            addDoubleLine(tooltip, " ", sourceTypesText)
            tooltip.CIMI_tooltipWritten = true
        end
    end
end


-- Enable this to get a very verbose debug message for every tooltip
-- change that occurs.
local VVDebug = false

function VVDebugPrint(tooltip, event)
    if VVDebug then
        CanIMogIt:Print(tooltip:GetName(), event)
    end
end


local function TooltipCleared(tooltip)
    -- Clears the tooltipWritten flag once the tooltip is done rendering.
    tooltip.CIMI_tooltipWritten = false
    VVDebugPrint(tooltip, "OnTooltipCleared")
end


GameTooltip:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefTooltip:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefShoppingTooltip1:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefShoppingTooltip2:HookScript("OnTooltipCleared", TooltipCleared)
ShoppingTooltip1:HookScript("OnTooltipCleared", TooltipCleared)
ShoppingTooltip2:HookScript("OnTooltipCleared", TooltipCleared)

if CanIMogIt.isRetail then
    GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipCleared", TooltipCleared)
end


local function CanIMogIt_AttachItemTooltip(tooltip, tooltipData)
    -- Hook for normal tooltips.
    if tooltip.GetItem == nil then return end
    local link = select(2, tooltip:GetItem())
    if link then
        addToTooltip(tooltip, link, tooltipData)
        VVDebugPrint(tooltip, "OnTooltipSetItem")
    end
end


TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, CanIMogIt_AttachItemTooltip)
