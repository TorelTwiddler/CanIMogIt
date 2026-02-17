-- Overlay for loot frame.

----------------------------
-- UpdateIcon functions   --
----------------------------


function LootFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetLootSlotLink(self:GetParent():GetParent():GetSlotIndex())
    if itemLink then
        CIMI_SetIcon(self, LootFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


------------------------
-- Function hooks     --
------------------------


function UpdateLootButtons()
    for _, frame in next, LootFrame.ScrollBox.view.frames do
        if frame.Item then
            local cimiFrame = frame.Item.CanIMogItOverlay
            if not cimiFrame then
                cimiFrame = CIMI_AddToFrame(frame.Item, LootFrame_CIMIUpdateIcon)
            end
            LootFrame_CIMIUpdateIcon(cimiFrame)
        end
    end
end
LootFrame:HookScript("OnShow", UpdateLootButtons)


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
-- CanIMogIt.eventFrame:AddOverlayEventFunction(ChatMessageLootEvent)
CanIMogIt:RegisterMessage("OptionUpdate", ChatMessageLootEvent)