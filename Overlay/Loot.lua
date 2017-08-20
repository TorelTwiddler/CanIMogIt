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


local function HookOverlayLoot(self, event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the loot frames.
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            CIMI_AddToFrame(frame, LootFrame_CIMIUpdateIcon)
        end
    end
end

hooksecurefunc(CanIMogIt.frame, "HookItemOverlay", HookOverlayLoot)


------------------------
-- Event functions    --
------------------------


local function LootOverlayEvents(event, ...)
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            LootFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end

CanIMogIt.frame:AddOverlayEventFunction(LootOverlayEvents)