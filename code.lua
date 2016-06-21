-- This file is loaded from "CanIMogIt.toc"

CanIMogIt = {}

local DEBUG = false

if DEBUG then
	print("CanIMogIt is in Debug mode.")
end

---- Transmog Categories
-- 1 Head
-- 2 Shoulder
-- 3 Back
-- 4 Chest
-- 5 Shirt
-- 6 Tabard
-- 7 Wrist
-- 8 Hands
-- 9 Waist
-- 10 Legs
-- 11 Feet
-- 12 Wand
-- 13 One-Handed Axes
-- 14 One-Handed Swords
-- 15 One-Handed Maces
-- 16 Daggers
-- 17 Fist Weapons
-- 18 Shields
-- 19 Held In Off-hand
-- 20 Two-Handed Axes
-- 21 Two-Handed Swords
-- 22 Two-Handed Maces
-- 23 Staves
-- 24 Polearms
-- 25 Bows
-- 26 Guns
-- 27 Crossbows
-- 28 Warglaives

local categoryMap = {
	"INVTYPE_HEAD", --"Head",
	"INVTYPE_SHOULDER", --"Shoulder",
	"INVTYPE_CLOAK", --"Back",
	"INVTYPE_CHEST", --"Chest",
	"INVTYPE_BODY", --"Shirt",
	"INVTYPE_TABARD", --"Tabard",
	"INVTYPE_WRIST", --"Wrist",
	"INVTYPE_HAND", --"Hands",
	"INVTYPE_WAIST", --"Waist",
	"INVTYPE_LEGS", --"Legs",
	"INVTYPE_FEET", --"Feet",
	"Wand",
	"One-Handed Axes",
	"One-Handed Swords",
	"One-Handed Maces",
	"Daggers",
	"Fist Weapons",
	"INVTYPE_SHIELD", --"Shields",
	"INVTYPE_HOLDABLE", --"Held In Off-hand",
	"Two-Handed Axes",
	"Two-Handed Swords",
	"Two-Handed Maces",
	"Staves",
	"Polearms",
	"Bows",
	"Guns",
	"Crossbows",
	"Warglaives",
}


local CAN_I_MOG_IT = "|cff00a3cc" .. "CanIMogIt:"
local KNOWN = "|cff0072b2" .. "You have collected this appearance"
local UNKNOWN = "|cffd55e00" .. "You haven't collected this appearance"
local UNKNOWABLE_BY_CHARACTER = "|cfff0e442" .. "This character cannot learn this item"
local NOT_TRANSMOGABLE = "|cff666666" .. "This item cannot be learned"


local function AnIndexOf(t,val)
	-- return the first integer index holding the value 
	-- http://stackoverflow.com/questions/2095669/getting-table-entry-index
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end


local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text)
	tooltip:Show()
end


local function addLine(tooltip, text)
	tooltip:AddLine(text)
	tooltip:Show()
end


local function printDebug(tooltip, itemID)
	-- Add debug statements to the tooltip, to make it easier to understand
	-- what may be going wrong.
	addDoubleLine(tooltip, "Item ID:", tostring(itemID))
	_, _, _, _, _, itemClass, itemSubClass, _, equipSlot = GetItemInfo(itemID)
	addDoubleLine(tooltip, "Item Class:", tostring(itemClass))
	addDoubleLine(tooltip, "Item SubClass:", tostring(itemSubClass))
	addDoubleLine(tooltip, "Item equipSlot:", tostring(equipSlot))
	local categoryID = CanIMogIt:GetCategoryID(itemID)
	addDoubleLine(tooltip, "categoryID:", tostring(categoryID))
	addDoubleLine(tooltip, "IsTransmogable:", tostring(CanIMogIt:IsTransmogable(itemID)))

	if categoryID then
		addDoubleLine(tooltip, "IsValidInCategory:", tostring(CanIMogIt:IsValidInCategory(categoryID, itemID)))
		addDoubleLine(tooltip, "C_TransmogCollection.IsCategoryValidForItem:", tostring(C_TransmogCollection.IsCategoryValidForItem(categoryID, itemID)))
		addDoubleLine(tooltip, "PlayerCanLearnTransmog:", tostring(CanIMogIt:PlayerCanLearnTransmog(itemID)))
	end

	
	addDoubleLine(tooltip, "PlayerKnowsTransmog:", tostring(CanIMogIt:PlayerKnowsTransmog(itemID)))
	addDoubleLine(tooltip, "C_TransmogCollection.PlayerHasTransmog: ", tostring(C_TransmogCollection.PlayerHasTransmog(itemID)))
end


function CanIMogIt:PlayerKnowsTransmog(itemID)
	-- Returns whether this item is already known by the player.
	return C_TransmogCollection.PlayerHasTransmog(itemID)
end


function CanIMogIt:PlayerCanLearnTransmog(itemID)
	-- Returns whether the player can learn the item or not.
	local categoryID = CanIMogIt:GetCategoryID(itemID)
	return CanIMogIt:IsValidInCategory(categoryID, itemID)
end


function CanIMogIt:GetCategoryID(itemID)
	-- Returns the transmog category ID from the item
	local categoryType = select(6, GetItemInfo(itemID))
	local categoryName
	-- Category types we care about: Weapon, Armor
	if categoryType == "Weapon" then
		categoryName = select(7, GetItemInfo(itemID))
	elseif categoryType == "Armor" then
		categoryName = select(9, GetItemInfo(itemID))
	else
		-- Something that isn't equipable
		return nil
	end
	return AnIndexOf(categoryMap, categoryName)
end


function CanIMogIt:IsValidInCategory(categoryID, itemID)
	-- Returns whether the item is a transmoggable item for this
	-- category.
	return C_TransmogCollection.IsCategoryValidForItem(categoryID, itemID)
end


function CanIMogIt:IsTransmogable(itemID)
	-- Returns whether the item is transmoggable or not.
	local categoryID = CanIMogIt:GetCategoryID(itemID)
	return not not categoryID
end


local function attachItemTooltip(self)
	CanIMogIt.tooltip = self
    local itemName = select(1, self:GetItem())
	local itemID = select(1, GetItemInfoInstant(itemName))
	if type(itemID)=="number" then
		if DEBUG then
			printDebug(CanIMogIt.tooltip, itemID)
		end
		local text = ""
		if CanIMogIt:IsTransmogable(itemID) then
			if CanIMogIt:PlayerKnowsTransmog(itemID) then
				-- Set text to KNOWN
				text = KNOWN
			else
				if CanIMogIt:PlayerCanLearnTransmog(itemID) then
					-- Set text to UNKNOWN
					text = UNKNOWN
				else
					-- Set text to UNKNOWABLE_BY_CHARACTER
					text = UNKNOWABLE_BY_CHARACTER
				end
			end
		else
			--Set text to NOT_TRANSMOGABLE
			text = NOT_TRANSMOGABLE
		end
		if text then
			addDoubleLine(self, CAN_I_MOG_IT, text)
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
