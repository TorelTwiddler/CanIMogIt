-- Overlay for Adventure Guide loot.

------------------------
-- Function hooks     --
------------------------

-- this may be called twice, not ready at first, and ready to show later triggered by EJ_LOOT_DATA_RECIEVED
local function EncounterJournalItemMixin_Init_Hook(lootItemFrame)
    local itemLink = lootItemFrame.link
    if not itemLink then return end

    CIMI_AddToFrame(lootItemFrame, nil, "EncounterJournal"..lootItemFrame.index, "TOPRIGHT")
    local overlay = lootItemFrame.CanIMogItOverlay
    if not CIMI_CheckOverlayIconEnabled(overlay) then
        overlay.CIMIIconTexture:SetShown(false)
        return
    end
    CIMI_SetIcon(lootItemFrame.CanIMogItOverlay, nil, CanIMogIt:GetTooltipText(itemLink))
end

local function EncounterJournalEncounterFrameInfo_Hook_Exists(encounterJournalLootFrame)
    local lootItemFrames = encounterJournalLootFrame.ScrollBox:GetFrames()
    for i = 1, #lootItemFrames do
        local frame = lootItemFrames[i]
        if frame then
            if not frame.EncounterJournalItemMixin_Init_Hooked then
                hooksecurefunc(frame, "Init", EncounterJournalItemMixin_Init_Hook)
                frame.EncounterJournalItemMixin_Init_Hooked = true
                EncounterJournalItemMixin_Init_Hook(frame)
            end
        end
    end
end

----------------------------
-- Begin adding to frames --
----------------------------


local encounterJournalLoaded = false

-- Function to set up the hooks when the EncounterJournal is loaded
local function SetupEncounterJournalHooks()
    -- Don't set up twice
    if encounterJournalLoaded then return end
    encounterJournalLoaded = true

    local encounterJournalLootFrame = _G["EncounterJournalEncounterFrameInfo"].LootContainer

    -- hook lootItemMixin for lootItemFrames created later
    hooksecurefunc(EncounterJournalItemMixin, "Init", EncounterJournalItemMixin_Init_Hook)
    EncounterJournalItemMixin.EncounterJournalItemMixin_Init_Hooked = true
    -- there are ItemFrame created before we hook them
    EncounterJournalEncounterFrameInfo_Hook_Exists(encounterJournalLootFrame)
end

-- Main handler for when the addon is loaded
local function OnEncounterJournalLoaded(event, addonName, ...)
    if event ~= "ADDON_LOADED" then return end
    if addonName ~= "Blizzard_EncounterJournal" then return end
    SetupEncounterJournalHooks()
end

if CanIMogIt.isRetail then
    CanIMogIt.frame:AddSmartEvent(OnEncounterJournalLoaded, {"ADDON_LOADED"})

    -- Fail-safe: Check if the EncounterJournal is already loaded
    -- This helps when addon loading order is changed by other addons
    C_Timer.After(1, function()
        local _, loaded = C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal")
        if loaded and not encounterJournalLoaded then
            SetupEncounterJournalHooks()
        end
    end)

    -- Additional fail-safe: Check again after a longer delay
    C_Timer.After(5, function()
        local _, loaded = C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal")
        if loaded and not encounterJournalLoaded then
            SetupEncounterJournalHooks()
        end
    end)
end


------------------------
-- Event functions    --
------------------------


local function EncounterJournalOverlayEvents(event, ...)
    -- First try setting up if not yet done - for cases where event order changed
    local _, loaded = C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal")
    if loaded and not encounterJournalLoaded then
        SetupEncounterJournalHooks()
    end

    -- Now update icons if loaded
    if encounterJournalLoaded then
        EncounterJournalFrame_CIMIOnValueChanged()
    end
end

if CanIMogIt.isRetail then
    CanIMogIt.frame:AddSmartEvent(EncounterJournalOverlayEvents, {"PLAYER_LOGIN"})



    CanIMogIt:RegisterMessage("OptionUpdate", EncounterJournalOverlayEvents)
end
