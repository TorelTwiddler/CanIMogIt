-- This file is loaded from "CanIMogIt.toc"

local L = CanIMogIt.L

CanIMogIt.DressUpModel = CreateFrame('DressUpModel')
CanIMogIt.DressUpModel:SetUnit('player')


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
local NONEQUIP = "INVTYPE_NON_EQUIP_IGNORE"


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
    [TABARD] = {19},
}


-- This is a one-time call to get a "transmogLocation" object, which we don't actually care about,
-- but some functions require it now.
local transmogLocation = TransmogUtil.GetTransmogLocation(inventorySlotsMap[HEAD][1], Enum.TransmogType.Appearance, Enum.TransmogModification.Main)


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
    ["EVOKER"] = MAIL,
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


-- Class Masks
local classMask = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [4] = "HUNTER",
    [8] = "ROGUE",
    [16] = "PRIEST",
    [32] = "DEATHKNIGHT",
    [64] = "SHAMAN",
    [128] = "MAGE",
    [256] = "WARLOCK",
    [512] = "MONK",
    [1024] = "DRUID",
    [2048] = "DEMONHUNTER",
    [4096] = "EVOKER",
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


local APPEARANCES_ITEMS_TAB = 1
local APPEARANCES_SETS_TAB = 2


-- Get the name for Cosmetic. Uses http://www.wowhead.com/item=130064/deadeye-monocle.
local COSMETIC_NAME = select(3, C_Item.GetItemInfoInstant(130064))


-------------------------
-- Text related tables --
-------------------------


-- Maps a text to its simpler version
local simpleTextMap = {
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE] = CanIMogIt.KNOWN_BOE,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
}


-- List of all Known texts
local knownTexts = {
    [CanIMogIt.KNOWN] = true,
    [CanIMogIt.KNOWN_BOE] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE] = true,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = true,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = true,
}


local unknownTexts = {
    [CanIMogIt.UNKNOWN] = true,
    [CanIMogIt.UNKNOWABLE_BY_CHARACTER] = true,
}


-----------------------------
-- Exceptions              --
-----------------------------

-- This is a list of exceptions with a key of their itemID and a value of what their result should be.

local exceptionItems = {
    [HEAD] = {
        -- [134110] = CanIMogIt.KNOWN, -- Hidden Helm
        [133320] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Alliance)
        [112450] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Horde)
        -- [150726] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Alliance) - starting item
        -- [150716] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Horde) - starting item
    },
    [SHOULDER] = {
        [119556] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 Salvage Yard ilvl 610
        [117106] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 90 boost ilvl 483
        [129714] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 trial/boost ilvl 640
        [150642] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 trial/boost ilvl 600
        [153810] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 110 trial/boost ilvl 870
        [162796] = CanIMogIt.NOT_TRANSMOGABLE, -- Wildguard Spaulders - 8.0 BfA Pre-Patch event
        [119588] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 Salvage Yard ilvl 610
        [117138] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 90 boost ilvl 483
        [129485] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 trial/boost ilvl 640
        [150658] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 trial/boost ilvl 600
        [153842] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 110 trial/boost ilvl 870
        [162812] = CanIMogIt.NOT_TRANSMOGABLE, -- Serene Disciple's Padding - 8.0 BfA Pre-Patch event
        [134112] = CanIMogIt.KNOWN, -- Hidden Shoulders
    },
    [BODY] = {},
    [CHEST] = {},
    [ROBE] = {},
    [WAIST] = {
        [143539] = CanIMogIt.KNOWN, -- Hidden Belt
    },
    [LEGS] = {},
    [FEET] = {},
    [WRIST] = {},
    [HAND] = {
        [119585] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 Salvage Yard ilvl 610
        [117135] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 90 boost ilvl 483
        [129482] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 trial/boost ilvl 640
        [150655] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 trial/boost ilvl 600
        [153839] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 110 trial/boost ilvl 870
        [162809] = CanIMogIt.NOT_TRANSMOGABLE, -- Serene Disciple's Handguards - 8.0 BfA Pre-Patch event
    },
    [CLOAK] = {
        -- [134111] = CanIMogIt.KNOWN, -- Hidden Cloak
        [112462] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Drape
    },
    [WEAPON] = {},
    [SHIELD] = {},
    [WEAPON_2HAND] = {},
    [WEAPON_MAIN_HAND] = {},
    [RANGED] = {},
    [RANGED_RIGHT] = {},
    [WEAPON_OFF_HAND] = {},
    [HOLDABLE] = {},
    [TABARD] = {
        -- [142504] = CanIMogIt.KNOWN, -- Hidden Tabard
    },
}


-----------------------------
-- Helper functions        --
-----------------------------

CanIMogIt.Utils = {}


function CanIMogIt.Utils.pairsByKeys (t, f)
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


function CanIMogIt.Utils.copyTable (t)
    -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    return target
end


function CanIMogIt.Utils.spairs(t, order)
    -- Returns an iterator that is a sorted table. order is the function to sort by.
    -- http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    -- Again, why is this not a built in function? ¯\_(ツ)_/¯

    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function CanIMogIt.Utils.strsplit(delimiter, text)
    -- from http://lua-users.org/wiki/SplitJoin
    -- Split text into a list consisting of the strings in text,
    -- separated by strings matching delimiter (which may be a pattern).
    -- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
    local list = {}
    local pos = 1
    if string.find("", delimiter, 1) then -- this would result in endless loops
       error("delimiter matches empty string!")
    end
    while 1 do
       local first, last = string.find(text, delimiter, pos)
       if first then -- found?
          table.insert(list, string.sub(text, pos, first-1))
          pos = last+1
       else
          table.insert(list, string.sub(text, pos))
          break
       end
    end
    return list
end


function CanIMogIt.Utils.tablelength(T)
    -- Count the number of keys in a table, because tables don't bother
    -- counting themselves if it's filled with key-value pairs...
    -- ¯\_(ツ)_/¯
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function CanIMogIt.Utils.GetKeys(T)
    --- Get an array of the keys from a table.
    local result = {}
    for key, _ in pairs(T) do
        table.insert(result, key)
    end
    return result
end


-----------------------------
-- CanIMogIt Core methods  --
-----------------------------


function CIMI_GetVariantSets(setID)
    --[[
        It seems that C_TransmogSets.GetVariantSets(setID) returns a number
        (instead of the expected table of sets) if it can't find a matching
        base set. We currently are checking that it's returning a table first
        to prevent issues.
    ]]
    local variantSets = C_TransmogSets.GetVariantSets(setID)
    if type(variantSets) == "table" then
        return variantSets
    end
    return {}
end


function CanIMogIt:GetSets()
    -- Gets a table of all of the sets available to the character,
    -- along with their items, and adds them to the sets database.
    C_TransmogCollection.ClearSearch(APPEARANCES_SETS_TAB)
    for i, set in pairs(C_TransmogSets.GetAllSets()) do
        -- This is a base set, so we need to get the variant sets as well
        for i, sourceID in pairs(C_TransmogSets.GetAllSourceIDs(set.setID)) do
            CanIMogIt:SetsDBAddSetItem(set, sourceID)
        end
        for i, variantSet in pairs(CIMI_GetVariantSets(set.setID)) do
            for i, sourceID in pairs(C_TransmogSets.GetAllSourceIDs(variantSet.setID)) do
                CanIMogIt:SetsDBAddSetItem(variantSet, sourceID)
            end
        end
    end
end
CanIMogIt.GetSets = CanIMogIt.RetailWrapper(CanIMogIt.GetSets)


function CanIMogIt.GetRatio(setID)
    -- Gets the count of known and total sources for the given setID.
    local have = 0
    local total = 0
    for _, appearance in pairs(C_TransmogSets.GetSetPrimaryAppearances(setID)) do
        total = total + 1
        if appearance.collected then
            have = have + 1
        end
    end
    return have, total
end


function CanIMogIt.GetRatioTextColor(have, total)
    if have == total then
        return CanIMogIt.BLUE
    elseif have > 0 then
        return CanIMogIt.RED_ORANGE
    else
        return CanIMogIt.GRAY
    end
end


function CanIMogIt.GetRatioText(setID)
    -- Gets the ratio text (and color) of known/total for the given setID.
    local have, total = CanIMogIt.GetRatio(setID)

    local ratioText = CanIMogIt.GetRatioTextColor(have, total)
    ratioText = ratioText .. "(" .. have .. "/" .. total .. ")"
    return ratioText
end


function CanIMogIt:GetSetClass(set)
    --[[
        Returns the set's class. If it belongs to more than one class,
        return an empty string.

        This is done based on the player's sex.
        Player's sex
        1 = Neutrum / Unknown
        2 = Male
        3 = Female
    ]]
    local playerSex = UnitSex("player")
    local className
    if playerSex == 2 then
        className = LOCALIZED_CLASS_NAMES_MALE[classMask[set.classMask]]
    else
        className = LOCALIZED_CLASS_NAMES_FEMALE[classMask[set.classMask]]
    end
    return className or ""
end


local classSetIDs = nil


function CanIMogIt:CalculateSetsText(itemLink)
    --[[
        Gets the two lines of text to display on the tooltip related to sets.

        Example:

        Demon Hunter: Garb of the Something or Other
        Ulduar: 25 Man Normal (2/8)

        This function is not cached, so avoid calling often!
        Use GetSetsText whenever possible!
    ]]
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if not sourceID then return end
    local setID = CanIMogIt:SetsDBGetSetFromSourceID(sourceID)
    if not setID then return end

    local set = C_TransmogSets.GetSetInfo(setID)

    local ratioText = CanIMogIt.GetRatioText(setID)

    -- Build the classSetIDs table, if it hasn't been built yet.
    if classSetIDs == nil then
        classSetIDs = {}
        for i, baseSet in pairs(C_TransmogSets.GetBaseSets()) do
            classSetIDs[baseSet.setID] = true
            for i, variantSet in pairs(C_TransmogSets.GetVariantSets(baseSet.setID)) do
                classSetIDs[variantSet.setID] = true
            end
        end
    end

    local setNameColor, otherClass
    if classSetIDs[set.setID] then
        setNameColor = CanIMogIt.WHITE
        otherClass = ""
    else
        setNameColor = CanIMogIt.GRAY
        otherClass = CanIMogIt:GetSetClass(set) .. ": "
    end


    local secondLineText = ""
    if set.label and set.description then
        secondLineText = CanIMogIt.WHITE .. set.label .. ": " .. CanIMogIt.BLIZZARD_GREEN ..  set.description .. " "
    elseif set.label then
        secondLineText = CanIMogIt.WHITE .. set.label .. " "
    elseif set.description then
        secondLineText = CanIMogIt.BLIZZARD_GREEN .. set.description .. " "
    end
    -- TODO: replace CanIMogIt.WHITE with setNameColor, add otherClass
    -- e.g.: setNameColor .. otherClass .. set.name
    return CanIMogIt.WHITE .. set.name, secondLineText .. ratioText
end


function CanIMogIt:GetSetsText(itemLink)
    -- Gets the cached text regarding the sets info for the given item.
    local line1, line2;
    if CanIMogIt.cache:GetSetsInfoTextValue(itemLink) then
        line1, line2 = unpack(CanIMogIt.cache:GetSetsInfoTextValue(itemLink))
        return line1, line2
    end

    line1, line2 = CanIMogIt:CalculateSetsText(itemLink)

    CanIMogIt.cache:SetSetsInfoTextValue(itemLink, {line1, line2})

    return line1, line2
end

-- sort by the uiOrder and then the setID
function CanIMogIt.SortSets(t, a, b)
    if t[a].uiOrder == t[b].uiOrder then
        return t[a].setID < t[b].setID
    end
    return t[a].uiOrder < t[b].uiOrder
end


function CanIMogIt.GetVariantSets(setID)
    --[[
        Given a setID, return a table of all the variant sets for that set.
    ]]
    local variantSets = {C_TransmogSets.GetSetInfo(setID)}
    for i, variantSet in pairs(CIMI_GetVariantSets(setID)) do
        variantSets[#variantSets+1] = variantSet
    end
    return variantSets
end


function CanIMogIt.GetVariantSetsTexts(variantSets)
    --[[
        Given a table of variant sets, return a table of the texts to display
        for each variant set.
    ]]
    local variantSetsTexts = {}

    for i, variantSet in CanIMogIt.Utils.spairs(variantSets, CanIMogIt.SortSets) do
        local variantHave, variantTotal = CanIMogIt.GetRatio(variantSet.setID)
        local color = CanIMogIt.GetRatioTextColor(variantHave, variantTotal)
        variantSetsTexts[#variantSetsTexts+1] = color .. variantHave .. "/" .. variantTotal
    end

    return variantSetsTexts
end


function CanIMogIt:CalculateSetsVariantText(setID)
    --[[
        Given a setID, calculate the sum of all known sources for this set
        and it's variants.

        We are assuming that there are never more than 8 variants for a set.
        If there are, we'll have to modify this to add a third row I guess?
        Or maybe change it entirely. ¯\_(ツ)_/¯
    ]]

    local variantSets = CanIMogIt.GetVariantSets(setID)

    local variantsTexts = CanIMogIt.GetVariantSetsTexts(variantSets)

    -- If there are 4 or less variants, we want to display them all on top of each other:
    --[[
        1/8
        2/8
        3/8
        4/8
    ]]
    -- If there are 5 or more, we want to display them in a 2x2 grid, growing from the bottom:
    --[[
             1/8
             2/8
        5/8  3/8
        6/8  4/8
    ]]
    local variantsTextTotal = ""
    local numVariants = #variantsTexts
    local grid = {}

    for i = 1, numVariants do
        -- The row is 1 through 4, then 1 through 4 again.
        local row = i > 4 and i - 4 or i
        -- The column is 1 for <= 4, 2 for > 4.
        local col = i > 4 and 1 or 2
        grid[row] = grid[row] or {}
        grid[row][col] = variantsTexts[i]
    end

    -- For each variant greater than 4
    for i = 1, 4-(8-numVariants) do
        -- If there are fewer than 8 variants, cells in the left column move to the bottom.
        grid[i+(8-numVariants)][1] = grid[i][1]
        grid[i][1] = " "
    end

    -- Output the grid to a string.
    for i = 1, #grid do
        if grid[i][2] then
            variantsTextTotal = variantsTextTotal .. (grid[i][1] or "") .. "  " .. (grid[i][2] or "") .. " \n"
        else
            variantsTextTotal = variantsTextTotal .. (grid[i][1] or "") .. " \n"
        end
    end

    return string.gsub(variantsTextTotal, " \n$", " ")
end


function CanIMogIt:GetSetsVariantText(setID)
    -- Gets the cached text regarding the sets info for the given item.
    if not setID then return end
    local line1;
    if CanIMogIt.cache:GetSetsSumRatioTextValue(setID) then
        line1 = CanIMogIt.cache:GetSetsSumRatioTextValue(setID)
        return line1
    end

    line1 = CanIMogIt:CalculateSetsVariantText(setID)

    CanIMogIt.cache:SetSetsSumRatioTextValue(setID, line1)

    return line1
end


---------------------------
-- End of sets functions --
---------------------------


function CanIMogIt:ResetCache()
    -- Resets the cache, and calls things relying on the cache being reset.
    CanIMogIt.cache:Clear()
    CanIMogIt:SendMessage("ResetCache")
    -- Fake a BAG_UPDATE event to updating the icons. TODO: Replace this with message
    CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
end


function CanIMogIt:CalculateSourceLocationText(itemLink)
    --[[
        Calculates the sources for this item.
        This function is not cached, so avoid calling often!
        Use GetSourceLocationText whenever possible!
    ]]
    local output = ""

    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    if appearanceID == nil then return end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID, 1, transmogLocation)
    if sources then
        local totalSourceTypes = { 0, 0, 0, 0, 0, 0, 0 }
        local knownSourceTypes = { 0, 0, 0, 0, 0, 0, 0 }
        local totalUnknownType = 0
        local knownUnknownType = 0
        for _, source in pairs(sources) do
            if source.sourceType ~= 0 and source.sourceType ~= nil then
                totalSourceTypes[source.sourceType] = totalSourceTypes[source.sourceType] + 1
                if source.isCollected then
                    knownSourceTypes[source.sourceType] = knownSourceTypes[source.sourceType] + 1
                end
            elseif source.sourceType == 0 and source.isCollected then
                totalUnknownType = totalUnknownType + 1
                knownUnknownType = knownUnknownType + 1
            end
        end
        for sourceType, totalCount in ipairs(totalSourceTypes) do
            if (totalCount > 0) then
                local knownCount = knownSourceTypes[sourceType]
                local knownColor = CanIMogIt.RED_ORANGE
                if knownCount == totalCount then
                    knownColor = CanIMogIt.GRAY
                elseif knownCount > 0 then
                    knownColor = CanIMogIt.BLUE
                end
                output = string.format("%s"..knownColor.."%s ("..knownColor.."%i/%i"..knownColor..")"..CanIMogIt.WHITE..", ",
                    output, _G["TRANSMOG_SOURCE_"..sourceType], knownCount, totalCount)
            end
        end
        if totalUnknownType > 0 then
            output = string.format("%s"..CanIMogIt.GRAY.."Unobtainable ("..CanIMogIt.GRAY.."%i/%i"..CanIMogIt.GRAY..")"..CanIMogIt.WHITE..", ",
                output, knownUnknownType, totalUnknownType)
        end
        output = string.sub(output, 1, -3)
    end
    return output
end


function CanIMogIt:GetSourceLocationText(itemLink)
    -- Returns string of the all the types of sources which can provide an item with this appearance.

    cached_value = CanIMogIt.cache:GetItemSourcesValue(itemLink)
    if cached_value then
        return cached_value
    end

    local output = CanIMogIt:CalculateSourceLocationText(itemLink)

    CanIMogIt.cache:SetItemSourcesValue(itemLink, output)

    return output
end


function CanIMogIt:GetPlayerArmorTypeName()
    local playerArmorTypeID = classArmorTypeMap[select(2, UnitClass("player"))]
    return select(1, C_Item.GetItemSubClassInfo(4, playerArmorTypeID))
end


function CanIMogIt:GetItemID(itemLink)
    return tonumber(itemLink:match("item:(%d+)"))
end


function CanIMogIt:GetItemLinkFromSourceID(sourceID)
    return select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
end


function CanIMogIt:GetItemExpansion(itemID)
    return select(15, C_Item.GetItemInfo(itemID))
end


function CanIMogIt:GetItemClassName(itemLink)
    return select(2, C_Item.GetItemClassInfo(C_Item.GetItemInfoInstant(itemLink)))
end


function CanIMogIt:GetItemSubClassName(itemLink)
    return select(3, C_Item.GetItemInfoInstant(itemLink))
end


function CanIMogIt:GetItemSlotName(itemLink)
    return select(4, C_Item.GetItemInfoInstant(itemLink))
end


function CanIMogIt:IsItemBattlepet(itemLink)
    return string.match(itemLink, ".*(battlepet):.*") == "battlepet"
end


function CanIMogIt:IsItemKeystone(itemLink)
    return string.match(itemLink, ".*(keystone):.*") == "keystone"
end


function CanIMogIt:IsReadyForCalculations(itemLink)
    -- Returns true of the item's GetItemInfo is ready, or if it's a keystone,
    -- or if it's a battlepet.
    if C_Item.GetItemInfo(itemLink)
        or CanIMogIt:IsItemKeystone(itemLink)
        or CanIMogIt:IsItemBattlepet(itemLink) then
        return true
    end
    return false
end


function CanIMogIt:IsItemArmor(itemLink)
    local itemClass = CanIMogIt:GetItemClassName(itemLink)
    if itemClass == nil then return end
    return C_Item.GetItemClassInfo(4) == itemClass
end


function CanIMogIt:IsArmorSubClassID(subClassID, itemLink)
    local itemSubClass = CanIMogIt:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return select(1, C_Item.GetItemSubClassInfo(4, subClassID)) == itemSubClass
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


function CanIMogIt:IsAppearanceUsable(itemLink)
    if not itemLink then return end
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if not sourceID then return end
    local appearanceInfo = C_TransmogCollection.GetAppearanceInfoBySource(sourceID)
    if not appearanceInfo then return end
    return appearanceInfo.appearanceIsUsable
end


function CanIMogIt:IsValidAppearanceForCharacter(itemLink)
    -- Can the character transmog this appearance right now?
    if CanIMogIt:IsAppearanceUsable(itemLink) then
        return true
    else
        return false
    end
end


function CanIMogIt:IsItemSoulbound(itemLink, bag, slot, tooltipData)
    return CIMIScanTooltip:IsItemSoulbound(itemLink, bag, slot, tooltipData)
end


function CanIMogIt:IsItemWarbound(itemLink, bag, slot, tooltipData)
    return CIMIScanTooltip:IsItemWarbound(itemLink, bag, slot, tooltipData)
end


function CanIMogIt:GetItemClassRestrictions(itemLink)
    if not itemLink then return end
    return CIMIScanTooltip:GetClassesRequired(itemLink)
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
    return slotName ~= "" and slotName ~= NONEQUIP and slotName ~= BAG
end


local function RetailOldGetSourceID(itemLink)
    -- Some items don't have the C_TransmogCollection.GetItemInfo data,
    -- so use the old way to find the sourceID (using the DressUpModel).
    local itemID, _, _, slotName = C_Item.GetItemInfoInstant(itemLink)
    local slots = inventorySlotsMap[slotName]

    if slots == nil or slots == false or C_Item.IsDressableItemByID(itemID) == false then return end

    local cached_source = CanIMogIt.cache:GetDressUpModelSource(itemLink)
    if cached_source then
        return cached_source, "DressUpModel:GetItemTransmogInfo cache"
    end
    CanIMogIt.DressUpModel:SetUnit('player')
    CanIMogIt.DressUpModel:Undress()
    for i, slot in pairs(slots) do
        CanIMogIt.DressUpModel:TryOn(itemLink, slot)
        local transmogInfo = CanIMogIt.DressUpModel:GetItemTransmogInfo(slot)
        if transmogInfo and
            transmogInfo.appearanceID ~= nil and
            transmogInfo.appearanceID ~= 0 then
            -- Yes, that's right, we are setting `appearanceID` to the `sourceID`. Blizzard messed
            -- up the DressUpModel functions, so _they_ don't even know what they do anymore.
            -- The `appearanceID` field from `DressUpModel:GetItemTransmogInfo` is actually its
            -- source ID, not it's appearance ID.
            sourceID = transmogInfo.appearanceID
            if not CanIMogIt:IsSourceIDFromItemLink(sourceID, itemLink) then
                -- This likely means that the game hasn't finished loading things
                -- yet, so let's wait until we get good data before caching it.
                return
            end
            CanIMogIt.cache:SetDressUpModelSource(itemLink, sourceID)
            return sourceID, "DressUpModel:GetItemTransmogInfo"
        end
    end
end

local function ClassicOldGetSourceID(itemLink)
end

local OldGetSourceID = CanIMogIt.RetailWrapper(RetailOldGetSourceID, ClassicOldGetSourceID)

function CanIMogIt:GetSourceID(itemLink)
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemLink))
    if sourceID then
        return sourceID, "C_TransmogCollection.GetItemInfo"
    end

    return OldGetSourceID(itemLink)
end


function CanIMogIt:IsSourceIDFromItemLink(sourceID, itemLink)
    -- Returns whether the source ID given matches the itemLink.
    local sourceItemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
    if not sourceItemLink then return false end
    return CanIMogIt:DoItemIDsMatch(sourceItemLink, itemLink)
end


function CanIMogIt:DoItemIDsMatch(itemLinkA, itemLinkB)
    return CanIMogIt:GetItemID(itemLinkA) == CanIMogIt:GetItemID(itemLinkB)
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


function CanIMogIt:PlayerKnowsTransmog(itemLink)
    -- Internal logic for determining if the item is known or not.
    -- Does not use the CIMI database.
    if itemLink == nil then return end
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    if appearanceID == nil then return false end
    local sourceIDs = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
    if sourceIDs then
        for i, sourceID in pairs(sourceIDs) do
            local hasSource = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
            if hasSource then
                local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
                if CanIMogIt:IsArmorCosmetic(sourceItemLink) then
                    return true
                end
                if CanIMogIt:IsItemSubClassIdentical(itemLink, sourceItemLink) then
                    return true
                end
            end
        end
    end
    return false
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

    local hasTransmog;
    hasTransmog = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)

    return hasTransmog
end


function CanIMogIt:CharacterCanLearnTransmog(itemLink)
    -- Returns whether the player can learn the item or not.
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if sourceID == nil then return end
    if select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID)) then
        return true
    end
    return false
end


function CanIMogIt:GetReason(itemLink)
    local reason = CIMIScanTooltip:GetRedText(itemLink)
    if reason == "" then
        reason = CanIMogIt:GetItemSubClassName(itemLink)
    end
    return reason
end


function CanIMogIt:IsTransmogable(itemLink)
    -- Returns whether the item is transmoggable or not.

    local is_misc_subclass = CanIMogIt:IsArmorSubClassID(MISC, itemLink)
    if is_misc_subclass and miscArmorExceptions[CanIMogIt:GetItemSlotName(itemLink)] == nil then
        return false
    end

    local itemID, _, _, slotName = C_Item.GetItemInfoInstant(itemLink)

    if CanIMogIt:IsItemBattlepet(itemLink) or CanIMogIt:IsItemKeystone(itemLink) then
        -- Item is never transmoggable if it's a battlepet or keystone.
        -- We can't wear battlepets on our heads yet!
        return false
    end

    -- See if the game considers it transmoggable
    local transmoggable = select(3, C_Transmog.CanTransmogItem(itemID))
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


function CanIMogIt:PreLogicOptionsContinue(itemData)
    -- Apply the options. Returns false if it should stop the logic.
    local mountCheck = CanIMogItOptions["showMountItems"] and itemData.isItemMount
    local toyCheck = CanIMogItOptions["showToyItems"] and itemData.isItemToy
    local petCheck = CanIMogItOptions["showPetItems"] and itemData.isItemPet
    local ensembleCheck = CanIMogItOptions["showEnsembleItems"] and itemData.isItemEnsemble

    -- If showEquippableOnly is checked, only show equippable items.
    if CanIMogItOptions["showEquippableOnly"] and not itemData.isItemEquippable then
        -- Unless it's a mount, toy, pet, etc, and their respective option is enabled.
        if not (mountCheck or toyCheck or petCheck or ensembleCheck) then
            return false
        end
    end

    return true
end


function CanIMogIt:PostLogicOptionsText(text, unmodifiedText)
    -- Apply the options to the text. Returns the relevant text.

    if CanIMogItOptions["showUnknownOnly"] and not CanIMogIt:TextIsUnknown(unmodifiedText) then
        -- We don't want to show the tooltip if it's already known.
        return "", ""
    end

    if CanIMogItOptions["showTransmoggableOnly"]
            and (unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE
            or unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE_BOE
            or unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE_WARBOUND) then
        -- If we don't want to show the tooltip if it's not transmoggable
        return "", ""
    end

    if not CanIMogItOptions["showVerboseText"] then
        text = simpleTextMap[text] or text
    end

    return text, unmodifiedText
end


function CanIMogIt:GetAppearanceData(itemLink)
    -- Returns the appearance data for the item. Uses the cache if available.
    local appData

    appData = CanIMogIt.cache:GetAppearanceDataValue(itemLink)
    if appData then
        return appData
    end

    appData = CanIMogIt.AppearanceData.FromItemLink(itemLink)
    if appData == nil then return end

    CanIMogIt.cache:SetAppearanceDataValue(appData)
    return appData
end


function CanIMogIt:GetItemData(itemLink)
    -- Returns the item data for the item. Uses the cache if available.
    local itemData

    itemData = CanIMogIt.cache:GetItemDataValue(itemLink)
    if itemData then
        return itemData
    end

    itemData = CanIMogIt.ItemData.FromItemLink(itemLink)
    if itemData == nil then return end

    CanIMogIt.cache:SetItemDataValue(itemData)
    return itemData
end


function CanIMogIt:GetBindData(itemLink, bag, slot, tooltipData)
    -- Returns the bind data for the item. Uses the cache if available.
    local bindData

    bindData = CanIMogIt.cache:GetBindDataValue(itemLink, bag, slot)
    if bindData then
        return bindData
    end

    bindData = CanIMogIt.BindData:new(itemLink, bag, slot, tooltipData)
    if bindData == nil then return end

    CanIMogIt.cache:SetBindDataValue(bindData)
    return bindData
end


function CanIMogIt:CalculateKey(itemLink)
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if sourceID then
        return "source:" .. sourceID
    elseif itemID then
        return "item:" .. itemID
    else
        return "itemlink:" .. itemLink
    end
end


function CanIMogIt:CalculateTooltipText(itemLink, bag, slot, tooltipData)
    --[[
        Calculate the tooltip text.
        Use GetTooltipText whenever possible!
    ]]
    local exception_text = CanIMogIt:GetExceptionText(itemLink)
    if exception_text then
        return exception_text, exception_text
    end

    local text, unmodifiedText;

    local itemData = CanIMogIt:GetItemData(itemLink)
    if itemData == nil then return end
    local bindData = CanIMogIt:GetBindData(itemLink, bag, slot, tooltipData)
    if bindData == nil then return end

    if not CanIMogIt:PreLogicOptionsContinue(itemData) then
        return "", ""
    end

    -- Is the item transmogable?
    if itemData.type == CanIMogIt.ItemTypes.Transmogable then
        local appData = CanIMogIt:GetAppearanceData(itemLink)
        if appData == nil then return end
        text, unmodifiedText = appData:CalculateBindStateText(bindData)
    elseif itemData.type == CanIMogIt.ItemTypes.Mount then
        -- This item is a mount, so let's figure out if we know it!
        text, unmodifiedText = CanIMogIt:CalculateMountText(itemLink)
    elseif itemData.type == CanIMogIt.ItemTypes.Toy then
        -- This item is a toy, so let's figure out if we know it!
        text, unmodifiedText = CanIMogIt:CalculateToyText(itemLink)
    elseif itemData.type == CanIMogIt.ItemTypes.Pet then
        -- This item is a pet, so let's figure out if we know it!
        text, unmodifiedText = CanIMogIt:CalculatePetText(itemLink)
    elseif itemData.type == CanIMogIt.ItemTypes.Ensemble then
        -- This item is an ensemble, so let's figure out if we know it!
        text, unmodifiedText = CanIMogIt:CalculateEnsembleText(itemLink)
    else  -- itemData.type == CanIMogIt.ItemTypes.Other
        -- This item is never transmogable.
        if bindData.type == CanIMogIt.BindTypes.Warbound then
            -- Pink Circle-Slash
            text = CanIMogIt.NOT_TRANSMOGABLE_WARBOUND
            unmodifiedText = CanIMogIt.NOT_TRANSMOGABLE_WARBOUND
        elseif bindData.type == CanIMogIt.BindTypes.Soulbound then
            -- Gray Circle-Slash
            text = CanIMogIt.NOT_TRANSMOGABLE
            unmodifiedText = CanIMogIt.NOT_TRANSMOGABLE
        else
            -- Yellow Circle-Slash
            text = CanIMogIt.NOT_TRANSMOGABLE_BOE
            unmodifiedText = CanIMogIt.NOT_TRANSMOGABLE_BOE
        end
    end
    return text, unmodifiedText
end


local foundAnItemFromBags = false


function CanIMogIt:GetTooltipText(itemLink, bag, slot, tooltipData)
    --[[
        Gets the text to display on the tooltip from the itemLink.

        If bag and slot are given, this will use the itemLink from
        bag and slot instead.

        If tooltipData is given, it will be used to get TooltipScanner info,
        instead of calculating it.

        Returns two things:
            the text to display.
            the unmodifiedText that can be used for lookup values.
    ]]
    if bag and slot then
        itemLink = C_Container.GetContainerItemLink(bag, slot)
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
    if not CanIMogIt:IsReadyForCalculations(itemLink) then
        return
    end

    local text = ""
    local unmodifiedText = ""

    text, unmodifiedText = CanIMogIt:CalculateTooltipText(itemLink, bag, slot, tooltipData)

    text = CanIMogIt:PostLogicOptionsText(text, unmodifiedText)

    return text, unmodifiedText
end


function CanIMogIt:GetIconText(itemLink, bag, slot)
    --[[
        Gets the icon as text for this itemLink/bag+slot. Does not include the other text
        that is also caluculated.
    ]]
    local text, unmodifiedText = CanIMogIt:GetTooltipText(itemLink, bag, slot)
    local icon
    if text ~= "" and text ~= nil then
        icon = CanIMogIt.tooltipIcons[unmodifiedText]
    else
        icon = ""
    end
    return icon
end
