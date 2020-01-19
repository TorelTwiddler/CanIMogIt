-- Overlay for the auction house.

-- TODO: Clean up comments and notes

-- Auction house buttons:
-- AuctionHouseFrameScrollChild:GetParent().buttons

-- button.rowData.itemKey (itemID and itemSuffix?)

-- ITEM_NAME_CELL = 2
-- button.cells[ITEM_NAME_CELL].Icon

-- x = {["battlePetSpeciesID"] = 0, ["itemID"] = 2140, ["itemLevel"] = 11, ["itemSuffix"] = 0}

----------------------------
-- UpdateIcon functions   --
----------------------------

function AuctionHouseFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local button = self:GetParent()
    local rowData = button.rowData
    local itemLink
    -- TODO: refactor getting the item link to a separate function.
    if rowData then
        if rowData.appearanceLink then
            -- Items that have multiple appearances under the same itemID also include an appearance ID.
            -- Use that to get the appearance instead.
            local sourceID = string.match(rowData.appearanceLink, ".*transmogappearance:?(%d*)|.*")
            if sourceID then
                itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            else
                itemLink = nil
            end
        else
            -- Most items have a single appearance, and will use this code.
            local itemKey = rowData.itemKey
            itemLink = "|Hitem:".. itemKey.itemID .."|h"
        end
    else
        itemLink = nil
    end

    if itemLink == nil then
        CIMI_SetIcon(self, AuctionHouseFrame_CIMIUpdateIcon, nil)
    else
        CIMI_SetIcon(self, AuctionHouseFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end

------------------------
-- Function hooks     --
------------------------

function AuctionHouseFrame_CIMIOnValueChanged()
    local buttons = _G["AuctionHouseFrameScrollChild"]:GetParent().buttons
    for i, button in pairs(buttons) do
        AuctionHouseFrame_CIMIUpdateIcon(button.CanIMogItOverlay)
    end
end


----------------------------
-- Begin adding to frames --
----------------------------

local function HookOverlayAuctionHouse(event)
    if event ~= "AUCTION_HOUSE_SHOW" then return end

    -- Add hook for the Auction House frames.
    local buttons = _G["AuctionHouseFrameScrollChild"]:GetParent().buttons
    for i, button in pairs(buttons) do
        local frame = button
        frame.CIMI_index = i
        if frame then
            -- TODO: Move the CIMI frame either next to the icon, or next to the favorite star.
            CIMI_AddToFrame(frame, AuctionHouseFrame_CIMIUpdateIcon, "AuctionHouse"..i, "LEFT")
        end
    end
    local scrollBar = _G["AuctionHouseFrame"].BrowseResultsFrame.ItemList.ScrollFrame.scrollBar
    scrollBar:HookScript("OnValueChanged", AuctionHouseFrame_CIMIOnValueChanged)
end

CanIMogIt.frame:AddEventFunction(HookOverlayAuctionHouse)

------------------------
-- Event functions    --
------------------------

local function AuctionHouseUpdateEvents(event, ...)
    if event ~= "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then return end
    C_Timer.After(.1, AuctionHouseFrame_CIMIOnValueChanged)
end

CanIMogIt.frame:AddEventFunction(AuctionHouseUpdateEvents)
