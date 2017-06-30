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


function EncounterJournalFrame_CIMIOnValueChanged()
    for i=1,10 do
        local frame = _G["EncounterJournalEncounterFrameInfoLootScrollFrameButton"..i]
        EncounterJournalFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local encounterJournalLoaded = false

function CanIMogIt.frame:OnEncounterJournalLoaded(event, addonName, ...)
    if event ~= "ADDON_LOADED" then return end
    if addonName ~= "Blizzard_EncounterJournal" then return end
    for i=1,10 do
        local frame = _G["EncounterJournalEncounterFrameInfoLootScrollFrameButton"..i]
        if frame then
            CIMI_AddToFrame(frame, EncounterJournalFrame_CIMIUpdateIcon)
        end
    end
    hooksecurefunc("EncounterJournal_SetLootButton", EncounterJournalFrame_CIMISetLootButton)
    _G["EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar"]:HookScript("OnValueChanged", EncounterJournalFrame_CIMIOnValueChanged)
end


------------------------
-- Event functions    --
------------------------

CIMIEvents = {
    ["UNIT_INVENTORY_CHANGED"] = true,
    ["PLAYER_SPECIALIZATION_CHANGED"] = true,
    ["BAG_UPDATE"] = true,
    ["BAG_NEW_ITEMS_UPDATED"] = true,
    ["QUEST_ACCEPTED"] = true,
    ["BAG_SLOT_FLAGS_UPDATED"] = true,
    ["BANK_BAG_SLOT_FLAGS_UPDATED"] = true,
    ["PLAYERBANKSLOTS_CHANGED"] = true,
    ["BANKFRAME_OPENED"] = true,
    ["START_LOOT_ROLL"] = true,
    ["MERCHANT_SHOW"] = true,
    ["VOID_STORAGE_OPEN"] = true,
    ["VOID_STORAGE_CONTENTS_UPDATE"] = true,
    ["GUILDBANKBAGSLOTS_CHANGED"] = true,
    ["PLAYERREAGENTBANKSLOTS_CHANGED"] = true,
}

function CanIMogIt.frame:EncounterJournalOverlayEvents(event, ...)
    if not CIMIEvents[event] then return end
    
    if encounterJournalLoaded then
        EncounterJournalFrame_CIMIOnValueChanged()
    end
end
