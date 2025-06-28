-- Overlay for Adventure Guide loot.


----------------------------
-- UpdateIcon functions   --
----------------------------


function EncounterJournalFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = self:GetParent().link
    CIMI_SetIcon(self, EncounterJournalFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


local function EncounterJournalFrame_CIMISetLootButton(self)
    -- Sets the icon overlay for the Encounter Journal dungeon and raid tabs.
    local overlay = self.CanIMogItOverlay
    if not overlay then return end
    if not CIMI_CheckOverlayIconEnabled(overlay) then
        overlay.CIMIIconTexture:SetShown(false)
        overlay:SetScript("OnUpdate", nil)
        return
    end
    local itemLink = self.link
    CIMI_SetIcon(overlay, EncounterJournalFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


function EncounterJournalFrame_CIMIOnValueChanged(_, elapsed)
    if not CanIMogIt.FrameShouldUpdate("EncounterJournal", elapsed or 1) then return end
    local encounterJournalScrollFrame = _G["EncounterJournalEncounterFrameInfo"].LootContainer.ScrollBox
    local lootItemFrames = encounterJournalScrollFrame:GetFrames()
    for i = 1, #lootItemFrames do
        local frame = lootItemFrames[i]
        if frame then
            CIMI_AddToFrame(frame, EncounterJournalFrame_CIMIUpdateIcon, "EncounterJournal"..i, "TOPRIGHT")
            EncounterJournalFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
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
    encounterJournalLootFrame:HookScript("OnUpdate", EncounterJournalFrame_CIMIOnValueChanged)
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
