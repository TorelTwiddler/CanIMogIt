-- Constants for CanIMogIt

local L = CanIMogIt.L


--------------------------------------------
-- Tooltip icon, color and text constants --
--------------------------------------------

-- Icons
CanIMogIt.KNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN:0|t "
CanIMogIt.KNOWN_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_OVERLAY:0|t "
CanIMogIt.KNOWN_BUT_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle:0|t "
CanIMogIt.KNOWN_BUT_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle_OVERLAY:0|t "
CanIMogIt.UNKNOWABLE_SOULBOUND_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_SOULBOUND:0|t "
CanIMogIt.UNKNOWABLE_SOULBOUND_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_SOULBOUND_OVERLAY:0|t "
CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER:0|t "
CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER_OVERLAY:0|t "
CanIMogIt.UNKNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWN:0|t "
CanIMogIt.UNKNOWN_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWN_OVERLAY:0|t "
CanIMogIt.NOT_TRANSMOGABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE:0|t "
CanIMogIt.NOT_TRANSMOGABLE_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE_OVERLAY:0|t "
CanIMogIt.QUESTIONABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE:0|t "
CanIMogIt.QUESTIONABLE_ICON_OVERLAY = "|TInterface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE_OVERLAY:0|t "


-- Colorblind colors
CanIMogIt.BLUE =   "|cff15abff"
CanIMogIt.BLUE_GREEN = "|cff009e73"
CanIMogIt.PINK = "|cffcc79a7"
CanIMogIt.ORANGE = "|cffe69f00"
CanIMogIt.RED_ORANGE = "|cffff9333"
CanIMogIt.YELLOW = "|cfff0e442"
CanIMogIt.GRAY =   "|cff888888"


-- Text
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
    [CanIMogIt.KNOWN] = KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = KNOWN_BUT_ICON_OVERLAY,
    -- [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = QUESTIONABLE_ICON_OVERLAY,
    [CanIMogIt.UNKNOWABLE_SOULBOUND] = UNKNOWABLE_SOULBOUND_ICON_OVERLAY,
	[CanIMogIt.UNKNOWABLE_BY_CHARACTER] = UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    -- [CanIMogIt.CAN_BE_LEARNED_BY] = UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    [CanIMogIt.UNKNOWN] = UNKNOWN_ICON_OVERLAY,
	[CanIMogIt.NOT_TRANSMOGABLE] = NOT_TRANSMOGABLE_ICON_OVERLAY,
    -- [CanIMogIt.CANNOT_DETERMINE] = QUESTIONABLE_ICON_OVERLAY,
}