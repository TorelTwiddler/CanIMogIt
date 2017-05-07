if IsAddOnLoaded("ArkInventory") then
    function ArkInventoryItemButton_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local bag = self:GetParent():GetParent():GetID()
        local slot = self:GetParent():GetID()
        CIMI_SetIcon(self, ArkInventoryItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end

    function ArkInventoryGuildBank_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local tab = GetCurrentGuildBankTab()
        local slot = self:GetParent():GetID()
        local itemLink = GetGuildBankItemLink(tab, slot)
        CIMI_SetIcon(self, ArkInventoryGuildBank_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end

    function CIMI_ArkInventoryAddFrame(self, event)
        if event == "PLAYER_LOGIN" or event == "BANKFRAME_OPENED" or event == "GUILDBANKFRAME_OPENED" then
            -- Add to frames
            -- Bags
            for i=1,NUM_CONTAINER_FRAMES do
                for j=1,MAX_CONTAINER_ITEMS do
                    local frame = _G["ARKINV_Frame1ScrollContainerBag"..i.."Item"..j]
                    if frame then
                        CIMI_AddToFrame(frame, ArkInventoryItemButton_CIMIUpdateIcon)
                    end
                end
            end
            -- Bank
            for i=1,12 do
                for j=1,200 do
                    local frame = _G["ARKINV_Frame3ScrollContainerBag"..i.."Item"..j]
                    if frame then
                        CIMI_AddToFrame(frame, ArkInventoryItemButton_CIMIUpdateIcon)
                    end
                end
            end
            -- Guild Bank
            C_Timer.After(.5, CIMI_ArkInventoryAddGuildBankFrame)
        end
    end
    hooksecurefunc(CanIMogIt.frame, "HookItemOverlay", CIMI_ArkInventoryAddFrame)

    function CIMI_ArkInventoryAddGuildBankFrame()
        for i=1,12 do
            for j=1,200 do
                local frame = _G["ARKINV_Frame4ScrollContainerBag"..i.."Item"..j]
                if frame then
                    CIMI_AddToFrame(frame, ArkInventoryGuildBank_CIMIUpdateIcon)
                end
            end
        end
    end

    function CIMI_ArkInventoryUpdate()
        -- Make sure all CIMI frames exist
        CIMI_ArkInventoryAddFrame(nil, "BANKFRAME_OPENED")
        -- Bags
        for i=1,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ARKINV_Frame1ScrollContainerBag"..i.."Item"..j]
                if frame then
                    ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
        -- Player Bank
        for i=1,12 do
            for j=1,200 do
                local frame = _G["ARKINV_Frame3ScrollContainerBag"..i.."Item"..j]
                if frame then
                    ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
        -- Guild Bank
        for i=1,12 do
            for j=1,200 do
                local frame = _G["ARKINV_Frame4ScrollContainerBag"..i.."Item"..j]
                if frame then
                    -- The guild bank frame does extra stuff after the CIMI icon shows up,
                    -- so need to add a slight delay.
                    C_Timer.After(.1, function() ArkInventoryGuildBank_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                end
            end
        end
    end

    ArkInventory:RegisterMessage("EVENT_ARKINV_BAG_UPDATE_BUCKET", CIMI_ArkInventoryUpdate)
    ArkInventory:RegisterMessage("EVENT_ARKINV_VAULT_UPDATE_BUCKET", CIMI_ArkInventoryUpdate)
    CanIMogIt:RegisterMessage("ResetCache", CIMI_ArkInventoryUpdate)
    -- Makes sure things are updated if bags are open quickly after logging in. Won't always work, but better than nothing.
    C_Timer.After(10, function() CanIMogIt:ResetCache() end)
end
