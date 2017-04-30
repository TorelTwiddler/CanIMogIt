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

    function CIMI_ArkInventoryEvents(self, event, ...)
        if not CIMIEvents[event] then return end
        -- Update event
        CIMI_ArkInventoryUpdate() 
    end
    hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_ArkInventoryEvents)

    function CIMI_ArkInventoryUpdate()
        for i=1,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ARKINV_Frame1ScrollContainerBag"..i.."Item"..j]
                if frame then
                    C_Timer.After(.5, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                end
            end
        end
        for i=1,12 do
            for j=1,200 do
                local frame = _G["ARKINV_Frame3ScrollContainerBag"..i.."Item"..j]
                if frame then
                    C_Timer.After(.5, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                end
            end
        end
        for i=1,12 do
            for j=1,200 do
                local frame = _G["ARKINV_Frame4ScrollContainerBag"..i.."Item"..j]
                if frame then
                    C_Timer.After(.5, function() ArkInventoryGuildBank_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                end
            end
        end
    end

    C_Timer.After(5, CIMI_ArkInventoryUpdate)
end
