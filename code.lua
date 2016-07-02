-- This file is loaded from "CanIMogIt.toc"

CanIMogIt = {}

local dressUpModel = CreateFrame('DressUpModel')

local DEBUG = true

if DEBUG then
	print("CanIMogIt is in Debug mode.")
end

-----------------------------
-- Maps                    --
-----------------------------

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


local inventorySlotsMap = {
    ['INVTYPE_HEAD'] = 1,
    ['INVTYPE_NECK'] = 2,
    ['INVTYPE_SHOULDER'] = 3,
    ['INVTYPE_BODY'] = 4,
    ['INVTYPE_CHEST'] = 5,
    ['INVTYPE_ROBE'] = 5,
    ['INVTYPE_WAIST'] = 6,
    ['INVTYPE_LEGS'] = 7,
    ['INVTYPE_FEET'] = 8,
    ['INVTYPE_WRIST'] = 9,
    ['INVTYPE_HAND'] = 10,
    ['INVTYPE_CLOAK'] = 15,
    ['INVTYPE_WEAPON'] = 16,
    ['INVTYPE_SHIELD'] = 17,
    ['INVTYPE_2HWEAPON'] = 16,
    ['INVTYPE_WEAPONMAINHAND'] = 16,
    ['INVTYPE_RANGED'] = 16,
    ['INVTYPE_RANGEDRIGHT'] = 16,
    ['INVTYPE_WEAPONOFFHAND'] = 17,
    ['INVTYPE_HOLDABLE'] = 17,
}


-----------------------------
-- Tooltip text constants  --
-----------------------------
local CAN_I_MOG_IT = 			"|cff00a3cc" .. " "
local KNOWN = 					"|cff15abff" .. "Learned."
local KNOWN_FROM_ANOTHER_ITEM = "|cff15abff" .. "Learned from another item."
local UNKNOWN = 				"|cffff9333" .. "Not learned."
local UNKNOWABLE_BY_CHARACTER = "|cfff0e442" .. "This character cannot learn this item."
local NOT_TRANSMOGABLE = 		"|cff888888" .. "Cannot be learned."


-----------------------------
-- Adding to tooltip       --
-----------------------------

local function addDoubleLine(tooltip, left_text, right_text)
	tooltip:AddDoubleLine(left_text, right_text)
	tooltip:Show()
end


local function addLine(tooltip, text)
	tooltip:AddLine(text)
	tooltip:Show()
end


-----------------------------
-- Debug functions         --
-----------------------------


local function printDebug(tooltip, itemLink)
	-- Add debug statements to the tooltip, to make it easier to understand
	-- what may be going wrong.
	local itemID = CanIMogIt:GetItemID(itemLink)
	addDoubleLine(tooltip, "Item ID:", tostring(itemID))
	local _, _, quality, _, _, itemClass, itemSubClass, _, equipSlot = GetItemInfo(itemID)
	addDoubleLine(tooltip, "Item Quality:", tostring(quality))
	addDoubleLine(tooltip, "Item Class:", tostring(itemClass))
	addDoubleLine(tooltip, "Item SubClass:", tostring(itemSubClass))
	addDoubleLine(tooltip, "Item equipSlot:", tostring(equipSlot))
	local categoryID = CanIMogIt:GetCategoryID(itemID)
	addDoubleLine(tooltip, "categoryID:", tostring(categoryID))
	addDoubleLine(tooltip, "IsTransmogable:", tostring(CanIMogIt:IsTransmogable(itemLink)))

	if categoryID then
		addDoubleLine(tooltip, "IsValidInCategory:", tostring(CanIMogIt:IsValidInCategory(categoryID, itemID)))
		addDoubleLine(tooltip, "C_TransmogCollection.IsCategoryValidForItem:", tostring(C_TransmogCollection.IsCategoryValidForItem(categoryID, itemID)))
	end
	
	addDoubleLine(tooltip, "PlayerKnowsTransmogFromItem:", tostring(CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)))
	addDoubleLine(tooltip, "C_TransmogCollection.PlayerHasTransmog: ", tostring(C_TransmogCollection.PlayerHasTransmog(itemID)))

	local source = CanIMogIt:GetSource(itemLink)
	addDoubleLine(tooltip, "GetSource:", tostring(source))
	local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
	addDoubleLine(tooltip, "GetAppearanceID:", tostring(appearanceID))
	addDoubleLine(tooltip, "PlayerCanLearnTransmog:", tostring(CanIMogIt:PlayerCanLearnTransmog(itemLink)))


	if appearanceID then
		addDoubleLine(tooltip, "PlayerHasAppearance:", tostring(CanIMogIt:PlayerHasAppearance(appearanceID)))
	end
end


-----------------------------
-- CanIMogIt Core methods  --
-----------------------------


function CanIMogIt:GetSource(itemLink)
	-- Get the source from the item link.
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)
    local slot = inventorySlotsMap[slotName]
    if not slot or not IsDressableItem(itemLink) then return end
    dressUpModel:SetUnit('player')
    dressUpModel:Undress()
    dressUpModel:TryOn(itemLink, slot)
    return dressUpModel:GetSlotTransmogSources(slot)
end

 
function CanIMogIt:GetAppearanceID(itemLink)
	-- Gets the appearanceID of the given itemID.
	local source = CanIMogIt:GetSource(itemLink)
    if source and source ~= 0 then
        return select(2, C_TransmogCollection.GetAppearanceSourceInfo(source))
    end
end


function CanIMogIt:PlayerHasAppearance(appearanceID)
	-- Returns whether the player has the given appearanceID.
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    if sources then
        for i, source in pairs(sources) do
            if source.isCollected then
                return true
            end
        end
    end
    return false
end


function CanIMogIt:PlayerKnowsTransmog(itemLink)
	-- Returns whether this item's appearance is already known by the player.
	local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
	if appearanceID then
		return CanIMogIt:PlayerHasAppearance(appearanceID)
	end
	return false
end


function CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
	-- Returns whether the transmog is known from this item specifically.
	local itemID = CanIMogIt:GetItemID(itemLink)
	return C_TransmogCollection.PlayerHasTransmog(itemID)
end


function CanIMogIt:PlayerCanLearnTransmog(itemLink)
	-- Returns whether the player can learn the item or not.
	local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
	if not appearanceID then
		return false
	end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    if sources then
        for i, source in pairs(sources) do
            if C_TransmogCollection.PlayerCanCollectSource(source.sourceID) then
                return true
            end
        end
    end
	return false
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


function CanIMogIt:IsTransmogable(itemLink)
	-- Returns whether the item is transmoggable or not.
	local quality = CanIMogIt:GetQuality(itemLink)
	if quality <= 1 then
		return false
	end
	-- local itemID = CanIMogIt:GetItemID(itemLink)
	-- local categoryID = CanIMogIt:GetCategoryID(itemID)
	-- return not not categoryID
	local source = CanIMogIt:GetSource(itemLink)
	return source ~= 0 and not not source
end


function CanIMogIt:GetItemID(itemLink)
	return tonumber(itemLink:match("item:(%d+)"))
end


function CanIMogIt:GetItemLink(itemID)
	return select(2, GetItemInfo(itemID))
end

-----------------------------
-- Tooltip hooks           --
-----------------------------


local function addToTooltip(tooltip, itemLink)
	-- Does the calculations for determining what text to
	-- display on the tooltip.
	local itemID = CanIMogIt:GetItemID(itemLink)
	local itemInfo = GetItemInfo(itemLink)
	if not itemInfo then return end
	if DEBUG then
		printDebug(CanIMogIt.tooltip, itemLink)
	end
	local text = ""
	if CanIMogIt:IsTransmogable(itemLink) then
		if CanIMogIt:PlayerKnowsTransmogFromItem(itemLink) then
			-- Set text to KNOWN
			text = KNOWN
		elseif CanIMogIt:PlayerKnowsTransmog(itemLink) then
			-- Set text to KNOWN_FROM_ANOTHER_ITEM
			text = KNOWN_FROM_ANOTHER_ITEM
		else
			if CanIMogIt:PlayerCanLearnTransmog(itemLink) then
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


local function attachItemTooltip(self)
	-- Hook for normal tooltips.
	CanIMogIt.tooltip = self
	local link = select(2, self:GetItem())
	if link then
		addToTooltip(CanIMogIt.tooltip, link)
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
		addToTooltip(CanIMogIt.tooltip, link)
	end
end


hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)
