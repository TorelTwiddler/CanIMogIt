

-- local theTime = GetTime()
--TODO: Turn resetDelay into a user option
local resetDelay = .3
-- local resetTime = theTime + resetDelay

-- local calculatedFrames = {}


-- function iconOverlayUpdateDelay(self, elapsed)
--     -- Delays the update of the icon overlay by resetDelay seconds.
--     theTime = GetTime()
--     if theTime > resetTime then
--         calculatedFrames = {}
--         resetTime = theTime + resetDelay
--     end
-- end
-- CanIMogIt.frame:HookScript("OnUpdate", iconOverlayUpdateDelay)



----------------------------
-- Core Overlay functions --
----------------------------


local function CheckOptionEnabled(frame)
    -- Checks if the item overlay option is enabled.
    if not CanIMogItOptions["showItemIconOverlay"] then
        return false
    end
    return true
end


local function SetIcon(frame, updateIconFunc, text, unmodifiedText)
    -- Sets the icon based on the text for the CanIMogItOverlay on the given frame.
    frame.text = tostring(text)
    frame.unmodifiedText = tostring(unmodifiedText)
    if text == nil then
        -- nil means not all data was available to get the text. Try again later.
        frame.CIMIIconTexture:SetShown(false)
        frame:SetScript("OnUpdate", CIMIOnUpdateFuncMaker(updateIconFunc));
    elseif text == "" then
        -- An empty string means that the text shouldn't be displayed.
        frame.CIMIIconTexture:SetShown(false)
        frame:SetScript("OnUpdate", nil);
    else
        -- Show an icon!
        frame.CIMIIconTexture:SetShown(true)
        local icon = CanIMogIt.tooltipIcons[unmodifiedText]
        frame.CIMIIconTexture:SetTexture(icon, false)
        frame:SetScript("OnUpdate", nil);
    end
    frame.shown = frame.CIMIIconTexture:IsShown()
end


local function AddToFrame(parentFrame, updateIconFunc)
    -- Create the Texture and set OnUpdate
    if parentFrame and not parentFrame.CanIMogItOverlay then
        frame = CreateFrame("Frame", "CIMIOverlayFrame_"..tostring(parentFrame:GetName()), parentFrame)
        parentFrame.CanIMogItOverlay = frame
        -- Get the frame to match the shape/size of its parent
        frame:SetAllPoints()

        -- Create the texture frame.
        frame.CIMIIconTexture = frame:CreateTexture("CIMITextureFrame", "OVERLAY")
        frame.CIMIIconTexture:SetWidth(13)
        frame.CIMIIconTexture:SetHeight(13)
        frame.CIMIIconTexture:SetPoint("TOPRIGHT", -2, -2)
        frame.timeSinceCIMIIconCheck = 0
        frame:SetScript("OnUpdate", CIMIOnUpdateFuncMaker(updateIconFunc))
    end
end


function CIMIOnUpdateFuncMaker(func)
    function CIMIOnUpdate(self, elapsed)
        -- Attempts to update the icon again after the delay has elapsed.
        self.timeSinceCIMIIconCheck = self.timeSinceCIMIIconCheck + elapsed
        if self.timeSinceCIMIIconCheck >= resetDelay then
            self.timeSinceCIMIIconCheck = 0
            func(self)
        end
    end
    return CIMIOnUpdate
end


----------------------------
-- UpdateIcon functions   --
----------------------------


function ContainerFrameItemButton_CIMIUpdateIcon(self)
    if not self or not self:GetParent() or not self:GetParent():GetParent() then return end
    if not CheckOptionEnabled(self) then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end
    local bag, slot = self:GetParent():GetParent():GetID(), self:GetParent():GetID()
    -- need to catch 0, 0 and 100, 0 here because the bank frame doesn't
    -- load everything immediately, so the OnUpdate needs to run until those frames are opened.
    if (bag == 0 and slot == 0) or (bag == 100 and slot == 0) then return end
    SetIcon(self, ContainerFrameItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
end


function LootFrame_CIMIUpdateIcon(self)
    if not self then return end
    -- Sets the icon overlay for the loot frame.
    local lootID = self:GetParent():GetParent().rollID
    if not CheckOptionEnabled(self) or lootID == nil then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetLootRollItemLink(lootID)
    SetIcon(self, LootFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


function MerchantFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CheckOptionEnabled(self) then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = self:GetParent().link
    if itemLink == nil then
        SetIcon(self, MerchantFrame_CIMIUpdateIcon, nil)
    else
        SetIcon(self, MerchantFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


-- local function JournalFrame_SetLootButton(itemFrame)
--     -- Sets the icon overlay for the merchant frame.
--     if calculatedFrames[tostring(self)] then return end
--     calculatedFrames[tostring(self)] = true
--     if not CheckOptionEnabled(itemFrame) then return end
--     local itemLink = itemFrame.link
--     SetIcon(itemFrame, CanIMogIt:GetTooltipText(itemLink))
-- end


-- local function AuctionFrame_OnUpdate(self, elapsed)
--     -- Sets the icon overlay for the auction frame.
--     if calculatedFrames[tostring(self)] then return end
--     calculatedFrames[tostring(self)] = true
--     if not CheckOptionEnabled(self) then return end
--     local browseButtonID = self:GetParent():GetID()
--     local index = BrowseScrollFrame.offset + browseButtonID
--     local itemLink = GetAuctionItemLink("list", index)
--     SetIcon(self, CanIMogIt:GetTooltipText(itemLink))
-- end


function MailFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CheckOptionEnabled(self) then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local frameID = self:GetParent():GetID()

    local messageIndex;
    -- 7 is the number of visible inbox buttons at a time.
    for i=1,7 do
        local mailFrame = _G["MailItem"..i.."Button"]
        if mailFrame:IsShown() and mailFrame:GetChecked() then
            messageIndex = mailFrame.index
        end
    end
    if not messageIndex then
        SetIcon(self, MailFrame_CIMIUpdateIcon, "")
        return
    end

    local itemLink = GetInboxItemLink(messageIndex, frameID)
    SetIcon(self, MailFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


function GuildBankFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CheckOptionEnabled(self) then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local tab = GetCurrentGuildBankTab()
    local slot = self:GetParent():GetID()
    local itemLink = GetGuildBankItemLink(tab, slot)
    SetIcon(self, GuildBankFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


function VoidStorageFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CheckOptionEnabled(self) then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local page = _G["VoidStorageFrame"].page
    local buttonSlot = self:GetParent().slot
    local voidSlot = buttonSlot + (80 * (page - 1))
    local itemLink = GetVoidItemHyperlinkString(voidSlot)
    SetIcon(self, VoidStorageFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


function MailFrame_CIMIOnClick()
    for i=1,ATTACHMENTS_MAX_SEND do
        local frame = _G["OpenMailAttachmentButton"..i]
        if frame then
            MailFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


function MerchantFrame_CIMIOnClick()
    for i=1,10 do
        local frame = _G["MerchantItem"..i.."ItemButton"]
        if frame then
            MerchantFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


function VoidStorageFrame_CIMIOnClick()
    for i=1,80 do
        local frame = _G["VoidStorageStorageButton"..i]
        if frame then
            VoidStorageFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


function CanIMogIt.frame:HookItemOverlay(event, addonName)
    if event ~= "PLAYER_LOGIN" and addonName ~= "CanIMogIt" then return end

    -- Add hook for each bag item.
    for i=1,NUM_CONTAINER_FRAMES do
        for j=1,MAX_CONTAINER_ITEMS do
            local frame = _G["ContainerFrame"..i.."Item"..j]
            AddToFrame(frame, ContainerFrameItemButton_CIMIUpdateIcon)
        end
    end

    -- Add hook for the main bank frame.
    for i=1,NUM_BANKGENERIC_SLOTS do
        local frame = _G["BankFrameItem"..i]
        AddToFrame(frame, ContainerFrameItemButton_CIMIUpdateIcon)
    end

    -- Add hook for the loot frames.
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        AddToFrame(frame, LootFrame_CIMIUpdateIcon)
    end

    -- Add hook for the Mail inbox frames.
    for i=1,ATTACHMENTS_MAX_SEND do
        local frame = _G["OpenMailAttachmentButton"..i]
        AddToFrame(frame, MailFrame_CIMIUpdateIcon)
    end

    -- Add hook for clicking on mail (since there is no event).
    -- 7 is the number of visible inbox buttons at a time.
    for i=1,7 do
        local frame = _G["MailItem"..i.."Button"]
        if frame then
            frame:HookScript("OnClick", MailFrame_CIMIOnClick)
        end
    end

    -- Add hook for the Merchant frames.
    -- 10 is the number of merchant items visible at once.
    for i=1,10 do
        local frame = _G["MerchantItem"..i.."ItemButton"]
        AddToFrame(frame, MerchantFrame_CIMIUpdateIcon)
    end

    -- Add hook for clicking on the next or previous buttons in the
    -- merchant frames (since there is no event).
    if _G["MerchantNextPageButton"] then
        _G["MerchantNextPageButton"]:HookScript("OnClick", MerchantFrame_CIMIOnClick)
    end
    if _G["MerchantPrevPageButton"] then
        _G["MerchantPrevPageButton"]:HookScript("OnClick", MerchantFrame_CIMIOnClick)
    end
    if _G["MerchantFrame"] then
        _G["MerchantFrame"]:HookScript("OnMouseWheel", MerchantFrame_CIMIOnClick)
    end


    -- -- function CanIMogIt.frame:OnAuctionHouseShow(event, ...)
    -- --     -- The button frames don't exist until the auction house is open.
    -- --     if event ~= "AUCTION_HOUSE_SHOW" then return end
    -- --     -- Add hook for the Auction House frames.
    -- --     for i=1,8 do
    -- --         local frame = _G["BrowseButton"..i.."Item"]
    -- --         AddToFrame(frame, AuctionFrame_OnUpdate)
    -- --     end
    -- -- end

    -- -- function CanIMogIt.frame:OnEncounterJournalLoaded(event, addonName, ...)
    -- --     if event ~= "ADDON_LOADED" then return end
    -- --     if addonName ~= "Blizzard_EncounterJournal" then return end
    -- --     for i=1,10 do
    -- --         local frame = _G["EncounterJournalEncounterFrameInfoLootScrollFrameButton"..i]
    -- --         AddToFrame(frame)
    -- --     end
    -- --     hooksecurefunc("EncounterJournal_SetLootButton", JournalFrame_SetLootButton)
    -- -- end



end


local guildBankLoaded = false

function CanIMogIt.frame:OnGuildBankOpened(event, ...)
    if event ~= "GUILDBANKFRAME_OPENED" then return end
    if guildBankLoaded == true then return end
    guildBankLoaded = true
    for column=1,7 do
        for button=1,14 do
            local frame = _G["GuildBankColumn"..column.."Button"..button]
            AddToFrame(frame, GuildBankFrame_CIMIUpdateIcon)
        end
    end
end


local voidStorageLoaded = false

function CanIMogIt.frame:OnVoidStorageOpened(event, ...)
    -- Add the overlay to the void storage frame.
    if event ~= "VOID_STORAGE_OPEN" then return end
    if voidStorageLoaded == true then return end
    voidStorageLoaded = true
    for i=1,80 do
        local frame = _G["VoidStorageStorageButton"..i]
        AddToFrame(frame, VoidStorageFrame_CIMIUpdateIcon)
    end

    local voidStorageFrame = _G["VoidStorageFrame"]
    if voidStorageFrame then
        -- if the frame doesn't exist, then it's likely overwritten by an addon.
        voidStorageFrame.Page1:HookScript("OnClick", VoidStorageFrame_CIMIOnClick)
        voidStorageFrame.Page2:HookScript("OnClick", VoidStorageFrame_CIMIOnClick)
    end
end

------------------------
-- Event functions    --
------------------------

local events = {
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
}

function CanIMogIt.frame:ItemOverlayEvents(event, ...)
    if not events[event] then return end
    -- bags
    for i=1,NUM_CONTAINER_FRAMES do
        for j=1,MAX_CONTAINER_ITEMS do
            local frame = _G["ContainerFrame"..i.."Item"..j]
            if frame then
                ContainerFrameItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
            end
        end
    end
    -- main bank frame
    for i=1,NUM_BANKGENERIC_SLOTS do
        local frame = _G["BankFrameItem"..i]
        if frame then
            ContainerFrameItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end

    -- loot frames
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            LootFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end

    -- merchant frames
    MerchantFrame_CIMIOnClick()

    -- void storage frames
    if voidStorageLoaded then
        VoidStorageFrame_CIMIOnClick()
    end

    -- guild bank frames
    if guildBankLoaded then
        for column=1,7 do
            for button=1,14 do
                local frame = _G["GuildBankColumn"..column.."Button"..button]
                if frame then
                    GuildBankFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
    end
end
