-- Adds tooltip support for World Quest Tracker https://www.curseforge.com/wow/addons/world-quest-tracker

local addon = "WorldQuestTracker"

local function AddWorldQuestTrackerHooks()
    CanIMogIt.HookableTooltips["WorldQuestTrackerGameTooltipItemTooltipTooltip"] = 1
    WorldQuestTrackerGameTooltipItemTooltipTooltip:HookScript("OnTooltipCleared", function(self) CanIMogIt:TooltipCleared(self) end)
end

local function CheckAndLoadWorldQuestTracker()
    local _, _, _, loadable, _ = C_AddOns.GetAddOnInfo(addon)
    if not loadable then return end

    local _, loaded = C_AddOns.IsAddOnLoaded(addon)
    if loaded then
        AddWorldQuestTrackerHooks()
        return
    end

    local function WorldQuestTrackerLoader(event, addonName)
        if event ~= "ADDON_LOADED" or addonName ~= addon then return end

        CanIMogIt:UnregisterEvent("ADDON_LOADED", WorldQuestTrackerLoader)

        AddWorldQuestTrackerHooks()
    end

    CanIMogIt:RegisterEvent("ADDON_LOADED", WorldQuestTrackerLoader)
end

CheckAndLoadWorldQuestTracker()
