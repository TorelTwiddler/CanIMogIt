-- This file is loaded from "CanIMogIt.toc"

local L = CanIMogIt.L

CanIMogIt.DressUpModel = CreateFrame('DressUpModel')


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
local UNKNOWABLE_BY_CHARACTER_SOULBOUND_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER_SOULBOUND:0|t "
local NOT_TRANSMOGABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE:0|t "
local QUESTIONABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE:0|t "


local BLUE =   "|cff15abff"
local BLUE_GREEN = "|cff009e73"
local PINK = "|cffcc79a7"
local ORANGE = "|cffe69f00"
local RED_ORANGE = "|cffff9333"
local YELLOW = "|cfff0e442"
local GRAY =   "|cff888888"


local KNOWN =                                       L["Learned."]
local KNOWN_FROM_ANOTHER_ITEM =                     L["Learned from another item."]
local KNOWN_BY_ANOTHER_CHARACTER =                  L["Learned for a different class."]
local KNOWN_BUT_TOO_LOW_LEVEL =                     L["Learned but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =   L["Learned from another item but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =       L["Learned for a different class and item."]
local UNKNOWN =                                     L["Not learned."]
local UNKNOWABLE_BY_CHARACTER =                     L["Another class can learn this item."]
local UNKNOWABLE_BY_CHARACTER_SOULBOUND =           L["Cannot be learned by this character."]
local CAN_BE_LEARNED_BY =                           L["Can be learned by:"] -- list of classes
local NOT_TRANSMOGABLE =                            L["Cannot be learned."]
local CANNOT_DETERMINE =                            L["Cannot determine status on other characters."]


CanIMogIt.CAN_I_MOG_IT =                                "|cff00a3cc" .. " "
CanIMogIt.KNOWN =                                       KNOWN_ICON .. BLUE .. KNOWN
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM =                     KNOWN_ICON .. BLUE .. KNOWN_FROM_ANOTHER_ITEM
CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER =                  KNOWN_BUT_ICON .. BLUE .. KNOWN_BY_ANOTHER_CHARACTER
CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL =                     KNOWN_BUT_ICON .. BLUE .. KNOWN_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =   KNOWN_BUT_ICON .. BLUE .. KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
-- CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =    KNOWN_BUT_ICON .. BLUE .. KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =       QUESTIONABLE_ICON .. YELLOW .. CANNOT_DETERMINE
CanIMogIt.UNKNOWN =                                     UNKNOWN_ICON .. RED_ORANGE .. UNKNOWN
CanIMogIt.UNKNOWABLE_BY_CHARACTER =                     UNKNOWABLE_BY_CHARACTER_ICON .. YELLOW .. UNKNOWABLE_BY_CHARACTER
CanIMogIt.UNKNOWABLE_BY_CHARACTER_SOULBOUND =           UNKNOWABLE_BY_CHARACTER_SOULBOUND_ICON .. BLUE_GREEN .. UNKNOWABLE_BY_CHARACTER_SOULBOUND
CanIMogIt.NOT_TRANSMOGABLE =                            NOT_TRANSMOGABLE_ICON .. GRAY .. NOT_TRANSMOGABLE


local tooltipTexts = {
    [KNOWN] = CanIMogIt.KNOWN,
    [KNOWN_FROM_ANOTHER_ITEM] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    [KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER,
    [KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL,
    [KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL,
    [KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER,
    [UNKNOWN] = CanIMogIt.UNKNOWN,
    [UNKNOWABLE_BY_CHARACTER] = CanIMogIt.UNKNOWABLE_BY_CHARACTER,
    [UNKNOWABLE_BY_CHARACTER_SOULBOUND] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_SOULBOUND,
    [CAN_BE_LEARNED_BY] = CanIMogIt.CAN_BE_LEARNED_BY,
    [NOT_TRANSMOGABLE] = CanIMogIt.NOT_TRANSMOGABLE,
    [CANNOT_DETERMINE] = CanIMogIt.CANNOT_DETERMINE,
}


local LEFT_TEXT_THRESHOLD = 200


-- Texts that we want to display on the left instead of right because of length.
local leftTexts = {}
for text, full_text in pairs(tooltipTexts) do
    if string.len(text) > LEFT_TEXT_THRESHOLD then
        leftTexts[full_text] = true
    end
end


local knownTexts = {
    [CanIMogIt.KNOWN] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = true,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = true,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = true,
    --[CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = true,
}


-----------------------------
-- Exceptions              --
-----------------------------


local exceptionItems = {
    [HEAD] = {},
    [SHOULDER] = {
        [119556] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders
        [119588] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons
    },
    [BODY] = {},
    [CHEST] = {},
    [ROBE] = {},
    [WAIST] = {},
    [LEGS] = {},
    [FEET] = {},
    [WRIST] = {},
    [HAND] = {
        [119585] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards
    },
    [CLOAK] = {},
    [WEAPON] = {},
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
    tooltip:AddLine(text, nil, nil, nil, true)
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

    local sourceID = CanIMogIt:GetSource(itemLink)
    if sourceID ~= nil then
        addDoubleLine(tooltip, "Item source:", tostring(sourceID))
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
    addDoubleLine(tooltip, "PlayerHasTransmog:", tostring(C_TransmogCollection.PlayerHasTransmog(itemID)))
    if sourceID then
        addDoubleLine(tooltip, "PlayerHasTransmogItemModifiedAppearance:", tostring(C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)))
    end

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "IsTransmogable:", tostring(CanIMogIt:IsTransmogable(itemLink)))
    addDoubleLine(tooltip, "PlayerKnowsTransmogFromItem:", tostring(CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)))
    addDoubleLine(tooltip, "PlayerKnowsTransmog:", tostring(CanIMogIt:PlayerKnowsTransmog(itemLink)))
    addDoubleLine(tooltip, "CharacterCanLearnTransmog:", tostring(CanIMogIt:CharacterCanLearnTransmog(itemLink)))

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "IsItemSoulbound:", tostring(CanIMogIt:IsItemSoulbound(itemLink)))
    addDoubleLine(tooltip, "CharacterCanEquipItem:", tostring(CanIMogIt:CharacterCanEquipItem(itemLink)))
    addDoubleLine(tooltip, "IsValidAppearanceForCharacter:", tostring(CanIMogIt:IsValidAppearanceForCharacter(itemLink)))
    addDoubleLine(tooltip, "CharacterIsTooLowLevelForItem:", tostring(CanIMogIt:CharacterIsTooLowLevelForItem(itemLink)))

    addLine(tooltip, '--------')

    -- addDoubleLine(tooltip, "Database GetItem:", tostring(CanIMogIt.Database:GetItem(itemLink)))
    -- addDoubleLine(tooltip, "Database GetAppearanceTable:", tostring(CanIMogIt.Database:GetAppearanceTable(itemLink)))

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


function CanIMogIt:GetAppearances()
    -- Gets a table of all the appearances known to a character.
    C_TransmogCollection.ClearSearch()
    local appearances = {}
    for categoryID=1,28 do
        categoryAppearances = C_TransmogCollection.GetCategoryAppearances(categoryID)
        for i, categoryAppearance in pairs(categoryAppearances) do
            if categoryAppearance.isCollected then
                appearances[categoryAppearance.visualID] = categoryAppearance
            end
        end
    end
    return appearances
end


function CanIMogIt:GetPlayerArmorTypeName()
    local playerArmorTypeID = classArmorTypeMap[select(2, UnitClass("player"))]
    return select(1, GetItemSubClassInfo(4, playerArmorTypeID))
end


function CanIMogIt:GetItemID(itemLink)
    return tonumber(itemLink:match("item:(%d+)"))
end


function CanIMogIt:GetItemLink(itemID)
    return select(2, CanIMogIt:GetItemInfo(itemID))
end


function CanIMogIt:GetItemQuality(itemID)
    return select(3, GetItemInfo(itemID))
end


function CanIMogIt:GetItemMinLevel(itemLink)
    return select(5, GetItemInfo(itemLink))
end


function CanIMogIt:GetItemClassName(itemLink)
    return select(6, GetItemInfo(itemLink))
end


function CanIMogIt:GetItemSubClassName(itemLink)
    return select(7, GetItemInfo(itemLink))
end


function CanIMogIt:GetItemSlotName(itemLink)
    return select(9, GetItemInfo(itemLink))
end


function CanIMogIt:IsItemArmor(itemLink)
    local itemClass = CanIMogIt:GetItemClassName(itemLink)
    if itemClass == nil then return end
    return GetItemClassInfo(4) == itemClass
end


function CanIMogIt:IsArmorSubClass(subClass, itemLink)
    local itemSubClass = CanIMogIt:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return select(1, GetItemSubClassInfo(4, subClass)) == itemSubClass
end


function CanIMogIt:IsArmorSubClassIdentical(itemLinkA, itemLinkB)
    local subClassA = CanIMogIt:GetItemSubClassName(itemLinkA)
    local subClassB = CanIMogIt:GetItemSubClassName(itemLinkB)
    if subClassA == nil or subClassB == nil then return end
    return subClassA == subClassB
end


function CanIMogIt:IsArmorCosmetic(itemLink)
    return CanIMogIt:IsArmorSubClass(COSMETIC, itemLink)
end


function CanIMogIt:IsArmorAppropriateForPlayer(itemLink)
    local playerArmorTypeID = CanIMogIt:GetPlayerArmorTypeName()
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == nil then return end
    local isArmorCosmetic = CanIMogIt:IsArmorCosmetic(itemLink)
    if isArmorCosmetic == nil then return end
    if armorTypeSlots[slotName] and isArmorCosmetic == false then 
        return playerArmorTypeID == CanIMogIt:GetItemSubClassName(itemLink)
    else
        return true
    end
end


function CanIMogIt:CharacterCanEquipItem(itemLink)
    if CanIMogIt:IsItemArmor(itemLink) and CanIMogIt:IsArmorCosmetic(itemLink) then
        return true
    end
    local itemID = CanIMogIt:GetItemID(itemLink)
    for i=1,28 do
        if C_TransmogCollection.IsCategoryValidForItem(i, itemID) then
            return true
        end
    end
    return false
end


function CanIMogIt:IsValidAppearanceForCharacter(itemLink)
    if CanIMogIt:CharacterCanEquipItem(itemLink) then
        if CanIMogIt:IsItemArmor(itemLink) then
            return CanIMogIt:IsArmorAppropriateForPlayer(itemLink)
        else
            return true
        end
    else
        return false
    end
end


function CanIMogIt:CharacterIsTooLowLevelForItem(itemLink)
    local minLevel = CanIMogIt:GetItemMinLevel(itemLink)
    if minLevel == nil then return end
    return UnitLevel("player") < minLevel
end


function CanIMogIt:IsItemSoulbound(itemLink)
	return CanIMogItTooltipScanner:IsItemSoulbound(itemLink)
end


function CanIMogIt:GetExceptionText(itemLink)
    -- Returns the exception text for this item, if it has one.
    local itemID = CanIMogIt:GetItemID(itemLink)
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == nil then return end
    local slotExceptions = exceptionItems[slotName]
    if slotExceptions then
        return slotExceptions[itemID]
    end
end


function CanIMogIt:IsEquippable(itemLink)
    -- Returns whether the item is equippable or not (exluding bags)
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == nil then return end
    return slotName ~= "" and slotName ~= BAG
end


function CanIMogIt:GetSource(itemLink)
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)
    local slots = inventorySlotsMap[slotName]

    if slots == nil or slots == false or IsDressableItem(itemLink) == false then return end
    CanIMogIt.DressUpModel:SetUnit('player')
    CanIMogIt.DressUpModel:Undress()
    for i, slot in pairs(slots) do
        CanIMogIt.DressUpModel:TryOn(itemLink, slot)
        local sourceID = CanIMogIt.DressUpModel:GetSlotTransmogSources(slot)
        if sourceID ~= 0 then return sourceID end
    end
end


function CanIMogIt:GetAppearanceID(itemLink)
    -- Gets the appearanceID of the given itemID.
    local sourceID = CanIMogIt:GetSource(itemLink)
    if sourceID then
        local appearanceID = select(2, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
        return appearanceID
    end
end


function CanIMogIt:PlayerKnowsTransmog(itemLink)
    -- Returns whether this item's appearance is already known by the player.
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    -- if appearanceID then self.Database:AddAppearanceSources(appearanceID) end
    -- appearanceTable = self.Database:GetAppearanceTable(itemLink)
    -- if appearanceTable == nil then return false end
    -- if CanIMogIt:IsItemArmor(itemLink) then
    --     for knownItemLink, bool in pairs(appearanceTable) do
    --         -- if itemLink armor type is the same as one of the knownItemLink armor types
    --         if CanIMogIt:IsArmorSubClassIdentical(itemLink, knownItemLink) then
    --             return true
    --         end
    --     end
    -- else
    --     -- Is not armor, don't worry about same appearance for different types
    --     return true
    -- end
    -- return false

    if appearanceID == nil then return false end
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


function CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
    -- Returns whether the transmog is known from this item specifically.
    -- local itemID = CanIMogIt:GetItemID(itemLink)
    -- local hasTransmog = C_TransmogCollection.PlayerHasTransmog(itemID)
    -- if hasTransmog == false then
    --     for i=1,12 do
    --         hasTransmog = C_TransmogCollection.PlayerHasTransmog(itemID, i)
    --         if hasTransmog then
    --             return true
    --         end
    --     end
    -- end
    -- CanIMogIt.Database:UpdateItem(itemLink, hasTransmog)

    local hasTransmog;
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == TABARD then
        local itemID = CanIMogIt:GetItemID(itemLink)
        return C_TransmogCollection.PlayerHasTransmog(itemID)
    end
    local sourceID = CanIMogIt:GetSource(itemLink)
    if sourceID == nil then return false end
    hasTransmog = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
    return hasTransmog
end


function CanIMogIt:CharacterCanLearnTransmog(itemLink)
    -- Returns whether the player can learn the item or not.
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == TABARD then return true end
    local sourceID = CanIMogIt:GetSource(itemLink)
    if sourceID == nil then return false end
    if select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID)) then
        return true
    end
    return false
end


function CanIMogIt:IsTransmogable(itemLink)
    -- Returns whether the item is transmoggable or not.

    -- White items are not transmoggable.
    local quality = CanIMogIt:GetItemQuality(itemLink)
    if quality == nil then return end
    if quality <= 1 then
        return false
    end

    local is_misc_subclass = CanIMogIt:IsArmorSubClass(MISC, itemLink)
    if is_misc_subclass and miscArmorExceptions[CanIMogIt:GetItemSlotName(itemLink)] == nil then
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


function CanIMogIt:TextIsKnown(text)
    -- Returns whether the text is considered to be a KNOWN value or not.
    return knownTexts[text] or false
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
            if CanIMogIt:IsValidAppearanceForCharacter(itemLink) then
                if CanIMogIt:CharacterIsTooLowLevelForItem(itemLink) then
                    text = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
                else
                    text = CanIMogIt.KNOWN
                end
            else
                text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
            end
        elseif CanIMogIt:PlayerKnowsTransmog(itemLink) then
            if CanIMogIt:IsValidAppearanceForCharacter(itemLink) then
                if CanIMogIt:CharacterIsTooLowLevelForItem(itemLink) then
                    text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                else
                    text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
                end
            else
                text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
            end
        else
            if CanIMogIt:CharacterCanLearnTransmog(itemLink) then
                -- Set text to UNKNOWN
                text = CanIMogIt.UNKNOWN
            else
                if CanIMogIt:IsItemSoulbound(itemLink) then
                    text = CanIMogIt.UNKNOWABLE_BY_CHARACTER_SOULBOUND
                else
                    text = CanIMogIt.UNKNOWABLE_BY_CHARACTER
                end
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
    
    -- TODO: caching doesn't work when the compare tooltip is visible.
    -- if CanIMogIt.cachedItemLink ~= itemLink then
    --     print("itemLink changed! " .. itemLink)
    -- end
    local itemInfo = GetItemInfo(itemLink)
    if itemInfo == nil then 
        CanIMogIt.cachedItemLink = nil
        CanIMogIt.cachedTooltipText = nil
        return 
    end
    
    local ok;
    if CanIMogItOptions["debug"] then
        -- ok = pcall(printDebug, CanIMogIt.tooltip, itemLink)
        -- if not ok then return end
        printDebug(CanIMogIt.tooltip, itemLink)
    end
    
    local text;
    -- Checking against the cached item first.
    if itemLink == CanIMogIt.cachedItemLink then
        text = CanIMogIt.cachedTooltipText
    else
        -- ok, text = pcall(CanIMogIt.GetTooltipText, CanIMogIt, itemLink)
        -- if not ok then return end
        text = CanIMogIt.GetTooltipText(CanIMogIt, itemLink)
        -- Save the cached item and text, so it's faster next time.
        CanIMogIt.cachedItemLink = itemLink
        CanIMogIt.cachedTooltipText = text
    end
    if CanIMogItOptions["showTransmoggableOnly"] and text == CanIMogIt.NOT_TRANSMOGABLE then
        -- If we don't want to show the tooltip if it's not transmoggable
        return
    end
    if CanIMogItOptions["showUnknownOnly"] and CanIMogIt:TextIsKnown(text) then
        -- We don't want to show the tooltip if it's already known.
        return
    end
    if text then
        if leftTexts[text] then
            addLine(tooltip, text)
        else
            addDoubleLine(tooltip, " ", text)
        end
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
