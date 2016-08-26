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
}


CanIMogIt.frame = CreateFrame("Frame", "CanIMogItOptionsFrame", UIParent);
CanIMogIt.frame.name = "Can I Mog It?";
InterfaceOptions_AddCategory(CanIMogIt.frame);


local EVENTS = {
    "ADDON_LOADED",
    "TRANSMOG_COLLECTION_UPDATED",
    -- "PLAYER_LOGIN",
    -- "GET_ITEM_INFO_RECEIVED",
    "AUCTION_HOUSE_SHOW",
    "GUILDBANKFRAME_OPENED",
    "VOID_STORAGE_OPEN",
}

for i, event in pairs(EVENTS) do
    CanIMogIt.frame:RegisterEvent(event);
end


CanIMogIt.frame:SetScript("OnEvent", function(self, event, ...)
    -- Add functions you want to catch events here
    self:AddonLoaded(event, ...)
    self:OnEncounterJournalLoaded(event, ...)
    self:TransmogCollectionUpdated(event, ...)
    -- self:OnAuctionHouseShow(event, ...)
    self:OnGuildBankOpened(event, ...)
    self:OnVoidStorageOpened(event, ...)
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

    -- position the checkboxes
    debug:SetPoint("TOPLEFT", 16, -16)
    showEquippableOnly:SetPoint("TOPLEFT", debug, "BOTTOMLEFT")
    showTransmoggableOnly:SetPoint("TOPLEFT", showEquippableOnly, "BOTTOMLEFT")
    showUnknownOnly:SetPoint("TOPLEFT", showTransmoggableOnly, "BOTTOMLEFT")
    showItemIconOverlay:SetPoint("TOPLEFT", showUnknownOnly, "BOTTOMLEFT")
    showVerboseText:SetPoint("TOPLEFT", showItemIconOverlay, "BOTTOMLEFT")
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

CanIMogIt:RegisterChatCommand("cimi", "OpenOptionsMenu")
CanIMogIt:RegisterChatCommand("canimogit", "OpenOptionsMenu")

function CanIMogIt:OpenOptionsMenu()
    -- Run it twice, because the first one only opens
    -- the main interface window.
    InterfaceOptionsFrame_OpenToCategory(CanIMogIt.frame)
    InterfaceOptionsFrame_OpenToCategory(CanIMogIt.frame)
end
