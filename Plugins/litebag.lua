-- Adds overlays to LiteBag https://mods.curse.com/addons/wow/litebag

local _, P = ...;
P:RegisterAddOnCallback("LiteBag", function()

    LiteBag_RegisterHook('LiteBagItemButton_Update', function (button)
            CIMI_AddToFrame(button, ContainerFrameItemButton_CIMIUpdateIcon)
            ContainerFrameItemButton_CIMIUpdateIcon(button.CanIMogItOverlay)
        end)

end);
