-- Adds overlays to Bagnon https://mods.curse.com/addons/wow/bagnon

if IsAddOnLoaded("Bagnon") then

    -- Needs a slightly modified version of ContainerFrameItemButton_CIMIUpdateIcon(),
    -- to support cached Bagnon bags (e.g. bank when not at bank or other characters).
    function BagnonItemButton_CIMIUpdateIcon(self)

        if not self or not self:GetParent() or not self:GetParent():GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled() then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end

        local bag, slot = self:GetParent():GetParent():GetID(), self:GetParent():GetID()
        -- need to catch 0, 0 and 100, 0 here because the bank frame doesn't
        -- load everything immediately, so the OnUpdate needs to run until those frames are opened.
        if (bag == 0 and slot == 0) or (bag == 100 and slot == 0) then return end

        -- For cached Bagnon bags, GetContainerItemLink(bag, slot) would not work in GetTooltipText(nil, bag, slot).
        -- Therefore use GetTooltipText(self:GetParent():GetItem()) as fallback.
        if (CanIMogIt:GetTooltipText(nil, bag, slot) == "") then
            CIMI_SetIcon(self, BagnonItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(self:GetParent():GetItem()))
        else
            CIMI_SetIcon(self, BagnonItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
        end

    end

    function CIMI_BagnonUpdate(self)
        CIMI_AddToFrame(self, BagnonItemButton_CIMIUpdateIcon)
        BagnonItemButton_CIMIUpdateIcon(self.CanIMogItOverlay)
    end

    hooksecurefunc(Bagnon.ItemSlot, "Update", CIMI_BagnonUpdate)

end
