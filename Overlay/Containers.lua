-- Overlay for player bags, bank, and guild banks.


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


function WarbankFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local bag, slot = self:GetParent().bankTabID, self:GetParent().containerSlotID
    local itemLink = C_Container.GetContainerItemLink(bag, slot)
    CIMI_SetIcon(self, WarbankFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
end


function ContainerFrameItemButton_CIMIToggleBag(...)
    CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
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


local function UpdateContainerFrames()
    -- TODO: Need to call this when USE_COMBINED_BAGS_CHANGED is fired.
    -- USE_COMBINED_BAGS_CHANGED
    local cimiFrame

    -- Combined bags frame
    local combinedBags = _G["ContainerFrameCombinedBags"]
    for i, frame in ipairs(combinedBags.Items) do
        cimiFrame = frame.CanIMogItOverlay
        if not cimiFrame then
            cimiFrame = AddToContainerFrame(frame)
        end
        ContainerFrame_CIMIUpdateIcon(cimiFrame)
    end

    -- Separate bags frame
    local frameContainer = _G["ContainerFrameContainer"]
    for i, bag in ipairs(frameContainer.ContainerFrames) do
        for j, frame in ipairs(bag.Items) do
            cimiFrame = frame.CanIMogItOverlay
            if not cimiFrame then
                cimiFrame = AddToContainerFrame(frame)
            end
            ContainerFrame_CIMIUpdateIcon(cimiFrame)
        end
    end

    -- Warbank frame
    for i=1,CanIMogIt.NUM_WARBANK_ITEMS do
        local accountBankPanel = _G["AccountBankPanel"]
        if accountBankPanel == nil then
            return
        end
        local frame = accountBankPanel:FindItemButtonByContainerSlotID(i)
        if frame then
            cimiFrame = frame.CanIMogItOverlay
            if not cimiFrame then
                cimiFrame = AddToContainerFrame(frame)
            end
            WarbankFrame_CIMIUpdateIcon(cimiFrame)
        end
    end
end

hooksecurefunc("ToggleBag", UpdateContainerFrames)
hooksecurefunc("OpenAllBags", UpdateContainerFrames)
hooksecurefunc("CloseAllBags", UpdateContainerFrames)
hooksecurefunc("ToggleAllBags", UpdateContainerFrames)

-- local accountBankPanel = _G["AccountBankPanel"]
-- hooksecurefunc(accountBankPanel, "RefreshBankPanel", function () C_Timer.After(.1, UpdateContainerFrames) end)

local containerFrameEvents = {
    "BAG_UPDATE",
    "BANKFRAME_OPENED",
    "PLAYERBANKSLOTS_CHANGED",
    "TRANSMOG_COLLECTION_UPDATED",
}

local function OnContainerFramesEvent(event)
    for i, cEvent in ipairs(containerFrameEvents) do
        if event == cEvent then
            UpdateContainerFrames()
            return
        end
    end
end


CanIMogIt.frame:AddSmartEvent(OnContainerFramesEvent, containerFrameEvents)
CanIMogIt:RegisterMessage("OptionUpdate", UpdateContainerFrames)


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

CanIMogIt.frame:AddSmartEvent(OnGuildBankLoaded, {"ADDON_LOADED"})

local function OnGuildBankUpdate(event, ...)
    if event == "GUILDBANKBAGSLOTS_CHANGED" then
        UpdateGuildBank()
    end
end

CanIMogIt.frame:AddSmartEvent(OnGuildBankUpdate, {"GUILDBANKBAGSLOTS_CHANGED"})
CanIMogIt:RegisterMessage("OptionUpdate", UpdateGuildBank)
