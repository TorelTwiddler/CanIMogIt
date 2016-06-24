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
	["INVTYPE_HEAD"]=1, --"Head",
	["INVTYPE_SHOULDER"]=2, --"Shoulder",
	["INVTYPE_CLOAK"]=3, --"Back",
	["INVTYPE_CHEST"]=4, --"Chest",
	["INVTYPE_ROBE"]=4, --"Chest",
	["INVTYPE_BODY"]=5, --"Shirt",
	["INVTYPE_TABARD"]=6, --"Tabard",
	["INVTYPE_WRIST"]=7, --"Wrist",
	["INVTYPE_HAND"]=8, --"Hands",
	["INVTYPE_WAIST"]=9, --"Waist",
	["INVTYPE_LEGS"]=10, --"Legs",
	["INVTYPE_FEET"]=11, --"Feet",
	["Wands"]=12,
	["One-Handed Axes"]=13,
	["One-Handed Swords"]=14,
	["One-Handed Maces"]=15,
	["Daggers"]=16,
	["Fist Weapons"]=17,
	["INVTYPE_SHIELD"]=18, --"Shields",
	["INVTYPE_HOLDABLE"]=19, --"Held In Off-hand",
	["Two-Handed Axes"]=20,
	["Two-Handed Swords"]=21,
	["Two-Handed Maces"]=22,
	["Staves"]=23,
	["Polearms"]=24,
	["Bows"]=25,
	["Guns"]=26,
	["Crossbows"]=27,
	["Warglaives"]=28,
}


local CAN_I_MOG_IT = "|cff00a3cc" .. "CanIMogIt:"
local KNOWN = "|cff0072b2" .. "You have collected this appearance"
local UNKNOWN = "|cffd55e00" .. "You haven't collected this appearance"
local UNKNOWABLE_BY_CHARACTER = "|cfff0e442" .. "This character cannot learn this item"
local NOT_TRANSMOGABLE = "|cff666666" .. "This item cannot be learned"


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
	local _, _, quality, _, _, itemClass, itemSubClass, _, equipSlot = GetItemInfo(itemID)
	addDoubleLine(tooltip, "Item Quality:", tostring(quality))
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
	return categoryMap[categoryName]
end


function CanIMogIt:GetQuality(itemID)
	-- Returns the quality of the item.
	return select(3, GetItemInfo(itemID))
end


function CanIMogIt:IsValidInCategory(categoryID, itemID)
	-- Returns whether the item is a transmoggable item for this
	-- category.
	return C_TransmogCollection.IsCategoryValidForItem(categoryID, itemID)
end


function CanIMogIt:IsTransmogable(itemID)
	-- Returns whether the item is transmoggable or not.
	local quality = CanIMogIt:GetQuality(itemID)
	if quality <= 1 then
		return false
	end
	local categoryID = CanIMogIt:GetCategoryID(itemID)
	return not not categoryID
end


local function addToTooltip(tooltip, itemID)
	-- Does the calculations for determining what text to
	-- display on the tooltip.
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
			addDoubleLine(tooltip, CAN_I_MOG_IT, text)
		end
	end
end


local function attachItemTooltip(self)
	-- Hook for normal tooltips.
	CanIMogIt.tooltip = self
	local link = select(2, self:GetItem())
	if link then
    	local itemID = tonumber(link:match("item:(%d+)"))
		addToTooltip(CanIMogIt.tooltip, itemID)
	end
end


GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)


local function onSetHyperlink(self, link)
	-- Hook for Hyperlinked tooltips.
	CanIMogIt.tooltip = self
	local type, id = string.match(link, "^(%a+):(%d+)")
	if not type or not id then return end
	if type == "item" then
		addToTooltip(CanIMogIt.tooltip, id)
	end
end


hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)
