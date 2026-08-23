-- Adds tooltip support for World Quest Tab https://www.curseforge.com/wow/addons/worldquesttab

local addon = "WorldQuestTab"

local function AddWorldQuestTabHook()
    CanIMogIt.HookableTooltips["WQT_GameTooltipTooltip"] = 1
end

local function CheckAndLoadWorldQuestTab()
    local _, _, _, loadable, _ = C_AddOns.GetAddOnInfo(addon)
    if not loadable then return end

    local _, loaded = C_AddOns.IsAddOnLoaded(addon)
    if loaded then
        AddWorldQuestTabHook()
        return
    end

    local function WorldQuestTabLoader(event, addonName)
        if event ~= "ADDON_LOADED" or addonName ~= addon then return end

        CanIMogIt:UnregisterEvent("ADDON_LOADED", WorldQuestTabLoader)

        AddWorldQuestTabHook()
    end

    CanIMogIt:RegisterEvent("ADDON_LOADED", WorldQuestTabLoader)
end

CheckAndLoadWorldQuestTab()
