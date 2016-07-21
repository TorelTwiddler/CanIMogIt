-- This file is loaded from "CanIMogIt.toc"

CanIMogIt = {}

local dressUpModel = CreateFrame('DressUpModel')


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


local HEAD = "INVTYPE_HEAD"
local SHOULDER = "INVTYPE_SHOULDER"
local BODY = "INVTYPE_BODY"
local CHEST = "INVTYPE_CHEST"
local ROBE = "INVTYPE_ROBE"
local WAIST = "INVTYPE_WAIST"
local LEGS = "INVTYPE_LEGS"
local FEET = "INVTYPE_FEET"
local WRIST = "INVTYPE_WRIST"
local HAND = "INVTYPE_HAND"
local CLOAK = "INVTYPE_CLOAK"
local WEAPON = "INVTYPE_WEAPON"
local SHIELD = "INVTYPE_SHIELD"
local WEAPON_2HAND = "INVTYPE_2HWEAPON"
local WEAPON_MAIN_HAND = "INVTYPE_WEAPONMAINHAND"
local RANGED = "INVTYPE_RANGED"
local RANGED_RIGHT = "INVTYPE_RANGEDRIGHT"
local WEAPON_OFF_HAND = "INVTYPE_WEAPONOFFHAND"
local HOLDABLE = "INVTYPE_HOLDABLE"
local TABARD = "INVTYPE_TABARD"
local BAG = "INVTYPE_BAG"


local inventorySlotsMap = {
    [HEAD] = {1},
    [SHOULDER] = {3},
    [BODY] = {4},
    [CHEST] = {5},
    [ROBE] = {5},
    [WAIST] = {6},
    [LEGS] = {7},
    [FEET] = {8},
    [WRIST] = {9},
    [HAND] = {10},
    [CLOAK] = {15},
    [WEAPON] = {16, 17},
    [SHIELD] = {17},
    [WEAPON_2HAND] = {16, 17},
    [WEAPON_MAIN_HAND] = {16},
    [RANGED] = {16},
    [RANGED_RIGHT] = {16},
    [WEAPON_OFF_HAND] = {17},
    [HOLDABLE] = {17},
	[TABARD] = false,
}


local MISC = 0
local CLOTH = 1
local LEATHER = 2
local MAIL = 3
local PLATE = 4
local COSMETIC = 5

local classArmorTypeMap = {
	["DEATHKNIGHT"] = PLATE,
	["DEMONHUNTER"] = LEATHER,
	["DRUID"] = LEATHER,
	["HUNTER"] = MAIL,
	["MAGE"] = CLOTH,
	["MONK"] = LEATHER,
	["PALADIN"] = PLATE,
	["PRIEST"] = CLOTH,
	["ROGUE"] = LEATHER,
	["SHAMAN"] = MAIL,
	["WARLOCK"] = CLOTH,
	["WARRIOR"] = PLATE,
}


local armorTypeSlots = {
	[HEAD] = true,
	[SHOULDER] = true,
	[CHEST] = true,
	[ROBE] = true,
	[WRIST] = true,
	[HAND] = true,
	[WAIST] = true,
	[LEGS] = true,
	[FEET] = true,
}


local miscArmorExceptions = {
	[HOLDABLE] = true,
	[BODY] = true,
	[TABARD] = true,
}


-----------------------------
-- Tooltip text constants --
-----------------------------


local KNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN:0|t "
local KNOWN_BUT_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle:0|t "
local UNKNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWN:0|t "
local UNKNOWABLE_BY_CHARACTER_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER:0|t "
local NOT_TRANSMOGABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE:0|t "
local QUESTIONABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE:0|t "

local BLUE =   "|cff15abff"
local ORANGE = "|cffff9333"
local YELLOW = "|cfff0e442"
local GRAY =   "|cff888888"

CanIMogIt.CAN_I_MOG_IT = 			"|cff00a3cc" .. " "
CanIMogIt.KNOWN = 					KNOWN_ICON .. BLUE .. "Learned."
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM = KNOWN_ICON .. BLUE .. "Learned from another item."
CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER = KNOWN_BUT_ICON .. BLUE .. "Learned for a different class."
CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL = KNOWN_BUT_ICON .. BLUE .. "Learned but cannot transmog yet."
CanIMogIt.UNKNOWN = 				UNKNOWN_ICON .. ORANGE .. "Not learned."
CanIMogIt.UNKNOWABLE_BY_CHARACTER = UNKNOWABLE_BY_CHARACTER_ICON .. YELLOW .. "Another class can learn this item."
CanIMogIt.NOT_TRANSMOGABLE = 		NOT_TRANSMOGABLE_ICON .. GRAY .. "Cannot be learned."
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER = QUESTIONABLE_ICON .. YELLOW .. "Cannot determine status on other characters."


local knownTexts = {
	[CanIMogIt.KNOWN] = true,
	[CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = true,
	[CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = true,
	[CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = true,
}


-----------------------------
-- Exceptions              --
-----------------------------


local exceptionItems = {
    [HEAD] = {},
    [SHOULDER] = {
		[119556] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders
	},
    [BODY] = {},
    [CHEST] = {},
    [ROBE] = {},
    [WAIST] = {},
    [LEGS] = {},
    [FEET] = {},
    [WRIST] = {},
    [HAND] = {},
    [CLOAK] = {},
    [WEAPON] = {
		[89566] = CanIMogIt.NOT_TRANSMOGABLE, -- Novice's Handwraps
		[89570] = CanIMogIt.NOT_TRANSMOGABLE, -- Initiate's Handwraps
		[89571] = CanIMogIt.NOT_TRANSMOGABLE, -- Grappling Handwraps
		[89572] = CanIMogIt.NOT_TRANSMOGABLE, -- Handwraps of Pilgrimage
		[89573] = CanIMogIt.NOT_TRANSMOGABLE, -- Handwraps of Meditation
		[89574] = CanIMogIt.NOT_TRANSMOGABLE, -- Handwraps of Fallen Blossoms
		[89575] = CanIMogIt.NOT_TRANSMOGABLE, -- Handwraps of Serenity
	},
    [SHIELD] = {},
    [WEAPON_2HAND] = {},
    [WEAPON_MAIN_HAND] = {},
    [RANGED] = {},
    [RANGED_RIGHT] = {},
    [WEAPON_OFF_HAND] = {},
    [HOLDABLE] = {},
	[TABARD] = {},
}


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

	local source = CanIMogIt:GetSource(itemLink)
	if source ~= nil then
		addDoubleLine(tooltip, "Item source:", tostring(source))
	else
		addDoubleLine(tooltip, "Item source:", 'nil')
	end

	local playerClass = select(2, UnitClass("player"))
	local playerLevel = UnitLevel("player")
	local playerSpec = GetSpecialization()
	local playerSpecName = playerSpec and select(2, GetSpecializationInfo(playerSpec)) or "None"
	addDoubleLine(tooltip, "Player Class:", playerClass)
	addDoubleLine(tooltip, "Player Spec:", playerSpecName)
	addDoubleLine(tooltip, "Player Level:", playerLevel)

	local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
	addDoubleLine(tooltip, "GetAppearanceID:", tostring(appearanceID))
	if appearanceID then
		addDoubleLine(tooltip, "PlayerHasAppearance:", tostring(CanIMogIt:PlayerHasAppearance(appearanceID)))
	end

	addDoubleLine(tooltip, "IsTransmogable:", tostring(CanIMogIt:IsTransmogable(itemLink)))
	addDoubleLine(tooltip, "PlayerKnowsTransmogFromItem:", tostring(CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)))
	addDoubleLine(tooltip, "IsValidAppearanceForPlayer:", tostring(CanIMogIt:IsValidAppearanceForPlayer(itemLink)))
	addDoubleLine(tooltip, "PlayerIsTooLowLevelForItem:", tostring(CanIMogIt:PlayerIsTooLowLevelForItem(itemLink)))
	addDoubleLine(tooltip, "PlayerKnowsTransmog:", tostring(CanIMogIt:PlayerKnowsTransmog(itemLink)))
	addDoubleLine(tooltip, "PlayerCanLearnTransmog:", tostring(CanIMogIt:PlayerCanLearnTransmog(itemLink)))

end


-----------------------------
-- CanIMogIt variables        --
-----------------------------


CanIMogIt.tooltip = nil;
CanIMogIt.cachedItemLink = nil;
CanIMogIt.cachedTooltipText = nil;


-----------------------------
-- CanIMogIt Core methods  --
-----------------------------


function CanIMogIt:GetPlayerArmorTypeName()
	local playerArmorTypeID = classArmorTypeMap[select(2, UnitClass("player"))]
	return select(1, GetItemSubClassInfo(4, playerArmorTypeID))
end


function CanIMogIt:IsItemArmor(itemLink)
	return GetItemClassInfo(4) == select(6, GetItemInfo(itemLink))
end


function CanIMogIt:IsArmorSubClass(subClass, itemLink)
	return select(1, GetItemSubClassInfo(4, subClass)) == select(7, GetItemInfo(itemLink))
end


function CanIMogIt:IsArmorAppropriateForPlayer(itemLink)
	local playerArmorTypeID = CanIMogIt:GetPlayerArmorTypeName()
	if armorTypeSlots[CanIMogIt:GetSlotName(itemLink)] and not CanIMogIt:IsArmorSubClass(COSMETIC, itemLink) then 
		return playerArmorTypeID == select(7, GetItemInfo(itemLink))
	else
		return true
	end
end


function CanIMogIt:GetSlotName(itemLink)
	return select(9, GetItemInfo(itemLink))
end


function CanIMogIt:IsValidAppearanceForPlayer(itemLink)
	if IsEquippableItem(itemLink) then
		if CanIMogIt:IsItemArmor(itemLink) then
			return CanIMogIt:IsArmorAppropriateForPlayer(itemLink)
		else
			return true
		end
	else
		return false
	end
end


function CanIMogIt:PlayerIsTooLowLevelForItem(itemLink)
	local minLevel = select(5, GetItemInfo(itemLink))
	return UnitLevel("player") < minLevel
end


function CanIMogIt:GetExceptionText(itemLink)
	-- Returns the exception text for this item, if it has one.
	local itemID = CanIMogIt:GetItemID(itemLink)
	local slotName = CanIMogIt:GetSlotName(itemLink)
	local slotExceptions = exceptionItems[slotName]
	if slotExceptions then
		return slotExceptions[itemID]
	end
end


function CanIMogIt:IsEquippable(itemLink)
	-- Returns whether the item is equippable or not (exluding bags)
	local slotName = CanIMogIt:GetSlotName(itemLink)
	return slotName ~= "" and slotName ~= BAG
end


function CanIMogIt:GetSource(itemLink)
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)
    local slots = inventorySlotsMap[slotName]

    if not slots or not IsDressableItem(itemLink) then return end
    dressUpModel:SetUnit('player')
    dressUpModel:Undress()
	for i, slot in pairs(slots) do
    	dressUpModel:TryOn(itemLink, slot)
		local source = dressUpModel:GetSlotTransmogSources(slot)
		if source ~= 0 then return source end
	end
end

 
function CanIMogIt:GetAppearanceID(itemLink)
	-- Gets the appearanceID of the given itemID.
	local source = CanIMogIt:GetSource(itemLink)
    if source then
        local appearanceID = select(2, C_TransmogCollection.GetAppearanceSourceInfo(source))
        return appearanceID
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
	if CanIMogIt:GetSlotName(itemLink) == TABARD then return true end
	local source = CanIMogIt:GetSource(itemLink)
	if source == nil then return false end
	if select(2, C_TransmogCollection.PlayerCanCollectSource(source)) then
		return true
	end
	return false
end


function CanIMogIt:GetQuality(itemID)
	-- Returns the quality of the item.
	return select(3, GetItemInfo(itemID))
end


function CanIMogIt:IsTransmogable(itemLink)
	-- Returns whether the item is transmoggable or not.

	-- White items are not transmoggable.
	local quality = CanIMogIt:GetQuality(itemLink)
	if quality <= 1 then
		return false
	end

	local is_misc_subclass = CanIMogIt:IsArmorSubClass(MISC, itemLink)
	if is_misc_subclass and not miscArmorExceptions[CanIMogIt:GetSlotName(itemLink)] then
		return false
	end
	
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)

	-- See if the game considers it transmoggable
	local transmoggable = select(3, C_Transmog.GetItemInfo(itemID))
	if transmoggable == false then
		return false
	end

	-- See if the item is in a valid transmoggable slot
	if inventorySlotsMap[slotName] == nil then
		return false
	end
	return true
end


function CanIMogIt:GetItemID(itemLink)
	return tonumber(itemLink:match("item:(%d+)"))
end


function CanIMogIt:GetItemLink(itemID)
	return select(2, GetItemInfo(itemID))
end


function CanIMogIt:GetTooltipText(itemLink)
	-- Gets the text to display on the tooltip
	local text = ""

	if CanIMogItOptions["showEquippableOnly"] and 
			not CanIMogIt:IsEquippable(itemLink) then
		-- Don't bother if it's not equipable.
		return
	end

	local exception_text = CanIMogIt:GetExceptionText(itemLink)
	if exception_text then
		return exception_text
	end


	if CanIMogIt:IsTransmogable(itemLink) then
		if CanIMogIt:PlayerKnowsTransmogFromItem(itemLink) then
			if CanIMogIt:IsValidAppearanceForPlayer(itemLink) then
				if CanIMogIt:PlayerIsTooLowLevelForItem(itemLink) then
					text = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
				else
					text = CanIMogIt.KNOWN
				end
			else
				text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
			end
		elseif CanIMogIt:PlayerKnowsTransmog(itemLink) then
			if CanIMogIt:IsValidAppearanceForPlayer(itemLink) then
				if CanIMogIt:PlayerIsTooLowLevelForItem(itemLink) then
					text = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
				else
					text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
				end
			else
				text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
			end
		else
			if CanIMogIt:PlayerCanLearnTransmog(itemLink) then
				-- Set text to UNKNOWN
				text = CanIMogIt.UNKNOWN
			else
				-- Set text to UNKNOWABLE_BY_CHARACTER
				text = CanIMogIt.UNKNOWABLE_BY_CHARACTER
			end
		end
	else
		--Set text to NOT_TRANSMOGABLE
		text = CanIMogIt.NOT_TRANSMOGABLE
	end
	return text
end

-----------------------------
-- Tooltip hooks           --
-----------------------------


local function addToTooltip(tooltip, itemLink)
	-- Does the calculations for determining what text to
	-- display on the tooltip.
	local itemInfo = GetItemInfo(itemLink)
	if not itemInfo then 
		CanIMogIt.cachedItemLink = nil
		CanIMogIt.cachedTooltipText = nil
		return 
	end
	if CanIMogItOptions["debug"] then
		printDebug(CanIMogIt.tooltip, itemLink)
	end
	
	local text;
	-- Checking against the cached item first.
	if itemLink == CanIMogIt.cachedItemLink then
		text = CanIMogIt.cachedTooltipText
	else
		text = CanIMogIt:GetTooltipText(itemLink)
		-- Save the cached item and text, so it's faster next time.
		CanIMogIt.cachedItemLink = itemLink
		CanIMogIt.cachedTooltipText = text
	end
	if CanIMogItOptions["showTransmoggableOnly"] and text == CanIMogIt.NOT_TRANSMOGABLE then
		-- If we don't want to show the tooltip if it's not transmoggable
		return
	end
	if CanIMogItOptions["showUnknownOnly"] and knownTexts[text] then
		-- We don't want to show the tooltip if it's already known.
		return
	end
	if text then
		addDoubleLine(tooltip, CanIMogIt.CAN_I_MOG_IT, text)
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
