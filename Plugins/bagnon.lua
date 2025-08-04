-- Adds overlays to Bagnon https://mods.curse.com/addons/wow/bagnon

if C_AddOns.IsAddOnLoaded("Bagnon") then

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

        -- For cached Bagnon bags, GetContainerItemLink(bag, slot) would not work in CanIMogIt:GetTooltipText(nil, bag, slot).
        -- Therefore provide GetTooltipText() with itemLink when available.
        -- If the itemLink isn't available, then try with the bag/slot as backup (fixes battle pets).
        local itemLink = self:GetParent():GetItem()
        if not itemLink then
            -- This may be guild bank
            itemLink = self:GetParent():GetInfo().link
        end
        local cached = self:GetParent().info.cached
        -- Need to prevent guild bank items from using bag/slot from Bagnon,
        -- since they don't match Blizzard's frames.
        if itemLink or cached or self:GetParent().__name == "BagnonGuildItem" then
            CIMI_SetIcon(self, BagnonItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
        else
            CIMI_SetIcon(self, BagnonItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
        end
    end

    function CIMI_BagnonUpdate(self)
        CIMI_AddToFrame(self, BagnonItemButton_CIMIUpdateIcon)
        BagnonItemButton_CIMIUpdateIcon(self.CanIMogItOverlay)
    end

    hooksecurefunc(Bagnon.Item, "Update", CIMI_BagnonUpdate)
    CanIMogIt:RegisterMessage("ResetCache", function () Bagnon.Frames:Update() end)

end
