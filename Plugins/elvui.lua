-- Adds overlays to the UI Package ElvUI: https://www.tukui.org

if C_AddOns.IsAddOnLoaded("ElvUI") then


    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------

    function ElvUI_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local slot, bag = self:GetParent():GetSlotAndBagID()
        CIMI_SetIcon(self, ElvUI_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end

    ----------------------------
    -- Begin adding to frames --
    ----------------------------

    function CIMI_ElvUIAddFrame(event)
        if event ~= "PLAYER_LOGIN" and event ~= "BANKFRAME_OPENED" and not CanIMogIt.Events[event] then return end
        -- Add to frames
        -- Bags
        for i=0,NUM_CONTAINER_FRAMES do
            for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_ContainerFrameBag"..i.."Slot"..j]
                if frame then
                    CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                end
            end
        end

        local function AddToBankFrames()
            -- This is a separate function, so that we can add a delay before these are added.
        end

        -- The ElvUI bank frames don't exist when the BANKFRAME_OPENED event occurs,
        -- so need to wait a moment first.
        C_Timer.After(.5, function() AddToBankFrames() end)

    end

    CanIMogIt.frame:AddSmartEvent(CIMI_ElvUIAddFrame, {"PLAYER_LOGIN", "BANKFRAME_OPENED"})

    ------------------------
    -- Event functions    --
    ------------------------

    function CIMI_ElvUIUpdate()
        -- Update event
        -- Bags
        for i=0,NUM_CONTAINER_FRAMES do
            for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_ContainerFrameBag"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
    end

    function CIMI_ElvUIEvents(event)
        -- Update based on wow events
        if not CanIMogIt.Events[event] then return end
        CIMI_ElvUIUpdate()
    end
    CanIMogIt.frame:AddSmartEvent(CIMI_ElvUIEvents, CanIMogIt.EventsList)
end
