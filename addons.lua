-- This file contains code for working with specific addons.


if IsAddOnLoaded("AdiBags") then
    function AdiBagsItemButton_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local bag, slot = self:GetParent().bag, self:GetParent().slot
        -- need to catch 0, 0 and 100, 0 here because the bank frame doesn't
        -- load everything immediately, so the OnUpdate needs to run until those frames are opened.
        if (bag == 0 and slot == 0) or (bag == 100 and slot == 0) then return end
        CIMI_SetIcon(self, AdiBagsItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end

    function CIMI_AdiBagsAddFrame(self, event, addonName)
        if event ~= "PLAYER_LOGIN" and addonName ~= "CanIMogIt" then return end
        -- Add to frames
        for i=1,160 do
            local frame = _G["AdiBagsItemButton"..i]
            if frame then
                CIMI_AddToFrame(frame, AdiBagsItemButton_CIMIUpdateIcon)
            end
        end
    end
    hooksecurefunc(CanIMogIt.frame, "HookItemOverlay", CIMI_AdiBagsAddFrame)

    function CIMI_AdiBagsEvents(self, event, ...)
        if not CIMIEvents[event] then return end
        -- Update event
        for i=1,160 do
            local frame = _G["AdiBagsItemButton"..i]
            if frame then
                C_Timer.After(.5, function() AdiBagsItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
            end
        end
    end
    hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_AdiBagsEvents)

    C_Timer.After(10, function() CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE") end)
end
