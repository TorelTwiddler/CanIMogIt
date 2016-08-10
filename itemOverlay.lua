

local function CheckOptionEnabled(frame)
    -- Checks if the option is enabled. If it's not, then clear the text.
    if not CanIMogItOptions["showItemIconOverlay"] then
        if self.CanIMogItIcon:GetText() then
            self.CanIMogItIcon:SetText()
        end
        return false
    end
    return true
end


local function SetIcon(frame, text)
    -- Sets the icon based on the text for the CanIMogItIcon on the given frame.
    if not text then frame.CanIMogItIcon:SetText(); return end
    local icon = CanIMogIt:GetValueInTableFromText(CanIMogIt.tooltipIcons, text)
    if icon ~= frame.CanIMogItIcon:GetText() then
        frame.CanIMogItIcon:SetText(icon)
    end
end


local function ContainerFrame_OnUpdate(self, elapsed)
    -- Sets the icon overlay for the current bag and slot.
    if not CheckOptionEnabled(self) then return end
    local bag, slot = self:GetParent():GetID(), self:GetID()
    local text = CanIMogIt:GetTooltipText(nil, bag, slot)
    SetIcon(self, text)
end


local function LootFrame_OnUpdate(self, elapsed)
    -- Sets the icon overlay for the loot frame.
    if not CheckOptionEnabled(self) then return end
    local lootID = self:GetParent().rollID
    local itemLink = GetLootRollItemLink(lootID)
    SetIcon(self, CanIMogIt:GetTooltipText(itemLink))
end


local function MerchantFrame_OnUpdate(self, elapsed)
    -- Sets the icon overlay for the merchant frame.
    if not CheckOptionEnabled(self) then return end
    local itemLink = self.link
    SetIcon(self, CanIMogIt:GetTooltipText(itemLink))
end


local function MailFrame_OnUpdate(self, elapsed)
    -- Sets the icon overlay for the mail attachement frame.
    if not CheckOptionEnabled(self) then return end
    local frameID = self:GetID()

    local messageIndex;
    -- 7 is the number of visible inbox buttons at a time.
    for i=1,7 do
        local mailFrame = _G["MailItem"..i.."Button"]
        if mailFrame:GetChecked() then
            messageIndex = mailFrame.index
        end
    end
    if not messageIndex then
        SetIcon(self, nil)
        return
    end

    local itemLink = GetInboxItemLink(messageIndex, frameID)
    SetIcon(self, CanIMogIt:GetTooltipText(itemLink))
end


local function AddToFrame(frame, func)
    -- Create the FontString and set OnUpdate
    if frame then
        frame.CanIMogItIcon = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        frame.CanIMogItIcon:SetPoint("TOPLEFT", 2, -2)
        frame:SetScript("OnUpdate", func)
    end
end


-- Add hook for each bag item.
for i=1,NUM_CONTAINER_FRAMES do
    for j=1,MAX_CONTAINER_ITEMS do
        local frame = _G["ContainerFrame"..i.."Item"..j]
        AddToFrame(frame, ContainerFrame_OnUpdate)
    end
end

-- Add hook for the main bank frame.
for i=1,NUM_BANKGENERIC_SLOTS do
    local frame = _G["BankFrameItem"..i]
    AddToFrame(frame, ContainerFrame_OnUpdate)
end

-- Add hook for the loot frames.
for i=1,NUM_GROUP_LOOT_FRAMES do
    local frame = _G["GroupLootFrame"..i].IconFrame
    AddToFrame(frame, LootFrame_OnUpdate)
end

-- Add hook for the Mail inbox frames.
for i=1,ATTACHMENTS_MAX_SEND do
    local frame = _G["OpenMailAttachmentButton"..i]
    AddToFrame(frame, MailFrame_OnUpdate)
end

-- Add hook for the Merchant frames.
-- 12 is the number of merchant items visible at once.
for i=1,12 do
    local frame = _G["MerchantItem"..i.."ItemButton"]
    AddToFrame(frame, MerchantFrame_OnUpdate)
end
