local function ShowAllIllusions(itemsCollectionFrame)
    if not itemsCollectionFrame.transmogLocation:IsIllusion() then return end
    local newlist = {}
    for i, v in ipairs(CanIMogIt.Illusions) do
        table.insert(newlist, C_TransmogCollection.GetIllusionInfo(v.IllusionID))
    end
    itemsCollectionFrame.filteredVisualsList = newlist
end

local function AddSourceTooltipToIllusionModel(modelFrame)
    if not modelFrame.visualInfo then return end
    local itemsCollectionFrame = modelFrame:GetParent()
    if not itemsCollectionFrame.transmogLocation:IsIllusion() then return end

    local illusionID = modelFrame.visualInfo.sourceID
    if not illusionID then return end
    local illusion = CanIMogIt.IllusionsMap[illusionID]
    if not illusion then return end
    if illusion.Source and illusion.Source ~= '' then
        GameTooltip:AddLine(illusion.Source, 1, 1, 1, 1)
    end
end

local function SetupModelsHook(itemsCollectionFrame)
    for _, f in ipairs(itemsCollectionFrame.Models) do
        if not f.CIMIHooked then
            f:HookScript("OnEnter", AddSourceTooltipToIllusionModel)
            f.CIMIHooked = true
        end
    end
end

local blizzardCollectionsLoaded = false

local function SetupBlizzardCollectionsHooks()
    if blizzardCollectionsLoaded then return end
    blizzardCollectionsLoaded = true
    hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame, 'FilterVisuals', ShowAllIllusions)
    hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame, "UpdateItems", SetupModelsHook)

end

-- Main handler for when the addon is loaded
local function OnBlizzardCollectionsLoaded(event, addonName, ...)
    if event ~= "ADDON_LOADED" then return end
    if addonName ~= "Blizzard_Collections" then return end
    SetupBlizzardCollectionsHooks()
end

if CanIMogIt.isRetail then
    CanIMogIt.frame:AddSmartEvent(OnBlizzardCollectionsLoaded, {"ADDON_LOADED"})

    -- Fail-safe: Check if the EncounterJournal is already loaded
    -- This helps when addon loading order is changed by other addons
    C_Timer.After(1, function()
        local _, loaded = C_AddOns.IsAddOnLoaded("Blizzard_Collections")
        if loaded and not blizzardCollectionsLoaded then
            SetupBlizzardCollectionsHooks()
        end
    end)

    -- Additional fail-safe: Check again after a longer delay
    C_Timer.After(5, function()
        local _, loaded = C_AddOns.IsAddOnLoaded("Blizzard_Collections")
        if loaded and not blizzardCollectionsLoaded then
            SetupBlizzardCollectionsHooks()
        end
    end)
end