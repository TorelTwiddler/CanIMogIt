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


local function HookOverlayLoot(event)
    -- Add hook for the loot frames.
    for i=1,CanIMogIt.NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            local cimiFrame = frame.CanIMogItOverlay
            if not cimiFrame then
                cimiFrame = CIMI_AddToFrame(frame, LootFrame_CIMIUpdateIcon)
            end
            LootFrame_CIMIUpdateIcon(cimiFrame)
        end
    end
end

CanIMogIt.frame:AddSmartEvent(HookOverlayLoot, {"PLAYER_LOGIN", "START_LOOT_ROLL"})


------------------------
-- Event functions    --
------------------------


-- From ls: Toasts
local LOOT_ITEM_PATTERN = LOOT_ITEM_SELF:gsub("%%s", "(.+)")
local LOOT_ITEM_PUSHED_PATTERN = LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)")
local LOOT_ITEM_MULTIPLE_PATTERN = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)")
local LOOT_ITEM_PUSHED_MULTIPLE_PATTERN = LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub("%%s", "(.+)")
local PLAYER_NAME = UnitName("player")


local function ChatMessageLootEvent(event, message, _, _, _, target)
    -- Get the item link from the CHAT_MSG_LOOT event.
    if event ~= "CHAT_MSG_LOOT" then return end
    if not target then return end
    local player_name = strsplit("-", target)
    if player_name ~= PLAYER_NAME then
        return
    end

    local link = message:match(LOOT_ITEM_MULTIPLE_PATTERN)

    if not link then
        link = message:match(LOOT_ITEM_PUSHED_MULTIPLE_PATTERN)

        if not link then
            link = message:match(LOOT_ITEM_PATTERN)

            if not link then
                link = message:match(LOOT_ITEM_PUSHED_PATTERN)

                if not link then
                    return
                end
            end
        end
    end

    -- Remove the cache for this item
    CanIMogIt.cache:RemoveItem(link)

end

-- FIXME
-- CanIMogIt.frame:AddOverlayEventFunction(ChatMessageLootEvent)

CanIMogIt:RegisterMessage("OptionUpdate", ChatMessageLootEvent)
