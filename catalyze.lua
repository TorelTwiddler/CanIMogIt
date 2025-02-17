-- Checks to see if the item can be catalyzed.

local function DisplayCatalyzeTooltip(tooltip, itemLocation)
    if C_Item.DoesItemExist(itemLocation) then
        if C_Item.IsItemConvertibleAndValidForPlayer(itemLocation) then
            tooltip:AddDoubleLine(" ", CanIMogIt.UNKNOWN_ICON .. CanIMogIt.RED_ORANGE .. "Item can be Catalyzed!")
            tooltip:Show()
        end
    end
end

local function OnTooltipSetInventoryItem(tooltip, unit, slot)
    if CanIMogItOptions["showCatalizableItems"] == false then return end
    local itemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
    DisplayCatalyzeTooltip(tooltip, itemLocation)
end


local function OnTooltipSetItem(tooltip, bag, slot)
    if CanIMogItOptions["showCatalizableItems"] == false then return end
    local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
    DisplayCatalyzeTooltip(tooltip, itemLocation)
end


-- Hook the function to the GameTooltip.
hooksecurefunc(GameTooltip, "SetInventoryItem", OnTooltipSetInventoryItem)
hooksecurefunc(GameTooltip, "SetBagItem", OnTooltipSetItem)
