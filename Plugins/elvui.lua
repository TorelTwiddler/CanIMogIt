-- Adds overlays to the UI Package ElvUI: https://www.tukui.org

if IsAddOnLoaded("ElvUI") then


    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------


    function ElvUI_CIMIUpdateIcon(self)
    print("Start of ElvUI_CIMIUpdateIcon")
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local bag, slot = self:GetParent().bagID, self:GetParent().slotID
        CIMI_SetIcon(self, ElvUI_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
        print("End of ElvUI_CIMIUpdateIcon")
    end


    ----------------------------
    -- Begin adding to frames --
    ----------------------------


    function CIMI_ElvUIAddFrame(self, event, addonName)
    --print("Start of CIMI_ElvUIAddFrame")
        if event ~= "PLAYER_LOGIN" and event ~= "BANKFRAME_OPENED" and not CIMIEvents[event] then return end
        -- Add to frames
        -- Bags
        for i=0,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_ContainerFrameBag"..i.."Slot"..j]
                if frame then
                    CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                end
            end
            --print("End of Bags CIMI_ElvUIAddFrame")
        end
        -- Main Bank
        for i=1,28 do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_BankContainerFrameBag-"..i.."Slot"..j]
                if frame then
                    CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                end
            end
            --print("End of Main Bank CIMI_ElvUIAddFrame")
        end
        -- Bank Bags
        for i=1,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_BankContainerFrameBag"..i.."Slot"..j]
                if frame then
                    CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                end
            end
            --print("End of Bank Bags CIMI_ElvUIAddFrame")
        end
    end

    hooksecurefunc(CanIMogIt.frame, "HookItemOverlay", CIMI_ElvUIAddFrame)


    ------------------------
    -- Event functions    --
    ------------------------


    function CIMI_ElvUIUpdate(self, event, ...)
    print("Start of CIMI_ElvUIUpdate")
        if not CIMIEvents[event] then return end
        -- Update event
        -- Bags
        for i=1,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_ContainerFrameBag"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
            print("End of Bags CIMI_ElvUIUpdate")
        end
        -- Main Bank
        for i=1,28 do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_BankContainerFrameBag-"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
            print("End of Main Bank CIMI_ElvUIUpdate")
        end
        -- Bank Bags
        for i=1,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_BankContainerFrameBag"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
            print("End of Bank Bags CIMI_ElvUIUpdate")
        end
    end

    --CanIMogIt:RegisterMessage("ResetCache", CIMI_ElvUIUpdate)
    
    function CIMI_ElvUIEvents(self, event)
    print("Start CIMI_ElvUIEvents")
        -- Update based on wow events
        if not CIMIEvents[event] then return end
        CIMI_ElvUIUpdate()
        print("End CIMI_ElvUIEvents")
    end
    hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_ElvUIEvents)
end