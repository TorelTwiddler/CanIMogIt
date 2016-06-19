-- This file is loaded from "CanIMogIt.toc"

CanIMogIt = {}

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
	"INVTYPE_BACK", --"Back",
	"INVTYPE_CHEST", --"Chest",
	"INVTYPE_SHIRT", --"Shirt",
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
	"Shields",
	"Held In Off-hand",
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



local function AnIndexOf(t,val)
	-- return the first integer index holding the value 
	-- http://stackoverflow.com/questions/2095669/getting-table-entry-index
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end


local CAN_I_MOG_IT = "CanIMogIt:"
local KNOWN = "You have collected this appearance"
local UNKNOWN = "You haven't collected this appearance"
local UNKNOWABLE_BY_CHARACTER = "This character cannot learn this item"
local NOT_TRANSMOGABLE = "This item cannot be learned"


function CanIMogIt:PlayerKnowsTransmog(itemID)
	-- Returns whether this item is already known by the player.
	return C_TransmogCollection.PlayerHasTransmog(itemID)
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


local function addLine(tooltip, text_to_add, itemID)
    local found = false

    -- Check if we already added to this tooltip. Happens on the talent frame
    for i = 1,15 do
        local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
        local text
        if frame then text = frame:GetText() end
        if text and text == CAN_I_MOG_IT then found = true break end
    end

    if not found then
        tooltip:AddDoubleLine("|c00a3ccff" .. CAN_I_MOG_IT .. itemID, "|c00a3ccff" .. text_to_add)
        tooltip:Show()
    end
end


function CanIMogIt:attachItemTooltip()
    local itemName = select(1, self:GetItem())
	local itemID = select(1, GetItemInfoInstant(itemName))
	if type(itemID)=="number" then
	
		local text = ""
		if CanIMogIt:PlayerKnowsTransmog(itemID) then
			-- Set text to KNOWN
			text = KNOWN
		else
			-- Get the categoryID
			local categoryID = CanIMogIt:GetCategoryID(itemID)
			if categoryID then
				if CanIMogIt:IsValidInCategory(categoryID, itemID) then
					-- Set text to UNKNOWN
					text = UNKNOWN
				else
					-- Set text to UNKNOWABLE_BY_CHARACTER
					text = UNKNOWABLE_BY_CHARACTER
				end
			else
				--Set text to NOT_TRANSMOGABLE
				text = NOT_TRANSMOGABLE
			end
		end
		if text then
			addLine(self, text, itemID)
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", CanIMogIt.attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", CanIMogIt.attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", CanIMogIt.attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", CanIMogIt.attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", CanIMogIt.attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", CanIMogIt.attachItemTooltip)
