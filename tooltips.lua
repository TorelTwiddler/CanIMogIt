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


local function printDebug(tooltip, itemLink, bag, slot)
    -- Add debug statements to the tooltip, to make it easier to understand
    -- what may be going wrong.

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "Addon Version:", C_AddOns.GetAddOnMetadata("CanIMogIt", "Version"))
    local playerClass = select(2, UnitClass("player"))
    local playerLevel = UnitLevel("player")
    local playerSpec = C_SpecializationInfo.GetSpecialization()
    local playerSpecName = playerSpec and select(2, C_SpecializationInfo.GetSpecializationInfo(playerSpec)) or "None"

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

    addDoubleLine(tooltip, "IsItemSoulbound:", tostring(CanIMogIt:IsItemSoulbound(itemLink, bag, slot)))
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

    local calculatedTooltipText, unmodified = CanIMogIt:CalculateTooltipText(itemLink, bag, slot)
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

local function addToTooltip(tooltip, itemLink, bag, slot)
    -- Does the calculations for determining what text to
    -- display on the tooltip.
    if tooltip.CIMI_tooltipWritten then return end
    if not itemLink then return end
    if not CanIMogIt:IsReadyForCalculations(itemLink) then
        return
    end

    if CanIMogItOptions["debug"] then
        printDebug(tooltip, itemLink, bag, slot)
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
    text = CanIMogIt:GetTooltipText(itemLink, bag, slot)
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


-- Regular hook for any tooltip invoking item info.
--[[ local function CanIMogIt_AttachItemTooltip(tooltip)
    if tooltip.GetItem == nil then return end
    local link = select(2, tooltip:GetItem())
    if link then
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "OnTooltipSetItem")
    end
end
GameTooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip); ]]

-- Bags
hooksecurefunc(GameTooltip, "SetBagItem",
    function(tooltip, bag, slot)
        addToTooltip(tooltip, C_Container.GetContainerItemLink(bag, slot), bag, slot)
        VVDebugPrint(tooltip, "SetBagItem")
    end
)

-- Inventory (not sure what the difference is between this and bags)
hooksecurefunc(GameTooltip, "SetInventoryItem",
    function(tooltip, unit, slot)
        addToTooltip(tooltip, GetInventoryItemLink(unit, slot))
        VVDebugPrint(tooltip, "SetInventoryItem")
    end
)

-- Guild Bank
hooksecurefunc(GameTooltip, "SetGuildBankItem",
    function(tooltip, tab, slot)
        addToTooltip(tooltip, GetGuildBankItemLink(tab, slot))
        VVDebugPrint(tooltip, "SetGuildBankitem")
    end
)

-- Vendor
hooksecurefunc(GameTooltip, "SetMerchantItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetMerchantItemLink(index))
        VVDebugPrint(tooltip, "SetMerchantItem")
    end
)

-- Vendor Buyback
hooksecurefunc(GameTooltip, "SetBuybackItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetBuybackItemLink(index))
        VVDebugPrint(tooltip, "SetBuybackItem")
    end
)

-- Trade window (Player side)
hooksecurefunc(GameTooltip, "SetTradePlayerItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetTradePlayerItemLink(index))
        VVDebugPrint(tooltip, "SetTradePlayerItem")
    end
)

-- Trade window (Target side)
hooksecurefunc(GameTooltip, "SetTradeTargetItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetTradeTargetItemLink(index))
        VVDebugPrint(tooltip, "SetTradeTargetItem")
    end
)

-- Mail (Inbox)
hooksecurefunc(GameTooltip, "SetInboxItem",
    function(tooltip, mailIndex, attachmentIndex)
        addToTooltip(tooltip, GetInboxItemLink(mailIndex, attachmentIndex or 1))
        VVDebugPrint(tooltip, "SetInboxItem")
    end
)

-- Mail (Sending)
hooksecurefunc(GameTooltip, "SetSendMailItem",
    function(tooltip, index)
        local name = GetSendMailItem(index)
        local _, link = GetItemInfo(name)
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetSendMailItem")
    end
)

-- Auction
hooksecurefunc(GameTooltip, "SetAuctionItem",
    function(tooltip, type, index)
        VVDebugPrint(tooltip, "SetAuctionItem")
        addToTooltip(tooltip, GetAuctionItemLink(type, index))
    end
)

-- Quest Log
hooksecurefunc(GameTooltip, "SetQuestLogItem",
    function(tooltip, type, index)
        addToTooltip(tooltip, GetQuestLogItemLink(type, index))
        VVDebugPrint(tooltip, "SetQuestLogItem")
    end
)

-- Heirlooms
hooksecurefunc(GameTooltip, "SetHeirloomByItemID",
    function(tooltip, id)
        local _, link = GetItemInfo(id);
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetHeirloomByItemID")
    end
)

-- Item ID hook, used by Dungeon Journal
hooksecurefunc(GameTooltip, "SetItemByID",
    function(tooltip, itemID)
        local _, link = GetItemInfo(itemID)
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetItemByID")
    end
)

-- Item key hook, used by Auction House Bucket tooltip
hooksecurefunc(GameTooltip, "SetItemKey",
    function(tooltip, itemID, itemLevel, itemSuffix)
        local _, link = GetItemInfo(itemID)
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetItemKey")
    end
)

-- Hyperlinks
local function OnSetHyperlink(tooltip, link)
    local type, id = string.match(link, ".*(item):(%d+).*")
    if not type or not id then return end
    if type == "item" then
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetHyperlink")
    end
end
hooksecurefunc(GameTooltip, "SetHyperlink", OnSetHyperlink)