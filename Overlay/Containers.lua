-- Overlay for player bags, bank, and guild banks.


local containerFrameContainer = nil
local combinedBagsContainerFrame = nil
local bankFramePanel = nil

local useCombinedBags = false


----------------------------
-- UpdateIcon functions   --
----------------------------


function DebugPrintFullName(frame)
    -- If the frame has a parent, call DebugPrintFullName on the parent.
    local name = ""
    if frame:GetParent() then
        name = DebugPrintFullName(frame:GetParent())
    end
    -- If the frame has a name or ID, print it.
    name = name .. "."
    if frame.GetName and frame:GetName() then
        name = name .. frame:GetName()
    elseif frame.GetID and frame:GetID() then
        name = name .. frame:GetID()
    else
        name = name .. "Unknown"
    end
    return name
end

local function GetBagAndSlot(frame)
    local bag, slot
    if frame:GetParent():GetParent() then
        slot, bag = frame:GetParent():GetSlotAndBagID()
    end
    return bag, slot
end


function ContainerFrame_CIMIUpdateIcon(cimiFrame)
    if not cimiFrame or not cimiFrame:GetParent() or not cimiFrame:GetParent():GetParent() then return end
    if not CIMI_CheckOverlayIconEnabled() then
        cimiFrame.CIMIIconTexture:SetShown(false)
        cimiFrame:SetScript("OnUpdate", nil)
        return
    end

    C_Timer.After(0, function()
        local bag, slot = GetBagAndSlot(cimiFrame)
        local itemLink = C_Container.GetContainerItemLink(bag, slot)
        CIMI_SetIcon(cimiFrame, ContainerFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
    end)
end


function BankFrame_CIMIUpdateIcon(self)
    -- Works for both Bank and Warbank frames.
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local bag, slot = self:GetParent().bankTabID, self:GetParent().containerSlotID
    local itemLink = C_Container.GetContainerItemLink(bag, slot)
    CIMI_SetIcon(self, BankFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
end


function GuildBankFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local tab = GetCurrentGuildBankTab()
    local slot = self:GetParent():GetID()
    local itemLink = GetGuildBankItemLink(tab, slot)
    CIMI_SetIcon(self, GuildBankFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------

local function GetNameOrID(frame)
    if frame.GetName and frame:GetName() then
        return frame:GetName()
    elseif frame.GetID and frame:GetID() then
        return frame:GetID()
    end
end


local function AddToContainerFrame(frame)
    local suffix = GetNameOrID(frame:GetParent()) .. "." .. GetNameOrID(frame)
    return CIMI_AddToFrame(frame, ContainerFrame_CIMIUpdateIcon, suffix)
end

local function UpdateCombinedBags()
    local cimiFrame
    for _, frame in ipairs(combinedBagsContainerFrame.Items) do
        cimiFrame = frame.CanIMogItOverlay
        if not cimiFrame then
            cimiFrame = AddToContainerFrame(frame)
        end
        ContainerFrame_CIMIUpdateIcon(cimiFrame)
    end
end

local function UpdateBags()
    local cimiFrame
    for _, bag in ipairs(containerFrameContainer.ContainerFrames) do
        if bag:IsVisible() then
            for _, frame in ipairs(bag.Items) do
                cimiFrame = frame.CanIMogItOverlay
                if not cimiFrame then
                    cimiFrame = AddToContainerFrame(frame)
                end
                ContainerFrame_CIMIUpdateIcon(cimiFrame)
            end
        end
    end
end

local function UpdateBank()
    local cimiFrame
    for i=1, CanIMogIt.NUM_BANK_ITEMS do
        local frame = bankFramePanel:FindItemButtonByContainerSlotID(i)
        if frame then
            cimiFrame = frame.CanIMogItOverlay
            if not cimiFrame then
                cimiFrame = AddToContainerFrame(frame)
            end
            BankFrame_CIMIUpdateIcon(cimiFrame)
        end
    end
end

local function UpdateContainerFrames(event, elapsed)
    if useCombinedBags then
        -- Combined bags frame
        if combinedBagsContainerFrame == nil then combinedBagsContainerFrame = _G["ContainerFrameCombinedBags"] end
        if combinedBagsContainerFrame:IsVisible() then UpdateCombinedBags() end
    else
        -- Separate bags frame
        if containerFrameContainer == nil then containerFrameContainer = _G["ContainerFrameContainer"] end
        if containerFrameContainer:IsVisible() then UpdateBags() end
    end

    -- Bank and Warbank frames (they are the same frames)
    if bankFramePanel == nil then bankFramePanel = _G["BankFrame"].BankPanel end
    if bankFramePanel:IsVisible() then UpdateBank() end
end

hooksecurefunc("ToggleBag", UpdateContainerFrames)
hooksecurefunc("OpenAllBags", UpdateContainerFrames)
hooksecurefunc("CloseAllBags", UpdateContainerFrames)
hooksecurefunc("ToggleAllBags", UpdateContainerFrames)
-- Works for both Bank and Warbank tabs.
hooksecurefunc(_G["BankFrame"].BankPanel, "SelectTab", UpdateContainerFrames)


local containerFrameEvents = {
    "BAG_UPDATE",
    "BANKFRAME_OPENED",
    "PLAYERBANKSLOTS_CHANGED",
    "TRANSMOG_COLLECTION_UPDATED",
}

local function OnContainerFramesEvent(event)
    for _, cEvent in ipairs(containerFrameEvents) do
        if event == cEvent then
            UpdateContainerFrames()
            return
        end
    end
end
CanIMogIt.eventFrame:AddSmartEvent(OnContainerFramesEvent, containerFrameEvents)
CanIMogIt:RegisterMessage("OptionUpdate", UpdateContainerFrames)


-- Register change of combined bags setting
local function UseCombinedBagsChanged(event, value)
    useCombinedBags = value
end
EventRegistry:RegisterFrameEventAndCallback("USE_COMBINED_BAGS_CHANGED", UseCombinedBagsChanged)


-- Get initial combinedBags CVar value
local function InitCombinedBagsValue(event, addonName)
    if event == "ADDON_LOADED" and addonName == "CanIMogIt" then
        local cvar = GetCVar("combinedBags")
        useCombinedBags = cvar == "1" and true or false
    end
end
CanIMogIt.eventFrame:AddSmartEvent(InitCombinedBagsValue, {"ADDON_LOADED"})


-- Guild bank
local function UpdateGuildBank()
    local guildBankFrame = _G["GuildBankFrame"]
    if guildBankFrame then
        for column = 1, #guildBankFrame.Columns do
            for button = 1, #guildBankFrame.Columns[column].Buttons do
                local frame = guildBankFrame.Columns[column].Buttons[button]
                if frame then
                    if not frame.CanIMogItOverlay then
                        CIMI_AddToFrame(frame, GuildBankFrame_CIMIUpdateIcon)
                    end
                    C_Timer.After(.1, function () GuildBankFrame_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                end
            end
        end
    end
end

local function OnGuildBankLoaded(event, addonName, ...)
    if event == "ADDON_LOADED" and addonName == "Blizzard_GuildBankUI" then
        UpdateGuildBank()
    end
end

CanIMogIt.eventFrame:AddSmartEvent(OnGuildBankLoaded, {"ADDON_LOADED"})

local function OnGuildBankUpdate(event, ...)
    if event == "GUILDBANKBAGSLOTS_CHANGED" then
        UpdateGuildBank()
    end
end

CanIMogIt.eventFrame:AddSmartEvent(OnGuildBankUpdate, {"GUILDBANKBAGSLOTS_CHANGED"})
CanIMogIt:RegisterMessage("OptionUpdate", UpdateGuildBank)
