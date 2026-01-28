-- TODO: this is a quick setup, streamline this and encapsulate eventFrame better
-- (e.g. CanIMogIt:AddSmartEvent instead of CanIMogIt.eventFrame:AddSmartEvent)
CanIMogIt.eventFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
CanIMogIt.eventFrame:SetPoint("BOTTOMLEFT", UIParent, "TOPLEFT", 0, 0);
CanIMogIt.eventFrame:SetSize(1, 1);

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
    table.insert(EVENTS, "PET_JOURNAL_LIST_UPDATE")
end


for i, event in pairs(EVENTS) do
    CanIMogIt.eventFrame:RegisterEvent(event);
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


CanIMogIt.eventFrame:SetScript("OnUpdate", RunIfNotBusyEvents)
CanIMogIt.eventFrame:Show();


CanIMogIt.eventFrame.eventFunctions = {}


-- a dictionary of event names to a list of functions to run.
-- {event, {func}}
CanIMogIt.eventFrame.smartEventFunctions = {}


function CanIMogIt.eventFrame:AddSmartEvent(func, events)
    -- Smart events only run if there is enough time in the frame, otherwise,
    -- it pushes it off to the next frame to run.
    for i, event in ipairs(events) do
        if not CanIMogIt.eventFrame.smartEventFunctions[event] then
            CanIMogIt.eventFrame.smartEventFunctions[event] = {}
        end
        table.insert(CanIMogIt.eventFrame.smartEventFunctions[event], func)
    end
end


local function RunSmartEvent(event, ...)
    -- Run the overlay events if we are not busy.
    for i, func in ipairs(CanIMogIt.eventFrame.smartEventFunctions[event]) do
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
    if CanIMogIt.eventFrame.smartEventFunctions[event] then
        RunSmartEvent(event, ...)
    end
end
CanIMogIt.eventFrame:SetScript("OnEvent", SmartEventHook);


function CanIMogIt.frame.AddonLoaded(event, addonName)
    if event == "ADDON_LOADED" and addonName == "CanIMogIt" then
        CanIMogIt.frame.Loaded()
    end
end
CanIMogIt.eventFrame:AddSmartEvent(CanIMogIt.frame.AddonLoaded, {"ADDON_LOADED"})


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

CanIMogIt.eventFrame:AddSmartEvent(TransmogCollectionUpdated, {"TRANSMOG_COLLECTION_SOURCE_ADDED", "TRANSMOG_COLLECTION_SOURCE_REMOVED", "TRANSMOG_COLLECTION_UPDATED"})
