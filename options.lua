-- Options for CanIMogIt
--
-- Thanks to Stanzilla and Semlar and their addon AdvancedInterfaceOptions, which I used as reference.

local _G = _G
local L = CanIMogIt.L

local CREATE_DATABASE_TEXT = L["Can I Mog It? Important Message: Please log into all of your characters to compile complete transmog appearance data."]

StaticPopupDialogs["CANIMOGIT_NEW_DATABASE"] = {
    text = CREATE_DATABASE_TEXT,
    button1 = L["Okay, I'll go log onto all of my toons!"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


local DATABASE_MIGRATION = "Can I Mog It?" .. "\n\n" .. L["We need to update our database. This may freeze the game for a few seconds."]


function CanIMogIt.CreateMigrationPopup(dialogName, onAcceptFunc)
    StaticPopupDialogs[dialogName] = {
        text = DATABASE_MIGRATION,
        button1 = L["Okay"],
        button2 = L["Ask me later"],
        OnAccept = onAcceptFunc,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }
    StaticPopup_Show(dialogName)
end


-- OptionsVersion: Keep this as an integer, so comparison is easy.
CanIMogIt_OptionsVersion = "25"


CanIMogItOptions_Defaults = {
    ["options"] = {
        ["version"] = CanIMogIt_OptionsVersion,
        ["debug"] = false,
        ["databaseDebug"] = false,
        ["showEquippableOnly"] = true,
        ["showTransmoggableOnly"] = true,
        ["showUnknownOnly"] = false,
        ["showSetInfo"] = true,
        ["showItemIconOverlay"] = true,
        ["showVerboseText"] = false,
        ["showSourceLocationTooltip"] = false,
        ["printDatabaseScan"] = true,
        ["iconLocation"] = "TOPRIGHT",
        ["showToyItems"] = true,
        ["showPetItems"] = true,
        ["showMountItems"] = true,
        ["showCatalizableItems"] = true,
        ["showEnsembleItems"] = true,
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
    ["showSetInfo"] = {
        ["displayName"] = L["Show Transmog Set Info"],
        ["description"] = L["Show information on the tooltip about transmog sets."] .. "\n\n" .. L["Also shows a summary in the Appearance Sets UI of how many pieces of a transmog set you have collected."]
    },
    ["showItemIconOverlay"] = {
        ["displayName"] = L["Show Bag Icons"],
        ["description"] = L["Shows the icon directly on the item in your bag."]
    },
    ["showVerboseText"] = {
        ["displayName"] = L["Verbose Text"],
        ["description"] = L["Shows a more detailed text for some of the tooltips."]
    },
    ["showSourceLocationTooltip"] = {
        ["displayName"] = L["Show Source Location Tooltip"],
        ["description"] = L["Shows a tooltip with the source locations of an appearance (ie. Quest, Vendor, World Drop). This only works on items your current class can learn."] .. "\n\n" .. L["Please note that this may not always be correct as Blizzard's information is incomplete."]
    },
    ["printDatabaseScan"] = {
        ["displayName"] = L["Database Scanning chat messages"],
        ["description"] = L["Shows chat messages on login about the database scan."]
    },
    ["iconLocation"] = {
        ["displayName"] = L["Location: "],
        ["description"] = L["Move the icon to a different location on all frames."]
    },
    ["showToyItems"] = {
        ["displayName"] = L["Show Toy Items"],
        ["description"] = L["Show tooltips and overlays on toys (otherwise, shows as not transmoggable)."]
    },
    ["showPetItems"] = {
        ["displayName"] = L["Show Pet Items"],
        ["description"] = L["Show tooltips and overlays on pets (otherwise, shows as not transmoggable)."]
    },
    ["showMountItems"] = {
        ["displayName"] = L["Show Mount Items"],
        ["description"] = L["Show tooltips and overlays on mounts (otherwise, shows as not transmoggable)."]
    },
    ["showCatalizableItems"] = {
        ["displayName"] = L["Show Catalizable Items"],
        ["description"] = L["Show extra tooltip for items that can be catalyzed."]
    },
    ["showEnsembleItems"] = {
        ["displayName"] = L["Show Ensemble Items"],
        ["description"] = L["Show tooltips and overlays on Ensemble Items (otherwise, shows as not transmoggable)."]
    },
}


CanIMogIt.frame = CreateFrame("Frame", "CanIMogItOptionsFrame", InterfaceOptionsFramePanelContainer);
CanIMogIt.frame.name = "Can I Mog It?";
local category = Settings.RegisterCanvasLayoutCategory(CanIMogIt.frame, CanIMogIt.frame.name)
CanIMogIt.settingsCategory = category
Settings.RegisterAddOnCategory(category)


local EVENTS = {
    "ADDON_LOADED",
    "TRANSMOG_COLLECTION_UPDATED",
    "PLAYER_LOGIN",
    "GET_ITEM_INFO_RECEIVED",
    "BLACK_MARKET_OPEN",
    "BLACK_MARKET_ITEM_UPDATE",
    "BLACK_MARKET_CLOSE",
    "CHAT_MSG_LOOT",
    "UNIT_INVENTORY_CHANGED",
    "PLAYER_SPECIALIZATION_CHANGED",
    "BAG_UPDATE",
    "BAG_CONTAINER_UPDATE",
    "BAG_NEW_ITEMS_UPDATED",
    "QUEST_ACCEPTED",
    "BAG_SLOT_FLAGS_UPDATED",
    "BANK_BAG_SLOT_FLAGS_UPDATED",
    "PLAYERBANKSLOTS_CHANGED",
    "BANKFRAME_OPENED",
    "START_LOOT_ROLL",
    "MERCHANT_SHOW",
    "VOID_STORAGE_CONTENTS_UPDATE",
    "GUILDBANKBAGSLOTS_CHANGED",
    "TRANSMOG_COLLECTION_SOURCE_ADDED",
    "TRANSMOG_COLLECTION_SOURCE_REMOVED",
    "TRANSMOG_SEARCH_UPDATED",
    "LOADING_SCREEN_ENABLED",
    "LOADING_SCREEN_DISABLED",
    "TRADE_SKILL_SHOW",
    "NEW_TOY_ADDED",
    "NEW_MOUNT_ADDED",
    "ITEM_LOCK_CHANGED",
    "LOADING_SCREEN_ENABLED",
    "LOADING_SCREEN_DISABLED",
}

if CanIMogIt.isRetail then
    table.insert(EVENTS, "AUCTION_HOUSE_SHOW")
    table.insert(EVENTS, "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
    table.insert(EVENTS, "AUCTION_HOUSE_NEW_RESULTS_RECEIVED")
    table.insert(EVENTS, "PLAYERREAGENTBANKSLOTS_CHANGED")
    table.insert(EVENTS, "PET_JOURNAL_LIST_UPDATE")
end


for i, event in pairs(EVENTS) do
    CanIMogIt.frame:RegisterEvent(event);
end

CanIMogIt.Events = {}
CanIMogIt.EventsList = EVENTS

for i, event in pairs(EVENTS) do
    CanIMogIt.Events[event] = true
end


-- Skip the itemOverlayEvents function until the loading screen is disabled.
local ifNotBusyLimit = .008
-- a list of functions to run if we are not busy.
local ifNotBusyEvents = {}

local loadingScreenEnabled = true
-- These events should be run during the loading screen, if it's enabled.
local loadingScreenEvents = {
    ["PLAYER_LOGIN"] = true,
    ["ADDON_LOADED"] = true,
}


local function RunIfNotBusy(func, ...)
    -- Sets the function to run the next time we aren't busy.
    local args = {...}
    -- only add it to the dict if it's not already in the there.
    table.insert(ifNotBusyEvents, {func, args})
end


local function RunIfNotBusyEvents()
    if #ifNotBusyEvents == 0 or loadingScreenEnabled then
        return
    end
    local startTime = GetTimePreciseSec()
    while #ifNotBusyEvents > 0 do
        local currentTime = GetTimePreciseSec()
        if currentTime - startTime > ifNotBusyLimit then
            break
        end
        local eventData = ifNotBusyEvents[1]
        table.remove(ifNotBusyEvents, 1)
        local func, args = eventData[1], eventData[2]
        func(unpack(args))
    end
end


CanIMogIt.frame:SetScript("OnUpdate", RunIfNotBusyEvents)


CanIMogIt.frame.eventFunctions = {}


-- a dictionary of event names to a list of functions to run.
-- {event, {func}}
CanIMogIt.frame.smartEventFunctions = {}


function CanIMogIt.frame:AddSmartEvent(func, events)
    -- Smart events only run if there is enough time in the frame, otherwise,
    -- it pushes it off to the next frame to run.
    for i, event in ipairs(events) do
        if not CanIMogIt.frame.smartEventFunctions[event] then
            CanIMogIt.frame.smartEventFunctions[event] = {}
        end
        table.insert(CanIMogIt.frame.smartEventFunctions[event], func)
    end
end


local function RunSmartEvent(event, ...)
    -- Run the overlay events if we are not busy.
    for i, func in ipairs(CanIMogIt.frame.smartEventFunctions[event]) do
        RunIfNotBusy(func, event, ...)
    end
end


local function SmartEventHook(self, event, ...)
    if event == "LOADING_SCREEN_ENABLED" then
        loadingScreenEnabled = true
    elseif event == "LOADING_SCREEN_DISABLED" then
        loadingScreenEnabled = false
    end

    -- If the event is a loading screen event, run it and return.
    if loadingScreenEvents[event] then
        RunSmartEvent(event, ...)
        return
    end

    if loadingScreenEnabled then
        return
    end

    -- Smart events
    if CanIMogIt.frame.smartEventFunctions[event] then
        RunSmartEvent(event, ...)
    end
end
CanIMogIt.frame:HookScript("OnEvent", SmartEventHook)


function CanIMogIt.frame.AddonLoaded(event, addonName)
    if event == "ADDON_LOADED" and addonName == "CanIMogIt" then
        CanIMogIt.frame.Loaded()
    end
end
CanIMogIt.frame:AddSmartEvent(CanIMogIt.frame.AddonLoaded, {"ADDON_LOADED"})


local transmogEvents = {
    ["TRANSMOG_COLLECTION_SOURCE_ADDED"] = true,
    ["TRANSMOG_COLLECTION_SOURCE_REMOVED"] = true,
    ["TRANSMOG_COLLECTION_UPDATED"] = true,
}

local function TransmogCollectionUpdated(event, ...)
    if transmogEvents[event] then
        CanIMogIt:ResetCache()
    end
end

CanIMogIt.frame:AddSmartEvent(TransmogCollectionUpdated, {"TRANSMOG_COLLECTION_SOURCE_ADDED", "TRANSMOG_COLLECTION_SOURCE_REMOVED", "TRANSMOG_COLLECTION_UPDATED"})


local changesSavedStack = {}


local function changesSavedText()
    local frame = CreateFrame("Frame", "CanIMogIt_ChangesSaved", CanIMogIt.frame)
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetJustifyH("RIGHT")
    text:SetText(CanIMogIt.YELLOW .. L["Changes saved!"])

    text:SetAllPoints()

    frame:SetPoint("BOTTOMRIGHT", -20, 10)
    frame:SetSize(200, 20)
    frame:SetShown(false)
    CanIMogIt.frame.changesSavedText = frame
end


local function hideChangesSaved()
    table.remove(changesSavedStack, #changesSavedStack)
    if #changesSavedStack == 0 then
        CanIMogIt.frame.changesSavedText:SetShown(false)
    end
end


local function showChangesSaved()
    CanIMogIt.frame.changesSavedText:SetShown(true)
    table.insert(changesSavedStack, #changesSavedStack + 1)
    C_Timer.After(5, function () hideChangesSaved() end)
end


local function checkboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    showChangesSaved()
    -- Reset the cache when an option changes.
    CanIMogIt:ResetCache()

    CanIMogIt:SendMessage("OptionUpdate")
end


local function debugCheckboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    showChangesSaved()
    CanIMogIt:SendMessage("OptionUpdate")
end


local function newCheckbox(parent, variableName, onClickFunction)
    -- Creates a new checkbox in the parent frame for the given variable name
    onClickFunction = onClickFunction or checkboxOnClick
    local displayData = CanIMogItOptions_DisplayData[variableName]
    local checkbox = CreateFrame("CheckButton", "CanIMogItCheckbox" .. variableName,
            parent, "InterfaceOptionsCheckButtonTemplate")

    -- checkbox.value = CanIMogItOptions[variableName]

    checkbox.GetValue = function (self)
        return CanIMogItOptions[variableName]
    end
    checkbox.SetValue = function (self, value) CanIMogItOptions[variableName] = value end

    checkbox:SetScript("OnClick", onClickFunction)
    checkbox:SetChecked(checkbox:GetValue())

    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(displayData["displayName"])

    checkbox.tooltipText = displayData["displayName"]
    checkbox.tooltipRequirement = displayData["description"]
    return checkbox
end


local function newRadioGrid(parent, variableName)
    local displayData = CanIMogItOptions_DisplayData[variableName]
    local frameName = "CanIMogItCheckGridFrame" .. variableName
    local frame = CreateFrame("Frame", frameName, parent)

    frame.texture = CreateFrame("Frame", frameName .. "_Texture", frame)
    frame.texture:SetSize(58, 58)
    local texture = frame.texture:CreateTexture("CIMITextureFrame", "BACKGROUND")
    texture:SetTexture("Interface/ICONS/INV_Sword_1H_AllianceToy_A_01.blp")
    texture:SetAllPoints()
    texture:SetVertexColor(0.5, 0.5, 0.5)

    local reloadButton = CreateFrame("Button", frameName .. "_ReloadButton",
            frame, "UIPanelButtonTemplate")
    reloadButton:SetText(L["Reload to apply"])
    reloadButton:SetSize(120, 25)
    reloadButton:SetEnabled(false)
    reloadButton:SetScript("OnClick", function () ReloadUI() end)

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    title:SetText(L["Icon Location"])

    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text:SetText(L["Does not affect Quests or Adventure Journal."])

    local text2 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text2:SetText(L["Default"] .. ": " .. L["Top Right"])

    local radioTopLeft = CreateFrame("CheckButton", frameName .. "_TopLeft",
            frame, "UIRadioButtonTemplate")
    local radioTop = CreateFrame("CheckButton", frameName .. "_Top",
            frame, "UIRadioButtonTemplate")
    local radioTopRight = CreateFrame("CheckButton", frameName .. "_TopRight",
            frame, "UIRadioButtonTemplate")
    local radioLeft = CreateFrame("CheckButton", frameName .. "_Left",
            frame, "UIRadioButtonTemplate")
    local radioCenter = CreateFrame("CheckButton", frameName .. "_Center",
            frame, "UIRadioButtonTemplate")
    local radioRight = CreateFrame("CheckButton", frameName .. "_Right",
            frame, "UIRadioButtonTemplate")
    local radioBottomLeft = CreateFrame("CheckButton", frameName .. "_BottomLeft",
            frame, "UIRadioButtonTemplate")
    local radioBottom = CreateFrame("CheckButton", frameName .. "_Bottom",
            frame, "UIRadioButtonTemplate")
    local radioBottomRight = CreateFrame("CheckButton", frameName .. "_BottomRight",
            frame, "UIRadioButtonTemplate")

    radioTopLeft:SetChecked(CanIMogItOptions[variableName] == "TOPLEFT")
    radioTop:SetChecked(CanIMogItOptions[variableName] == "TOP")
    radioTopRight:SetChecked(CanIMogItOptions[variableName] == "TOPRIGHT")
    radioLeft:SetChecked(CanIMogItOptions[variableName] == "LEFT")
    radioCenter:SetChecked(CanIMogItOptions[variableName] == "CENTER")
    radioRight:SetChecked(CanIMogItOptions[variableName] == "RIGHT")
    radioBottomLeft:SetChecked(CanIMogItOptions[variableName] == "BOTTOMLEFT")
    radioBottom:SetChecked(CanIMogItOptions[variableName] == "BOTTOM")
    radioBottomRight:SetChecked(CanIMogItOptions[variableName] == "BOTTOMRIGHT")

    local allRadios = {
        radioTopLeft,
        radioTop,
        radioTopRight,
        radioLeft,
        radioCenter,
        radioRight,
        radioBottomLeft,
        radioBottom,
        radioBottomRight
    }

    local function createOnRadioClicked (location)
        local function onRadioClicked (self, a, b, c)
            local checked = self:GetChecked()
            PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            CanIMogItOptions[variableName] = location

            local anyChecked = false
            for _, radio in ipairs(allRadios) do
                if radio ~= self then
                    anyChecked = radio:GetChecked() or anyChecked
                    radio:SetChecked(false)
                end
            end
            if not anyChecked then
                self:SetChecked(true)
            end
            reloadButton:SetEnabled(true)
            showChangesSaved()
        end
        return onRadioClicked
    end

    radioTopLeft:SetScript("OnClick", createOnRadioClicked("TOPLEFT"))
    radioTop:SetScript("OnClick", createOnRadioClicked("TOP"))
    radioTopRight:SetScript("OnClick", createOnRadioClicked("TOPRIGHT"))
    radioLeft:SetScript("OnClick", createOnRadioClicked("LEFT"))
    radioCenter:SetScript("OnClick", createOnRadioClicked("CENTER"))
    radioRight:SetScript("OnClick", createOnRadioClicked("RIGHT"))
    radioBottomLeft:SetScript("OnClick", createOnRadioClicked("BOTTOMLEFT"))
    radioBottom:SetScript("OnClick", createOnRadioClicked("BOTTOM"))
    radioBottomRight:SetScript("OnClick", createOnRadioClicked("BOTTOMRIGHT"))

    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -5)

    radioTopLeft:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    radioTop:SetPoint("TOPLEFT", radioTopLeft, "TOPRIGHT", 5, 0)
    radioTopRight:SetPoint("TOPLEFT", radioTop, "TOPRIGHT", 5, 0)
    radioLeft:SetPoint("TOPLEFT", radioTopLeft, "BOTTOMLEFT", 0, -5)
    radioCenter:SetPoint("TOPLEFT", radioLeft, "TOPRIGHT", 5, 0)
    radioRight:SetPoint("TOPLEFT", radioCenter, "TOPRIGHT", 5, 0)
    radioBottomLeft:SetPoint("TOPLEFT", radioLeft, "BOTTOMLEFT", 0, -5)
    radioBottom:SetPoint("TOPLEFT", radioBottomLeft, "TOPRIGHT", 5, 0)
    radioBottomRight:SetPoint("TOPLEFT", radioBottom, "TOPRIGHT", 5, 0)

    text:SetPoint("TOPLEFT", radioTopRight, "TOPRIGHT", 14, -3)
    text2:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -3)

    reloadButton:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 4, -8)

    frame.texture:SetPoint("TOPLEFT", radioTopLeft, "TOPLEFT")

    frame:SetSize(600, 80)

    -- Use this to show the bottom of the frame.
    -- local sample = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    -- sample:SetText("example.")
    -- sample:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")

    return frame
end


local function createOptionsMenu()
    -- define the checkboxes
    CanIMogIt.frame.debug =  newCheckbox(CanIMogIt.frame, "debug", debugCheckboxOnClick)
    CanIMogIt.frame.showEquippableOnly = newCheckbox(CanIMogIt.frame, "showEquippableOnly")
    CanIMogIt.frame.showTransmoggableOnly = newCheckbox(CanIMogIt.frame, "showTransmoggableOnly")
    CanIMogIt.frame.showUnknownOnly = newCheckbox(CanIMogIt.frame, "showUnknownOnly")
    CanIMogIt.frame.showSetInfo = newCheckbox(CanIMogIt.frame, "showSetInfo")
    CanIMogIt.frame.showItemIconOverlay = newCheckbox(CanIMogIt.frame, "showItemIconOverlay")
    CanIMogIt.frame.showVerboseText = newCheckbox(CanIMogIt.frame, "showVerboseText")
    CanIMogIt.frame.showSourceLocationTooltip = newCheckbox(CanIMogIt.frame, "showSourceLocationTooltip")
    CanIMogIt.frame.printDatabaseScan = newCheckbox(CanIMogIt.frame, "printDatabaseScan")
    CanIMogIt.frame.iconLocation = newRadioGrid(CanIMogIt.frame, "iconLocation")
    CanIMogIt.frame.showToyItems = newCheckbox(CanIMogIt.frame, "showToyItems")
    CanIMogIt.frame.showPetItems = newCheckbox(CanIMogIt.frame, "showPetItems")
    CanIMogIt.frame.showMountItems = newCheckbox(CanIMogIt.frame, "showMountItems")
    CanIMogIt.frame.showCatalizableItems = newCheckbox(CanIMogIt.frame, "showCatalizableItems")
    CanIMogIt.frame.showEnsembleItems = newCheckbox(CanIMogIt.frame, "showEnsembleItems")

    -- position the checkboxes
    CanIMogIt.frame.debug:SetPoint("TOPLEFT", 16, -16)
    CanIMogIt.frame.showEquippableOnly:SetPoint("TOPLEFT", CanIMogIt.frame.debug, "BOTTOMLEFT")
    CanIMogIt.frame.showTransmoggableOnly:SetPoint("TOPLEFT", CanIMogIt.frame.showEquippableOnly, "BOTTOMLEFT")
    CanIMogIt.frame.showUnknownOnly:SetPoint("TOPLEFT", CanIMogIt.frame.showTransmoggableOnly, "BOTTOMLEFT")
    CanIMogIt.frame.showSetInfo:SetPoint("TOPLEFT", CanIMogIt.frame.showUnknownOnly, "BOTTOMLEFT")
    CanIMogIt.frame.showItemIconOverlay:SetPoint("TOPLEFT", CanIMogIt.frame.showSetInfo, "BOTTOMLEFT")
    CanIMogIt.frame.showVerboseText:SetPoint("TOPLEFT", CanIMogIt.frame.showItemIconOverlay, "BOTTOMLEFT")
    CanIMogIt.frame.showSourceLocationTooltip:SetPoint("TOPLEFT", CanIMogIt.frame.showVerboseText, "BOTTOMLEFT")
    CanIMogIt.frame.printDatabaseScan:SetPoint("TOPLEFT", CanIMogIt.frame.showSourceLocationTooltip, "BOTTOMLEFT")
    CanIMogIt.frame.iconLocation:SetPoint("TOPLEFT", CanIMogIt.frame.printDatabaseScan, "BOTTOMLEFT")
    CanIMogIt.frame.showToyItems:SetPoint("TOPLEFT", CanIMogIt.frame.iconLocation, "BOTTOMLEFT")
    CanIMogIt.frame.showPetItems:SetPoint("TOPLEFT", CanIMogIt.frame.showToyItems, "BOTTOMLEFT")
    CanIMogIt.frame.showMountItems:SetPoint("TOPLEFT", CanIMogIt.frame.showPetItems, "BOTTOMLEFT")
    CanIMogIt.frame.showCatalizableItems:SetPoint("TOPLEFT", CanIMogIt.frame.showMountItems, "BOTTOMLEFT")
    CanIMogIt.frame.showEnsembleItems:SetPoint("TOPLEFT", CanIMogIt.frame.showCatalizableItems, "BOTTOMLEFT")

    changesSavedText()
end


function CanIMogIt.frame.Loaded()
    -- Set the Options from defaults.
    if (not CanIMogItOptions) then
        CanIMogItOptions = CanIMogItOptions_Defaults.options
        print(L["CanIMogItOptions not found, loading defaults!"])
    end
    -- Set missing options from the defaults if the version is out of date.
    if (CanIMogItOptions["version"] < CanIMogIt_OptionsVersion) then
        local CanIMogItOptions_temp = CanIMogItOptions_Defaults.options;
        for k,v in pairs(CanIMogItOptions) do
            if (CanIMogItOptions_Defaults.options[k]) then
                CanIMogItOptions_temp[k] = v;
            end
        end
        CanIMogItOptions_temp["version"] = CanIMogIt_OptionsVersion;
        CanIMogItOptions = CanIMogItOptions_temp;
    end
    createOptionsMenu()
    CanIMogIt.MarkAsLoaded()
end

-- Fail-safe to ensure Loaded() gets called even if event handling is disrupted
-- This helps when multiple addons are competing for the same events
local loadedFlag = false

-- Add a function to track whether the addon has been loaded
function CanIMogIt.MarkAsLoaded()
    loadedFlag = true
end

-- Create a fail-safe timer to check if Loaded() has been called
C_Timer.After(2, function()
    if not loadedFlag then
        CanIMogIt.frame.Loaded()
        CanIMogIt.MarkAsLoaded()
    end
end)

CanIMogIt:RegisterChatCommand("cimi", "SlashCommands")
CanIMogIt:RegisterChatCommand("canimogit", "SlashCommands")

local function printHelp()
    CanIMogIt:Print([[
Can I Mog It? help:
    Usage: /cimi <command>
    e.g. /cimi help

    help            Displays this help message.
    debug           Toggles the debug tooltip.
    verbose         Toggles verbose mode on tooltip.
    overlay         Toggles the icon overlay.
    refresh         Refreshes the overlay, forcing a redraw.
    equiponly       Toggles showing overlay on non-equipable items.
    transmogonly    Toggles showing overlay on non-transmogable items.
    unknownonly     Toggles showing overlay on known items.
    toyitems        Toggles showing overlay on toy items.
    petitems        Toggles showing overlay on pet items.
    mountitems      Toggles showing overlay on mount items.
    ]])
end

function CanIMogIt:SlashCommands(input)
    -- Slash command router.
    if input == "" then
        self:OpenOptionsMenu()
    elseif input == 'debug' then
        CanIMogIt.frame.debug:Click()
    elseif input == 'overlay' then
        CanIMogIt.frame.showItemIconOverlay:Click()
    elseif input == 'verbose' then
        CanIMogIt.frame.showVerboseText:Click()
    elseif input == 'equiponly' then
        CanIMogIt.frame.showEquippableOnly:Click()
    elseif input == 'transmogonly' then
        CanIMogIt.frame.showTransmoggableOnly:Click()
    elseif input == 'unknownonly' then
        CanIMogIt.frame.showUnknownOnly:Click()
    elseif input == 'toyitems' then
        CanIMogIt.frame.showToyItems:Click()
    elseif input == 'petitems' then
        CanIMogIt.frame.showPetItems:Click()
    elseif input == 'mountitems' then
        CanIMogIt.frame.showMountItems:Click()
    elseif input == 'catalizableitems' then
        CanIMogIt.frame.showCatalizableItems:Click()
    elseif input == 'ensembleitems' then
        CanIMogIt.frame.showEnsembleItems:Click()
    elseif input == 'refresh' then
        self:ResetCache()
    elseif input == 'help' then
        printHelp()
    else
        self:Print("Unknown command!")
    end
end

function CanIMogIt:OpenOptionsMenu()
    Settings.OpenToCategory(CanIMogIt.settingsCategory.ID)
end
