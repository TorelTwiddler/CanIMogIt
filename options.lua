-- Options for CanIMogIt
--
-- Thanks to Stanzilla and Semlar and their addon AdvancedInterfaceOptions, which I used as reference.

local _G = _G
local L = CanIMogIt.L

local CREATE_DATABASE_TEXT = L["Can I Mog It? Important Message: Please log into all of your characters to compile complete transmog appearance data."]

StaticPopupDialogs["CANIMOGIT_NEW_DATABASE"] = {
  text = CREATE_DATABASE_TEXT,
  button1 = "Okay, I'll go log onto all of my toons!",
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

CanIMogIt_OptionsVersion = "1.5"

CanIMogItOptions_Defaults = {
    ["options"] = {
        ["version"] = CanIMogIt_OptionsVersion,
        ["debug"] = false,
        ["showEquippableOnly"] = true,
        ["showTransmoggableOnly"] = true,
        ["showUnknownOnly"] = false,
        ["showItemIconOverlay"] = true,
        ["showVerboseText"] = false,
		["showKNOWN"] = true,
		["showKNOWN_FROM_ANOTHER_ITEM"] = true,
		["showKNOWN_BY_ANOTHER_CHARACTER"] = false,
		["showKNOWN_BUT_TOO_LOW_LEVEL"] = false,
		["showKNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL"] = false,
		["showKNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER"] = true,
		["showUNKNOWABLE_SOULBOUND"] = true,
		["showUNKNOWABLE_BY_CHARACTER"] = true,
		--["showCAN_BE_LEARNED_BY"] = true,
		["showUNKNOWN"] = true,
		["showNOT_TRANSMOGABLE"] = true,
		-- ["showCANNOT_DETERMINE"] = true,
    },
}


CanIMogItOptions_DisplayData = {
    ["debug"] = {
        ["displayName"] = L["Debug Tooltip"],
        ["description"] = L["Detailed information for debug purposes. Use this when sending bug reports."],
    },
    ["showEquippableOnly"] = {
        ["displayName"] = L["Equippable Items Only"],
        ["description"] = L["Only show on items that can be equipped."]
    },
    ["showTransmoggableOnly"] = {
        ["displayName"] = L["Transmoggable Items Only"],
        ["description"] = L["Only show on items that can be transmoggrified."]
    },
    ["showUnknownOnly"] = {
        ["displayName"] = L["Unknown Items Only"],
        ["description"] = L["Only show on items that you haven't learned."]
    },
    ["showItemIconOverlay"] = {
        ["displayName"] = L["Show Bag Icons"],
        ["description"] = L["Shows the icon directly on the item in your bag."]
    },
    ["showVerboseText"] = {
        ["displayName"] = L["Verbose Text"],
        ["description"] = L["Shows a more detailed text for some of the tooltips."]
    },
	["showKNOWN"] = {
        ["displayName"] = L[CanIMogIt.KNOWN],
        ["description"] = L["Displays when you have collected the appearance."]
    },
	["showKNOWN_FROM_ANOTHER_ITEM"] = {
        ["displayName"] = L[CanIMogIt.KNOWN_FROM_ANOTHER_ITEM],
        ["description"] = L["Displays when you have collected the appearance from a different item."]
    },
	["showKNOWN_BY_ANOTHER_CHARACTER"] = {
        ["displayName"] = L[CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER],
        ["description"] = L["Displays when you have collected the appearance, but cannot use the transmog on this character."]
    },
	["showKNOWN_BUT_TOO_LOW_LEVEL"] = {
        ["displayName"] = L[CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL],
        ["description"] = L["Displays when you have collected the appearance, but are too low level to use it for transmog."]
    },
	["showKNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL"] = {
        ["displayName"] = L[CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL],
        ["description"] = L["Displays when you have collected the appearance from a different item, and are too low level to use it for transmog."]
    },
	["showKNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER"] = {
        -- Displays CANNOT_DETERMINE text because of a Blizzard API issue: Ticket 1
        ["displayName"] = L[CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER],
        ["description"] = L["Displays when you have collected the appearance on your current character, but the item you are looking at cannot be collected because it is the wrong armor/weapon type for the character."]
    },
	["showUNKNOWABLE_SOULBOUND"] = {
        ["displayName"] = L[CanIMogIt.UNKNOWABLE_SOULBOUND .. BLIZZARD_RED .. "[Reason]"],
        ["description"] = L["Displays when an item is soulbound but the appearance cannot be collected on your current character."]
    },
	["showUNKNOWABLE_BY_CHARACTER"] = {
        ["displayName"] = L[CanIMogIt.UNKNOWABLE_BY_CHARACTER .. BLIZZARD_RED .. "[Reason]"],
        ["description"] = L["Displays when you cannot collect an appearance from an item on your current character."]
    },
	--["showCAN_BE_LEARNED_BY"] = {
        --["displayName"] = L[CanIMogIt.CAN_BE_LEARNED_BY],
        --["description"] = L["Displays when you have collected the appearance."]
    --},
	["showUNKNOWN"] = {
        ["displayName"] = L[CanIMogIt.UNKNOWN],
        ["description"] = L["Displays when you have not collected the appearance."]
    },
	["showNOT_TRANSMOGABLE"] = {
        ["displayName"] = L[CanIMogIt.NOT_TRANSMOGABLE],
        ["description"] = L["Displays when an item can never be learned for transmog."]
    },
	-- ["showCANNOT_DETERMINE"] = {
    --     ["displayName"] = L[CanIMogIt.CANNOT_DETERMINE],
    --     ["description"] = L["Displays when you have collected the appearance."]
    -- },
}


CanIMogIt.frame = CreateFrame("Frame", "CanIMogItOptionsFrame", UIParent);
CanIMogIt.frame.name = "Can I Mog It?";
InterfaceOptions_AddCategory(CanIMogIt.frame);


local EVENTS = {
    "ADDON_LOADED",
    "TRANSMOG_COLLECTION_UPDATED",
    -- "PLAYER_LOGIN",
    -- "GET_ITEM_INFO_RECEIVED",
}

for i, event in pairs(EVENTS) do
    CanIMogIt.frame:RegisterEvent(event);
end


CanIMogIt.frame:SetScript("OnEvent", function(self, event, ...)
    -- Add functions you want to catch events here
    self:AddonLoaded(event, ...)
    self:TransmogCollectionUpdated(event, ...)
    -- self:GetItemInfoReceived(event, ...)
end)


--[[
    Resets the cache every RESET_TIME seconds. This prevents invalid
    data from being stuck in the cache. It appears to not be a
    significant enough slowdown even with the bags open.
]]

local RESET_TIME = 5

local timer = 0
local function onUpdate(self, elapsed)
    timer = timer + elapsed
    -- Unregister if appearances are ready, or 30 seconds have passed.
    if timer >= RESET_TIME then
        CanIMogIt.cache = {}
        timer = 0
    end
end
CanIMogIt.frame:SetScript("OnUpdate", onUpdate)


function CanIMogIt.frame:AddonLoaded(event, addonName)
    if event == "ADDON_LOADED" and addonName == "CanIMogIt" then
        CanIMogIt.frame.Loaded()
    end
end


local function checkboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
    self:SetValue(checked)
    -- Reset the cache when an option changes.
    CanIMogIt.cache = {}
end


local function newCheckbox(parent, variableName)
    -- Creates a new checkbox in the parent frame for the given variable name
    local displayData = CanIMogItOptions_DisplayData[variableName]
    local checkbox = CreateFrame("CheckButton", "CanIMogItCheckbox" .. variableName, 
            parent, "InterfaceOptionsCheckButtonTemplate")

    -- checkbox.value = CanIMogItOptions[variableName]

    checkbox.GetValue = function (self)
        return CanIMogItOptions[variableName]
    end
    checkbox.SetValue = function (self, value) CanIMogItOptions[variableName] = value end

    checkbox:SetScript("OnClick", checkboxOnClick)
    checkbox:SetChecked(checkbox:GetValue())

    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(displayData["displayName"])

    checkbox.tooltipText = displayData["displayName"]
    checkbox.tooltipRequirement = displayData["description"]
    return checkbox
end


local function createOptionsMenu()
    -- define the checkboxes
    local debug = newCheckbox(CanIMogIt.frame, "debug")
    local showEquippableOnly = newCheckbox(CanIMogIt.frame, "showEquippableOnly")
    local showTransmoggableOnly = newCheckbox(CanIMogIt.frame, "showTransmoggableOnly")
    local showUnknownOnly = newCheckbox(CanIMogIt.frame, "showUnknownOnly")
    local showItemIconOverlay = newCheckbox(CanIMogIt.frame, "showItemIconOverlay")
    local showVerboseText = newCheckbox(CanIMogIt.frame, "showVerboseText")
	-- Tooltip texts
	local showKNOWN = newCheckbox(CanIMogIt.frame, "showKNOWN")
	local showKNOWN_FROM_ANOTHER_ITEM = newCheckbox(CanIMogIt.frame, "showKNOWN_FROM_ANOTHER_ITEM")
	local showKNOWN_BY_ANOTHER_CHARACTER = newCheckbox(CanIMogIt.frame, "showKNOWN_BY_ANOTHER_CHARACTER")
	local showKNOWN_BUT_TOO_LOW_LEVEL = newCheckbox(CanIMogIt.frame, "showKNOWN_BUT_TOO_LOW_LEVEL")
	local showKNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL = newCheckbox(CanIMogIt.frame, "showKNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL")
	local showKNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER = newCheckbox(CanIMogIt.frame, "showKNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER")
	local showUNKNOWABLE_SOULBOUND = newCheckbox(CanIMogIt.frame, "showUNKNOWABLE_SOULBOUND")
	local showUNKNOWABLE_BY_CHARACTER = newCheckbox(CanIMogIt.frame, "showUNKNOWABLE_BY_CHARACTER")
	--local showCAN_BE_LEARNED_BY = newCheckbox(CanIMogIt.frame, "showCAN_BE_LEARNED_BY")
	local showUNKNOWN = newCheckbox(CanIMogIt.frame, "showUNKNOWN")
	local showNOT_TRANSMOGABLE = newCheckbox(CanIMogIt.frame, "showNOT_TRANSMOGABLE")
	-- local showCANNOT_DETERMINE = newCheckbox(CanIMogIt.frame, "showCANNOT_DETERMINE")

    -- position the checkboxes
    debug:SetPoint("TOPLEFT", 16, -16)
    showEquippableOnly:SetPoint("TOPLEFT", debug, "BOTTOMLEFT")
    showTransmoggableOnly:SetPoint("TOPLEFT", showEquippableOnly, "BOTTOMLEFT")
    showUnknownOnly:SetPoint("TOPLEFT", showTransmoggableOnly, "BOTTOMLEFT")
    showItemIconOverlay:SetPoint("TOPLEFT", showUnknownOnly, "BOTTOMLEFT")
    showVerboseText:SetPoint("TOPLEFT", showItemIconOverlay, "BOTTOMLEFT")
	-- Tooltip texts
	showKNOWN:SetPoint("TOPLEFT", showVerboseText, "BOTTOMLEFT")
	showKNOWN_FROM_ANOTHER_ITEM:SetPoint("TOPLEFT", showKNOWN, "BOTTOMLEFT")
	showKNOWN_BY_ANOTHER_CHARACTER:SetPoint("TOPLEFT", showKNOWN_FROM_ANOTHER_ITEM, "BOTTOMLEFT")
	showKNOWN_BUT_TOO_LOW_LEVEL:SetPoint("TOPLEFT", showKNOWN_BY_ANOTHER_CHARACTER, "BOTTOMLEFT")
	showKNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL:SetPoint("TOPLEFT", showKNOWN_BUT_TOO_LOW_LEVEL, "BOTTOMLEFT")
	showKNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER:SetPoint("TOPLEFT", showKNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL, "BOTTOMLEFT")
	showUNKNOWABLE_SOULBOUND:SetPoint("TOPLEFT", showKNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER, "BOTTOMLEFT")
	showUNKNOWABLE_BY_CHARACTER:SetPoint("TOPLEFT", showUNKNOWABLE_SOULBOUND, "BOTTOMLEFT")
	--showCAN_BE_LEARNED_BY:SetPoint("TOPLEFT", showUNKNOWABLE_BY_CHARACTER, "BOTTOMLEFT")
	showUNKNOWN:SetPoint("TOPLEFT", showUNKNOWABLE_BY_CHARACTER, "BOTTOMLEFT")
	showNOT_TRANSMOGABLE:SetPoint("TOPLEFT", showUNKNOWN, "BOTTOMLEFT")
	-- showCANNOT_DETERMINE:SetPoint("TOPLEFT", showNOT_TRANSMOGABLE, "BOTTOMLEFT")
end


function CanIMogIt.frame.Loaded()
    -- Set the Options from defaults.
    if (not CanIMogItOptions) then
        CanIMogItOptions = CanIMogItOptions_Defaults.options
        print(L["CanIMogItOptions not found, loading defaults!"])
    end
    -- if (not CanIMogItDatabase) then
    --     CanIMogItDatabase = {}
    --     StaticPopup_Show("CANIMOGIT_NEW_DATABASE")
    -- end
    CanIMogItDatabase = nil
    -- Set missing options from the defaults if the version is out of date.
    if (CanIMogItOptions["version"] < CanIMogIt_OptionsVersion) then
        CanIMogItOptions_temp = CanIMogItOptions_Defaults.options;
        for k,v in pairs(CanIMogItOptions) do
            if (CanIMogItOptions_Defaults.options[k]) then
                CanIMogItOptions_temp[k] = v;
            end
        end
        CanIMogItOptions_temp["version"] = CanIMogIt_OptionsVersion;
        CanIMogItOptions = CanIMogItOptions_temp;
    end
    createOptionsMenu()
end
