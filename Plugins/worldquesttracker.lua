-- Adds tooltip to World Quest Tracker https://www.curseforge.com/wow/addons/world-quest-tracker

local function AddWQTHooks()
    CanIMogIt.HookableTooltips["WorldQuestTrackerGameTooltipItemTooltipTooltip"] = 1
    WorldQuestTrackerGameTooltipItemTooltipTooltip:HookScript("OnTooltipCleared", function(self) CanIMogIt:TooltipCleared(self) end)
end

local function CheckAndLoadWQT()
    local _, _, _, loadable, _ = C_AddOns.GetAddOnInfo("WorldQuestTracker")
    if not loadable then return end

    local _, loaded = C_AddOns.IsAddOnLoaded("WorldQuestTracker")
    if loaded then
        AddWQTHooks()
        return
    end

    local function WQTLoader(event, addonName)
        if event ~= "ADDON_LOADED" or addonName ~= "WorldQuestTracker" then return end

        CanIMogIt:UnregisterEvent("ADDON_LOADED", WQTLoader)

        AddWQTHooks()
    end

    CanIMogIt:RegisterEvent("ADDON_LOADED", WQTLoader)
end

CheckAndLoadWQT()
