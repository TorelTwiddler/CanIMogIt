-- Overlay for the auction house.


----------------------------
-- UpdateIcon functions   --
----------------------------


-- local function AuctionFrame_OnUpdate(self, elapsed)
--     -- Sets the icon overlay for the auction frame.
--     if calculatedFrames[tostring(self)] then return end
--     calculatedFrames[tostring(self)] = true
--     if not CIMI_CheckOverlayIconEnabled() then return end
--     local browseButtonID = self:GetParent():GetID()
--     local index = BrowseScrollFrame.offset + browseButtonID
--     local itemLink = GetAuctionItemLink("list", index)
--     CIMI_SetIcon(self, CanIMogIt:GetTooltipText(itemLink))
-- end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


function CanIMogIt.frame:HookItemOverlay(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- -- function CanIMogIt.frame:OnAuctionHouseShow(event, ...)
    -- --     -- The button frames don't exist until the auction house is open.
    -- --     if event ~= "AUCTION_HOUSE_SHOW" then return end
    -- --     -- Add hook for the Auction House frames.
    -- --     for i=1,8 do
    -- --         local frame = _G["BrowseButton"..i.."Item"]
    -- --         CIMI_AddToFrame(frame, AuctionFrame_OnUpdate)
    -- --     end
    -- -- end
end

------------------------
-- Event functions    --
------------------------
