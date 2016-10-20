-- Constants for CanIMogIt

local L = CanIMogIt.L


--------------------------------------------
-- Database scan speed values             --
--------------------------------------------


-- Instant - Only the best of connections, or you WILL crash with Error #134
-- CanIMogIt.throttleTime = 0.25
-- CanIMogIt.bufferMax = 10000

-- Near Instant - May cause your game to crash with Error #134
-- CanIMogIt.throttleTime = 0.25
-- CanIMogIt.bufferMax = 200

-- Fast - Less likely to cause lag or crash
-- CanIMogIt.throttleTime = 0.1
-- CanIMogIt.bufferMax = 50

-- Medium - Most likely safe
CanIMogIt.throttleTime = 0.1
CanIMogIt.bufferMax = 25

-- Slow - Will take a long time, but be 100% safe. Use if you have a poor connection.
-- CanIMogIt.throttleTime = 0.5
-- CanIMogIt.bufferMax = 5


--------------------------------------------
-- Tooltip icon, color and text constants --
--------------------------------------------

-- Icons
CanIMogIt.KNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN:0|t "
CanIMogIt.KNOWN_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\KNOWN_OVERLAY"
CanIMogIt.KNOWN_BUT_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle:0|t "
CanIMogIt.KNOWN_BUT_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle_OVERLAY"
CanIMogIt.UNKNOWABLE_SOULBOUND_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_SOULBOUND:0|t "
CanIMogIt.UNKNOWABLE_SOULBOUND_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_SOULBOUND_OVERLAY"
CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER:0|t "
CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER_OVERLAY"
CanIMogIt.UNKNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWN:0|t "
CanIMogIt.UNKNOWN_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\UNKNOWN_OVERLAY"
CanIMogIt.NOT_TRANSMOGABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE:0|t "
CanIMogIt.NOT_TRANSMOGABLE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE_OVERLAY"
CanIMogIt.QUESTIONABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE:0|t "
CanIMogIt.QUESTIONABLE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE_OVERLAY"


-- Colorblind colors
CanIMogIt.BLUE =   "|cff15abff"
CanIMogIt.BLUE_GREEN = "|cff009e73"
CanIMogIt.PINK = "|cffcc79a7"
CanIMogIt.ORANGE = "|cffe69f00"
CanIMogIt.RED_ORANGE = "|cffff9333"
CanIMogIt.YELLOW = "|cfff0e442"
CanIMogIt.GRAY =   "|cff888888"


-- Tooltip Text
local KNOWN =                                       L["Learned."]
local KNOWN_FROM_ANOTHER_ITEM =                     L["Learned from another item."]
local KNOWN_BY_ANOTHER_CHARACTER =                  L["Learned for a different class."]
local KNOWN_BUT_TOO_LOW_LEVEL =                     L["Learned but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =   L["Learned from another item but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =       L["Learned for a different class and item."]
local UNKNOWABLE_SOULBOUND =                        L["Cannot learn: Soulbound"] .. " " -- subClass
local UNKNOWABLE_BY_CHARACTER =                     L["Cannot learn:"] .. " " -- subClass
local CAN_BE_LEARNED_BY =                           L["Can be learned by:"] -- list of classes
local UNKNOWN =                                     L["Not learned."]
local NOT_TRANSMOGABLE =                            L["Cannot be learned."]
local CANNOT_DETERMINE =                            L["Cannot determine status on other characters."]


-- Combine icons, color, and text into full tooltip
CanIMogIt.KNOWN =                                       CanIMogIt.KNOWN_ICON .. CanIMogIt.BLUE .. KNOWN
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM =                     CanIMogIt.KNOWN_BUT_ICON .. CanIMogIt.BLUE .. KNOWN_FROM_ANOTHER_ITEM
CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER =                  CanIMogIt.KNOWN_ICON .. CanIMogIt.BLUE .. KNOWN_BY_ANOTHER_CHARACTER
CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL =                     CanIMogIt.KNOWN_ICON .. CanIMogIt.BLUE .. KNOWN_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =   CanIMogIt.KNOWN_BUT_ICON .. CanIMogIt.BLUE .. KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =       CanIMogIt.KNOWN_BUT_ICON .. CanIMogIt.BLUE .. KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
-- CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =       CanIMogIt.QUESTIONABLE_ICON .. CanIMogIt.YELLOW .. CANNOT_DETERMINE
CanIMogIt.UNKNOWABLE_SOULBOUND =                        CanIMogIt.UNKNOWABLE_SOULBOUND_ICON .. CanIMogIt.BLUE_GREEN .. UNKNOWABLE_SOULBOUND
CanIMogIt.UNKNOWABLE_BY_CHARACTER =                     CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON .. CanIMogIt.YELLOW .. UNKNOWABLE_BY_CHARACTER
CanIMogIt.UNKNOWN =                                     CanIMogIt.UNKNOWN_ICON .. CanIMogIt.RED_ORANGE .. UNKNOWN
CanIMogIt.NOT_TRANSMOGABLE =                            CanIMogIt.NOT_TRANSMOGABLE_ICON .. CanIMogIt.GRAY .. NOT_TRANSMOGABLE


-- Used by leftTexts
CanIMogIt.tooltipTexts = {
    [KNOWN] = CanIMogIt.KNOWN,
    [KNOWN_FROM_ANOTHER_ITEM] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    [KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER,
    [KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL,
    [KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL,
    [KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER,
    [UNKNOWABLE_SOULBOUND] = CanIMogIt.UNKNOWABLE_SOULBOUND,
	[UNKNOWABLE_BY_CHARACTER] = CanIMogIt.UNKNOWABLE_BY_CHARACTER,
    [CAN_BE_LEARNED_BY] = CanIMogIt.CAN_BE_LEARNED_BY,
    [UNKNOWN] = CanIMogIt.UNKNOWN,
	[NOT_TRANSMOGABLE] = CanIMogIt.NOT_TRANSMOGABLE,
    [CANNOT_DETERMINE] = CanIMogIt.CANNOT_DETERMINE,
}


-- Used by itemOverlay
CanIMogIt.tooltipIcons = {
    [CanIMogIt.KNOWN] = CanIMogIt.KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = CanIMogIt.KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_BUT_ICON_OVERLAY,
    -- [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.QUESTIONABLE_ICON_OVERLAY,
    [CanIMogIt.UNKNOWABLE_SOULBOUND] = CanIMogIt.UNKNOWABLE_SOULBOUND_ICON_OVERLAY,
	[CanIMogIt.UNKNOWABLE_BY_CHARACTER] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    -- [CanIMogIt.CAN_BE_LEARNED_BY] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    [CanIMogIt.UNKNOWN] = CanIMogIt.UNKNOWN_ICON_OVERLAY,
	[CanIMogIt.NOT_TRANSMOGABLE] = CanIMogIt.NOT_TRANSMOGABLE_ICON_OVERLAY,
    -- [CanIMogIt.CANNOT_DETERMINE] = CanIMogIt.QUESTIONABLE_ICON_OVERLAY,
}


-- Other text

CanIMogIt.DATABASE_START_UPDATE_TEXT = L["Updating appearances database."]
CanIMogIt.DATABASE_DONE_UPDATE_TEXT = L["Items updated: "] -- followed by a number
