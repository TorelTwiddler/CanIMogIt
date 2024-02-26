
if C_AddOns.IsAddOnLoaded("BetterBags") then

    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------

    function BetterBagsItemButton_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local slot, bag = self:GetParent():GetSlotAndBagID()
        CIMI_SetIcon(self, BetterBagsItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end

    ----------------------------
    -- Begin adding to frames --
    ----------------------------

    function CIMI_BetterBagsAddFrame(event, addonName)
        if event ~= "PLAYER_LOGIN" and event ~= "BANKFRAME_OPENED" and not CIMIEvents[event] then return end
        -- Add to frames
        for i=1,600 do
            local frame = _G["BetterBagsItemButton"..i]
            if frame then
                C_Timer.After(.5, function() CIMI_AddToFrame(frame, BetterBagsItemButton_CIMIUpdateIcon) end)
            end
        end
    end
    CanIMogIt.frame:AddEventFunction(CIMI_BetterBagsAddFrame)

    ----------------------------
    -- Event functions        --
    ----------------------------

    function CIMI_BetterBagsEvents(self, event, ...)
        if not CIMIEvents[event] then return end
        -- Update event
        for i=1,600 do
            local frame = _G["BetterBagsItemButton"..i]
            if frame then
                C_Timer.After(.5, function() BetterBagsItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
            end
        end
    end
    hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_BetterBagsEvents)

end