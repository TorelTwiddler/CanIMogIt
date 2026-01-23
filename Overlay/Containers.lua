-- Overlay for player bags, bank, and guild banks.


----------------------------
-- UpdateIcon functions   --
----------------------------


local function GetBagAndSlot(frame)
    local bag, slot
    if frame:GetParent():GetParent() then
        bag = frame:GetParent():GetParent():GetID()
        slot = frame:GetParent():GetID()
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
        CIMI_SetIcon(cimiFrame, ContainerFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end)
end


function ContainerFrameItemButton_CIMIToggleBag(...)
    CanIMogIt.eventFrame:ItemOverlayEvents("BAG_UPDATE")
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

local function HookOverlayContainers(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for each bag item.
    for i=1,NUM_CONTAINER_FRAMES do
        for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
            local frame = _G["ContainerFrame"..i.."Item"..j]
            if frame then
                CIMI_AddToFrame(frame, ContainerFrame_CIMIUpdateIcon)
            end
        end
    end

    -- Add hook for the main bank frame.
    for i=1,NUM_BANKGENERIC_SLOTS do
        local frame = _G["BankFrameItem"..i]
        if frame then
            CIMI_AddToFrame(frame, ContainerFrame_CIMIUpdateIcon)
        end
    end
end
CanIMogIt.eventFrame:AddSmartEvent(HookOverlayContainers, {"PLAYER_LOGIN"})

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
    for i=1,NUM_CONTAINER_FRAMES do
        for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
            local frame = _G["ContainerFrame"..i.."Item"..j]
            if frame then
                ContainerFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
            end
        end
    end

    -- main bank frame
    for i=1,NUM_BANKGENERIC_SLOTS do
        local frame = _G["BankFrameItem"..i]
        if frame then
            C_Timer.After(0, function() ContainerFrame_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
        end
    end
end

hooksecurefunc("ToggleBag", UpdateContainerFrames)
hooksecurefunc("OpenAllBags", UpdateContainerFrames)
hooksecurefunc("CloseAllBags", UpdateContainerFrames)
hooksecurefunc("ToggleAllBags", UpdateContainerFrames)

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


CanIMogIt.eventFrame:AddSmartEvent(OnContainerFramesEvent, containerFrameEvents)
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

CanIMogIt.eventFrame:AddSmartEvent(OnGuildBankLoaded, {"ADDON_LOADED"})

local function OnGuildBankUpdate(event, ...)
    if event == "GUILDBANKBAGSLOTS_CHANGED" then
        UpdateGuildBank()
    end
end

CanIMogIt.eventFrame:AddSmartEvent(OnGuildBankUpdate, {"GUILDBANKBAGSLOTS_CHANGED"})
CanIMogIt:RegisterMessage("OptionUpdate", UpdateGuildBank)
