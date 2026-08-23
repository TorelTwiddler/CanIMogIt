-- Adds tooltip support for World Quest Tab https://www.curseforge.com/wow/addons/worldquesttab

local addon = "WorldQuestTab"

local function AddWorldQuestTabHooks()
    CanIMogIt.HookableTooltips["WQT_GameTooltipTooltip"] = 1
    WQT_GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipCleared", function(self) CanIMogIt:TooltipCleared(self) end)
end

local function CheckAndLoadWorldQuestTab()
    local _, _, _, loadable, _ = C_AddOns.GetAddOnInfo(addon)
    if not loadable then return end

    local _, loaded = C_AddOns.IsAddOnLoaded(addon)
    if loaded then
        AddWorldQuestTabHooks()
        return
    end

    local function WorldQuestTabLoader(event, addonName)
        if event ~= "ADDON_LOADED" or addonName ~= addon then return end

        CanIMogIt:UnregisterEvent("ADDON_LOADED", WorldQuestTabLoader)

        AddWorldQuestTabHooks()
    end

    CanIMogIt:RegisterEvent("ADDON_LOADED", WorldQuestTabLoader)
end

CheckAndLoadWorldQuestTab()
