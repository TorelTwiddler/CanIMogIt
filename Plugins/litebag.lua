-- Adds overlays to LiteBag https://www.curseforge.com/wow/addons/litebag

if C_AddOns.IsAddOnLoaded("LiteBag") then

    LiteBag_RegisterHook('LiteBagItemButton_Update', function (button)
            CIMI_AddToFrame(button, ContainerFrame_CIMIUpdateIcon)
            ContainerFrame_CIMIUpdateIcon(button.CanIMogItOverlay)
        end)

end
