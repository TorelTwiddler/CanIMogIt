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


-- Built-in colors
-- TODO: move to constants
local BLIZZARD_RED = "|cffff1919"


-------------------------
-- Text related tables --
-------------------------


-- Maps a text to its simpler version
local simpleTextMap = {
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN,
}


-- Texts that we want to display on the left instead of right because of length.
local LEFT_TEXT_THRESHOLD = 200

local leftTexts = {}
for text, full_text in pairs(CanIMogIt.tooltipTexts) do
    if string.len(text) > LEFT_TEXT_THRESHOLD then
        leftTexts[full_text] = true
    end
end


-- List of all Known texts
local knownTexts = {
    [CanIMogIt.KNOWN] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = true,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = true,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = true,
}


-- List of all Unknown texts
local unknownTexts = {
    [CanIMogIt.UNKNOWN] = true,
    [CanIMogIt.UNKNOWABLE_BY_CHARACTER] = true,
}


-----------------------------
-- Exceptions              --
-----------------------------


local exceptionItems = {
    [HEAD] = {
        [134110] = CanIMogIt.KNOWN, -- Hidden Helm
        [133320] = CanIMogIt.KNOWN, -- Illidari Blindfold (Alliance)
        [112450] = CanIMogIt.KNOWN, -- Illidari Blindfold (Horde)
    },
    [SHOULDER] = {
        [119556] = CanIMogIt.KNOWN, -- Trailseeker Spaulders
        [119588] = CanIMogIt.KNOWN, -- Mistdancer Pauldrons
        [134112] = CanIMogIt.KNOWN, -- Hidden Shoulders
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


local function printDebug(tooltip, itemLink, bag, slot)
    -- Add debug statements to the tooltip, to make it easier to understand
    -- what may be going wrong.

    addDoubleLine(tooltip, "Addon Version:", GetAddOnMetadata("CanIMogIt", "Version"))
    local playerClass = select(2, UnitClass("player"))
    local playerLevel = UnitLevel("player")
    local playerSpec = GetSpecialization()
    local playerSpecName = playerSpec and select(2, GetSpecializationInfo(playerSpec)) or "None"
    addDoubleLine(tooltip, "Player Class:", playerClass)
    addDoubleLine(tooltip, "Player Spec:", playerSpecName)
    addDoubleLine(tooltip, "Player Level:", playerLevel)

    addLine(tooltip, '--------')

    local itemID = CanIMogIt:GetItemID(itemLink)
    addDoubleLine(tooltip, "Item ID:", tostring(itemID))
    local _, _, quality, _, _, itemClass, itemSubClass, _, equipSlot = GetItemInfo(itemID)
    addDoubleLine(tooltip, "Item quality:", tostring(quality))
    addDoubleLine(tooltip, "Item class:", tostring(itemClass))
    addDoubleLine(tooltip, "Item subClass:", tostring(itemSubClass))
    addDoubleLine(tooltip, "Item equipSlot:", tostring(equipSlot))

    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if sourceID ~= nil then
        addDoubleLine(tooltip, "Item sourceID:", tostring(sourceID))
    else
        addDoubleLine(tooltip, "Item sourceID:", 'nil')
    end
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    addDoubleLine(tooltip, "Item appearanceID:", tostring(appearanceID))

    addLine(tooltip, '--------')

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

    addDoubleLine(tooltip, "IsTransmogable:", tostring(CanIMogIt:IsTransmogable(itemLink)))
    local playerKnowsTransmogFromItem = CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
    if playerKnowsTransmogFromItem ~= nil then
        addDoubleLine(tooltip, "PlayerKnowsTransmogFromItem:", tostring(playerKnowsTransmogFromItem))
    end

    local playerKnowsTrasmog = CanIMogIt:_PlayerKnowsTransmog(itemLink, appearanceID)
    if playerKnowsTrasmog ~= nil then
        addDoubleLine(tooltip, "PlayerKnowsTransmog:", tostring(playerKnowsTrasmog))
    end
    local characterCanLearnTransmog = CanIMogIt:CharacterCanLearnTransmog(itemLink)
    if characterCanLearnTransmog ~= nil then
        addDoubleLine(tooltip, "CharacterCanLearnTransmog:", tostring(characterCanLearnTransmog))
    end

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "IsItemSoulbound:", tostring(CanIMogIt:IsItemSoulbound(itemLink, bag, slot)))
    addDoubleLine(tooltip, "CharacterCanEquipItem:", tostring(CanIMogIt:CharacterCanEquipItem(itemLink)))
    addDoubleLine(tooltip, "IsValidAppearanceForCharacter:", tostring(CanIMogIt:IsValidAppearanceForCharacter(itemLink)))
    addDoubleLine(tooltip, "CharacterIsTooLowLevelForItem:", tostring(CanIMogIt:CharacterIsTooLowLevelForItem(itemLink)))

    addLine(tooltip, '--------')

    if appearanceID ~= nil then
        addDoubleLine(tooltip, "DBHasAppearance:", tostring(CanIMogIt:DBHasAppearance(appearanceID)))
    else
        addDoubleLine(tooltip, "DBHasAppearance:", 'nil')
    end

    if appearanceID ~= nil and sourceID ~= nil then
        addDoubleLine(tooltip, "DBHasSource:", tostring(CanIMogIt:DBHasSource(appearanceID, sourceID)))
    else
        addDoubleLine(tooltip, "DBHasSource:", 'nil')
    end
    if CanIMogIt:DBHasItem(itemLink) ~= nil then
        addDoubleLine(tooltip, "DBHasItem:", tostring(CanIMogIt:DBHasItem(itemLink)))
    else
        addDoubleLine(tooltip, "DBHasItem:", 'nil')
    end
end


-----------------------------
-- CanIMogIt variables     --
-----------------------------


CanIMogIt.tooltip = nil;
CanIMogIt.cache = {}


-----------------------------
-- Helper functions        --
-----------------------------


function pairsByKeys (t, f)
    -- returns a sorted iterator for a table.
    -- https://www.lua.org/pil/19.3.html
    -- Why is it not a built in function? ¯\_(ツ)_/¯
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
            else return a[i], t[a[i]]
        end
    end
    return iter
end


function copyTable (t)
    -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    return target
end


-----------------------------
-- CanIMogIt Core methods  --
-----------------------------

-- Variables for managing updating appearances.
local appearanceIndex = 0
local sourceIndex = 0
local getAppearancesDone = false;
local sourceCount = 0
local appearanceCount = 0
local buffer = 0
local sourcesAdded = 0
local sourcesRemoved = 0


local appearancesTable = {}
local removeAppearancesTable = nil
local appearancesTableGotten = false
local doneAppearances = {}


local function GetAppearancesTable()
    -- Sort the C_TransmogCollection.GetCategoryAppearances tables into something
    -- more usable.
    if appearancesTableGotten then return end
    for categoryID=1,28 do
        local categoryAppearances = C_TransmogCollection.GetCategoryAppearances(categoryID)
        for i, categoryAppearance in pairs(categoryAppearances) do
            if categoryAppearance.isCollected then
                appearanceCount = appearanceCount + 1
                appearancesTable[categoryAppearance.visualID] = true
            end
        end
    end
    appearancesTableGotten = true
end


local function AddSource(source, appearanceID)
    -- Adds the source to the database, and increments the buffer.
    buffer = buffer + 1
    sourceCount = sourceCount + 1
    local sourceID = source.sourceID
    local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
    local added = CanIMogIt:DBAddItem(sourceItemLink, appearanceID, sourceID)
    if added then
        sourcesAdded = sourcesAdded + 1
    end
end


local function AddAppearance(appearanceID)
    -- Adds all of the sources for this appearanceID to the database.
    -- returns early if the buffer is reached.
    sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    for i, source in pairs(sources) do
        if source.isCollected then
            AddSource(source, appearanceID)
        end
    end
end


local function _GetAppearances()
    -- Core logic for getting the appearances.
    if getAppearancesDone then return end
    C_TransmogCollection.ClearSearch()
    GetAppearancesTable()
    buffer = 0

    -- Add new appearances learned.
    for appearanceID, collected in pairsByKeys(appearancesTable) do
        AddAppearance(appearanceID)
        if buffer >= CanIMogIt.bufferMax then return end
        appearancesTable[appearanceID] = nil
    end

    -- Remove appearances that are no longer learned.
    for appearanceID, sources in pairsByKeys(removeAppearancesTable) do
        for sourceID, source in pairs(sources.sources) do
            if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
                CanIMogIt:DBRemoveItem(appearanceID, sourceID)
                sourcesRemoved = sourcesRemoved + 1
            end
            buffer = buffer + 1
        end
        if buffer >= CanIMogIt.bufferMax then return end
        removeAppearancesTable[appearanceID] = nil
    end

    getAppearancesDone = true
    appearancesTable = {} -- cleanup
    CanIMogIt:ResetCache()
    CanIMogIt.frame:SetScript("OnUpdate", nil)
    CanIMogIt:Print(CanIMogIt.DATABASE_DONE_UPDATE_TEXT..CanIMogIt.BLUE.."+" .. sourcesAdded .. ", "..CanIMogIt.ORANGE.."-".. sourcesRemoved)
end


local timer = 0
local function GetAppearancesOnUpdate(self, elapsed)
    -- OnUpdate function with a reset timer to throttle getting appearances.
    timer = timer + elapsed
    if timer >= CanIMogIt.throttleTime then
        _GetAppearances()
        timer = 0
    end
end


function CanIMogIt:GetAppearances()
    -- Gets a table of all the appearances known to
    -- a character and adds it to the database.
    CanIMogIt:Print(CanIMogIt.DATABASE_START_UPDATE_TEXT)
    removeAppearancesTable = copyTable(CanIMogIt.db.global.appearances)
    CanIMogIt.frame:SetScript("OnUpdate", GetAppearancesOnUpdate)
end


function CanIMogIt:ResetCache()
    -- Resets the cache, and calls things relying on the cache being reset.
    CanIMogIt.cache = {}
    -- Fake a BAG_UPDATE event to updating the icons.
    CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
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


function CanIMogIt:GetItemLinkFromSourceID(sourceID)
    return select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
end


function CanIMogIt:GetItemQuality(itemID)
    return select(3, GetItemInfo(itemID))
end


function CanIMogIt:GetItemMinLevel(itemLink)
    return select(5, GetItemInfo(itemLink))
end


function CanIMogIt:GetItemClassName(itemLink)
    return select(2, GetItemInfoInstant(itemLink))
end


function CanIMogIt:GetItemSubClassName(itemLink)
    return select(3, GetItemInfoInstant(itemLink))
end


function CanIMogIt:GetItemSlotName(itemLink)
    return select(4, GetItemInfoInstant(itemLink))
end


function CanIMogIt:IsItemArmor(itemLink)
    local itemClass = CanIMogIt:GetItemClassName(itemLink)
    if itemClass == nil then return end
    return GetItemClassInfo(4) == itemClass
end


function CanIMogIt:IsArmorSubClassID(subClassID, itemLink)
    local itemSubClass = CanIMogIt:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return select(1, GetItemSubClassInfo(4, subClassID)) == itemSubClass
end


function CanIMogIt:IsArmorSubClassName(subClassName, itemLink)
    local itemSubClass = CanIMogIt:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return subClassName == itemSubClass
end


function CanIMogIt:IsItemSubClassIdentical(itemLinkA, itemLinkB)
    local subClassA = CanIMogIt:GetItemSubClassName(itemLinkA)
    local subClassB = CanIMogIt:GetItemSubClassName(itemLinkB)
    if subClassA == nil or subClassB == nil then return end
    return subClassA == subClassB
end


function CanIMogIt:IsArmorCosmetic(itemLink)
    return CanIMogIt:IsArmorSubClassID(COSMETIC, itemLink)
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


function CanIMogIt:IsItemSoulbound(itemLink, bag, slot)
    if not bag and slot then return false end
    return CanIMogItTooltipScanner:IsItemSoulbound(bag, slot)
end


function CanIMogIt:GetItemClassRestrictions(itemLink)
    if not itemLink then return end
    return CanIMogItTooltipScanner:GetClassesRequired(itemLink)
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


function CanIMogIt:GetSourceID(itemLink)
    -- Gets the sourceID for the item.
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)
    local slots = inventorySlotsMap[slotName]

    if slots == nil or slots == false or IsDressableItem(itemLink) == false then return end
    CanIMogIt.DressUpModel:SetUnit('player')
    CanIMogIt.DressUpModel:Undress()
    for i, slot in pairs(slots) do
        CanIMogIt.DressUpModel:TryOn(itemLink, slot)
        local sourceID = CanIMogIt.DressUpModel:GetSlotTransmogSources(slot)
        if sourceID ~= 0 then
            return sourceID
        end
    end
end


function CanIMogIt:GetAppearanceID(itemLink)
    -- Gets the appearanceID of the given item. Also returns the sourceID, for convenience.
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    return CanIMogIt:GetAppearanceIDFromSourceID(sourceID), sourceID
end


function CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
    -- Gets the appearanceID from the sourceID.
    if sourceID ~= nil then
        local appearanceID = select(2, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
        return appearanceID
    end
end


function CanIMogIt:_PlayerKnowsTransmog(itemLink, appearanceID)
    -- Internal logic for determining if the item is known or not.
    -- Does not use the CIMI database.
    if itemLink == nil or appearanceID == nil then return end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    if sources then
        for i, source in pairs(sources) do
            local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(source.sourceID)
            if CanIMogIt:IsItemSubClassIdentical(itemLink, sourceItemLink) and source.isCollected then
                return true
            end
        end
    end
    return false
end


function CanIMogIt:PlayerKnowsTransmog(itemLink)
    -- Returns whether this item's appearance is already known by the player.
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    if appearanceID == nil then return false end
    if CanIMogIt:DBHasAppearance(appearanceID) then
        -- if CanIMogIt:IsItemArmor(itemLink) then
            -- The character knows the appearance, check that it's from the same armor type.
        for sourceID, knownItem in pairs(CanIMogIt:DBGetSources(appearanceID)) do
            if CanIMogIt:IsArmorSubClassName(knownItem.subClass, itemLink) then
                return true
            end
        end
        -- else
        --     -- ???Is not armor, don't worry about same appearance for different types ???
        --     return true
        -- end
    end

    -- Don't know from the database, try using the API.
    local knowsTransmog = CanIMogIt:_PlayerKnowsTransmog(itemLink, appearanceID)
    if knowsTransmog then
        CanIMogIt:DBAddItem(itemLink)
    end
    return knowsTransmog
end


function CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
    -- Returns whether the transmog is known from this item specifically.
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == TABARD then
        local itemID = CanIMogIt:GetItemID(itemLink)
        return C_TransmogCollection.PlayerHasTransmog(itemID)
    end
    local appearanceID, sourceID = CanIMogIt:GetAppearanceID(itemLink)
    if sourceID == nil then return end
    
    -- First check the Database
    if CanIMogIt:DBHasSource(appearanceID, sourceID) then
        return true
    end

    local hasTransmog;
    hasTransmog = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)

    -- Update Database
    if hasTransmog then
        CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
    end

    return hasTransmog
end


function CanIMogIt:CharacterCanLearnTransmog(itemLink)
    -- Returns whether the player can learn the item or not.
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == TABARD then return true end
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if sourceID == nil then return end
    if select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID)) then
        return true
    end
    return false
end


function CanIMogIt:GetReason(itemLink)
    local reason = CanIMogItTooltipScanner:GetRedText(itemLink)
    if reason == "" then
        reason = CanIMogIt:GetItemSubClassName(itemLink)
    end
    return reason
end


function CanIMogIt:IsTransmogable(itemLink)
    -- Returns whether the item is transmoggable or not.

    -- White items are not transmoggable.
    local quality = CanIMogIt:GetItemQuality(itemLink)
    if quality == nil then return end
    if quality <= 1 then
        return false
    end

    local is_misc_subclass = CanIMogIt:IsArmorSubClassID(MISC, itemLink)
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


function CanIMogIt:TextIsUnknown(unmodifiedText)
    -- Returns whether the text is considered to be an UNKNOWN value or not.
    return unknownTexts[unmodifiedText] or false
end


function CanIMogIt:PreLogicOptionsContinue(itemLink)
    -- Apply the options. Returns false if it should stop the logic.
    if CanIMogItOptions["showEquippableOnly"] and 
            not CanIMogIt:IsEquippable(itemLink) then
        -- Don't bother if it's not equipable.
        return false
    end

    return true
end


function CanIMogIt:PostLogicOptionsText(text, unmodifiedText)
    -- Apply the options to the text. Returns the relevant text.
    
    if CanIMogItOptions["showUnknownOnly"] and not CanIMogIt:TextIsUnknown(unmodifiedText) then
        -- We don't want to show the tooltip if it's already known.
        return "", ""
    end

    if CanIMogItOptions["showTransmoggableOnly"] and unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE then
        -- If we don't want to show the tooltip if it's not transmoggable
        return "", ""
    end

    if not CanIMogItOptions["showVerboseText"] then
        text = simpleTextMap[text] or text
    end

    return text, unmodifiedText
end


local foundAnItemFromBags = false


function CanIMogIt:GetTooltipText(itemLink, bag, slot)
    --[[
        Gets the text to display on the tooltip from the itemLink.

        If bag and slot are given, this will use the itemLink from 
        bag and slot instead.

        Returns two things:
            the text to display.
            the unmodifiedText that can be used for lookup values.
    ]]
    if bag and slot then
        itemLink = GetContainerItemLink(bag, slot)
        if not itemLink then
            if foundAnItemFromBags then
                return "", ""
            else
                -- If we haven't found any items in the bags yet, then
                -- it's likely that the inventory hasn't been loaded yet.
                return nil
            end
        else
            foundAnItemFromBags = true
        end
    end
    if not itemLink then return "", "" end
    local text = ""
    local unmodifiedText = ""

    -- Must have GetItemInfo available for item.
    local itemInfo = GetItemInfo(itemLink)
    if itemInfo == nil then return end

    if not CanIMogIt:PreLogicOptionsContinue(itemLink) then return "", "" end

    -- Return cached items
    if CanIMogIt.cache[itemLink] then
        cachedText, cachedUnmodifiedText = unpack(CanIMogIt.cache[itemLink])
        return cachedText, cachedUnmodifiedText
    end

    local exception_text = CanIMogIt:GetExceptionText(itemLink)
    if exception_text then
        return exception_text
    end

    local isTransmogable = CanIMogIt:IsTransmogable(itemLink)
    -- if isTransmogable == nil then return end

    local playerKnowsTransmogFromItem, isValidAppearanceForCharacter, characterIsTooLowLevel,
        playerKnowsTransmog, characterCanLearnTransmog, isItemSoulbound;

    if isTransmogable then

        playerKnowsTransmogFromItem = CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
        if playerKnowsTransmogFromItem == nil then return end

        isValidAppearanceForCharacter = CanIMogIt:IsValidAppearanceForCharacter(itemLink)
        if isValidAppearanceForCharacter == nil then return end

        characterIsTooLowLevel = CanIMogIt:CharacterIsTooLowLevelForItem(itemLink)
        if characterIsTooLowLevel == nil then return end

        playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmog(itemLink)
        if playerKnowsTransmog == nil then return end

        if playerKnowsTransmogFromItem then
            if isValidAppearanceForCharacter then
                if characterIsTooLowLevel then
                    text = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
                    unmodifiedText = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
                else
                    text = CanIMogIt.KNOWN
                    unmodifiedText = CanIMogIt.KNOWN
                end
            else
                text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
                unmodifiedText = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
            end
        elseif playerKnowsTransmog then
            if isValidAppearanceForCharacter then
                if characterIsTooLowLevel then
                    text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                    unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                else
                    text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
                    unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
                end
            else
                text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
                unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
            end
        else
            characterCanLearnTransmog = CanIMogIt:CharacterCanLearnTransmog(itemLink)
            if characterCanLearnTransmog == nil then return end

            if characterCanLearnTransmog then
                text = CanIMogIt.UNKNOWN
                unmodifiedText = CanIMogIt.UNKNOWN
            else
                isItemSoulbound = CanIMogIt:IsItemSoulbound(itemLink, bag, slot)
                if isItemSoulbound == nil then return end

                if isItemSoulbound then
                    text = CanIMogIt.UNKNOWABLE_SOULBOUND
                            .. BLIZZARD_RED .. CanIMogIt:GetReason(itemLink)
                    unmodifiedText = CanIMogIt.UNKNOWABLE_SOULBOUND
                else
                    text = CanIMogIt.UNKNOWABLE_BY_CHARACTER
                            .. BLIZZARD_RED .. CanIMogIt:GetReason(itemLink)
                    unmodifiedText = CanIMogIt.UNKNOWABLE_BY_CHARACTER
                end
            end
        end
    else
        text = CanIMogIt.NOT_TRANSMOGABLE
        unmodifiedText = CanIMogIt.NOT_TRANSMOGABLE
    end

    text = CanIMogIt:PostLogicOptionsText(text, unmodifiedText)

    -- Update cached items
    if text ~= nil then
        CanIMogIt.cache[itemLink] = {text, unmodifiedText}
    end

    return text, unmodifiedText
end

-----------------------------
-- Tooltip hooks           --
-----------------------------


local function addToTooltip(tooltip, itemLink)
    -- Does the calculations for determining what text to
    -- display on the tooltip.
    local itemInfo = GetItemInfo(itemLink)
    if itemInfo == nil then
        return
    end

    local bag, slot;
    if tooltip:GetOwner() and tooltip:GetOwner():GetName() 
            and tooltip:GetOwner():GetName():find("ContainerFrame") then
        -- Get the bag and slot, if it's in the inventory.
        bag, slot = tooltip:GetOwner():GetParent():GetID(), tooltip:GetOwner():GetID()
    end

    -- local ok;
    if CanIMogItOptions["debug"] then
        -- ok = pcall(printDebug, CanIMogIt.tooltip, itemLink)
        -- if not ok then return end
        printDebug(CanIMogIt.tooltip, itemLink, bag, slot)
    end

    local text;
    -- ok, text = pcall(CanIMogIt.GetTooltipText, CanIMogIt, itemLink)
    -- if not ok then return end
    text = CanIMogIt.GetTooltipText(CanIMogIt, itemLink, bag, slot)
    if text and text ~= "" then
        if leftTexts[text] then
            addLine(tooltip, text)
        else
            addDoubleLine(tooltip, " ", text)
        end
    end
end


function CanIMogIt_AttachItemTooltip(self)
    -- Hook for normal tooltips.
    CanIMogIt.tooltip = self
    local link = select(2, self:GetItem())
    if link then
        addToTooltip(CanIMogIt.tooltip, link)
    end
end


GameTooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)
WorldMapTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", CanIMogIt_AttachItemTooltip)


function CanIMogIt_OnSetHyperlink(self, link)
    -- Hook for Hyperlinked tooltips.
    CanIMogIt.tooltip = self
    local type, id = string.match(link, "^(%a+):(%d+)")
    if not type or not id then return end
    if type == "item" then
        addToTooltip(CanIMogIt.tooltip, link)
    end
end


hooksecurefunc(GameTooltip, "SetHyperlink", CanIMogIt_OnSetHyperlink)
