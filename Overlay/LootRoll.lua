-- Overlay for the loot roll frames.

----------------------------
-- UpdateIcon functions   --
----------------------------


function LootRollFrame_CIMIUpdateIcon(self)
    if not self then return end
    -- Sets the icon overlay for the loot frame.
    local lootID = self:GetParent():GetParent().rollID
    if not CIMI_CheckOverlayIconEnabled() or lootID == nil then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetLootRollItemLink(lootID)
    CIMI_SetIcon(self, LootRollFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Event functions    --
------------------------


local function HookOverlayLoot(event)
    -- Add hook for the loot frames.
    for i=1,CanIMogIt.NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            local cimiFrame = frame.CanIMogItOverlay
            if not cimiFrame then
                cimiFrame = CIMI_AddToFrame(frame, LootRollFrame_CIMIUpdateIcon)
            end
            LootRollFrame_CIMIUpdateIcon(cimiFrame)
        end
    end
end
CanIMogIt.eventFrame:AddSmartEvent(HookOverlayLoot, {"PLAYER_LOGIN", "START_LOOT_ROLL"})