-- Overlay for the auction house.
-- Thanks to crappyusername on Curse for some of the code.

----------------------------
-- UpdateIcon functions   --
----------------------------


local function AuctionFrame_OnUpdate(self)
     -- Sets the icon overlay for the auction frame.
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local numItems = GetNumAuctionItems("list")
    local index = self:GetParent():GetID()
    local itemLink = GetAuctionItemLink("list", index)
    local text = CanIMogIt:GetTooltipText(itemLink)
    CIMI_SetIcon(self, AuctionFrame_OnUpdate, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function VerticalScroll(self, offset)
    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

    for i=1, NUM_BROWSE_TO_DISPLAY do
        local frame = _G["CIMIOverlayFrame_BrowseButton"..i.."Item"]
        if frame then
            local index = i + offset
            local itemLink = GetAuctionItemLink("list", index)
            local text = CanIMogIt:GetTooltipText(itemLink)
            CIMI_SetIcon(frame, AuctionFrame_OnUpdate, CanIMogIt:GetTooltipText(itemLink))
        end
    end
end


local function OnAuctionHouseShow(event, ...)
    -- The button frames don't exist until the auction house is open.
    if event ~= "AUCTION_HOUSE_SHOW" then return end
    -- Add hook for the Auction House frames.
    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

    for i=1, NUM_BROWSE_TO_DISPLAY do
        local frame = _G["BrowseButton"..i.."Item"]
        if frame then
            frame:SetID(i + offset)
            CIMI_AddToFrame(frame, AuctionFrame_OnUpdate)
        end
    end
    -- add hook for scroll event of auction scroll frame

    local hookframe = _G["BrowseScrollFrame"]
    if hookframe then
        hookframe:HookScript("OnVerticalScroll", VerticalScroll)
    end
end
CanIMogIt.frame:AddEventFunction(OnAuctionHouseShow)


local function OnAuctionHouseUpdate(event, ...)
    -- The button frames don't exist until the auction house is open.
    if event ~= "AUCTION_ITEM_LIST_UPDATE" then return end

    -- Add hook for the Auction House frames.
    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

    -- refresh overlay of buttons created OnAuctionHouseShow function.
    for i=1, NUM_BROWSE_TO_DISPLAY do
        local frame = _G["CIMIOverlayFrame_BrowseButton"..i.."Item"]
        if frame then
            local index = i + offset
            local itemLink = GetAuctionItemLink("list", index)
            local text = CanIMogIt:GetTooltipText(itemLink)
            CIMI_SetIcon(frame, AuctionFrame_OnUpdate, CanIMogIt:GetTooltipText(itemLink))
        end
    end
end
CanIMogIt.frame:AddEventFunction(OnAuctionHouseUpdate)


------------------------
-- Event functions    --
------------------------
