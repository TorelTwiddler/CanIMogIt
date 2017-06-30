-- Overlay for the loot roll frames.-- Common functions used for overlays.


----------------------------
-- UpdateIcon functions   --
----------------------------


function LootFrame_CIMIUpdateIcon(self)
    if not self then return end
    -- Sets the icon overlay for the loot frame.
    local lootID = self:GetParent():GetParent().rollID
    if not CIMI_CheckOverlayIconEnabled() or lootID == nil then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetLootRollItemLink(lootID)
    CIMI_SetIcon(self, LootFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


function CanIMogIt.frame:HookItemOverlay(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the loot frames.
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            CIMI_AddToFrame(frame, LootFrame_CIMIUpdateIcon)
        end
    end
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

function CanIMogIt.frame:LootOverlayEvents(event, ...)
    if not CIMIEvents[event] then return end
    -- loot frames
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            LootFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end
