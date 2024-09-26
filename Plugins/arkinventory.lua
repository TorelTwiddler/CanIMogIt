-- Adds overlays to items in the addon ArkInventory: https://mods.curse.com/addons/wow/ark-inventory

local function AddArkInventoryHooks()
    local ArkInventory = _G["ArkInventory"]

    --    3.08.21 or higher

    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------


    function ArkInventoryItemButton_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        local frame = self:GetParent()
        if not frame.ARK_Data then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local itemLink = nil
        local bag = frame.ARK_Data.blizzard_id
        local slot = frame.ARK_Data.slot_id
        if ArkInventory.API.LocationIsOffline( loc_id ) or not ( loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank ) then
            local i = ArkInventory.API.ItemFrameItemTableGet( frame )
            if i and i.h then
                itemLink = i.h
            end
            -- use the itemlink for offline locations or any that are not the bag or bank
            bag = nil
            slot = nil
        end
        CIMI_SetIcon(self, ArkInventoryItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
    end


    ----------------------------
    -- Begin adding to frames --
    ----------------------------


    function CIMI_ArkInventoryAddFrame(frame,loc_id)
        -- Add to item frame
        -- Added a C_Timer, since CanIMogItOptions aren't loaded yet.
        C_Timer.After(.1, function() CIMI_AddToFrame(frame, ArkInventoryItemButton_CIMIUpdateIcon) end)
    end

    hooksecurefunc( ArkInventory.API, "ItemFrameLoaded", CIMI_ArkInventoryAddFrame )

    -- add to any preloaded item frames
    for framename, frame in ArkInventory.API.ItemFrameLoadedIterate( ) do
        CIMI_ArkInventoryAddFrame(frame)
    end


    ------------------------
    -- Event functions    --
    ------------------------


    function CIMI_ArkInventoryUpdate()
        for framename, frame, loc_id in ArkInventory.API.ItemFrameLoadedIterate( ) do
            if loc_id == ArkInventory.Const.Location.Bank then
                C_Timer.After(.1, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
            elseif loc_id == ArkInventory.Const.Location.Vault then
                -- The guild bank frame does extra stuff after the CIMI icon shows up, so need to add a slight delay.
                C_Timer.After(.2, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
            else
                ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
            end
        end
    end

    function CIMI_ArkInventoryUpdateSingle(frame)
        ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
    end

    hooksecurefunc( ArkInventory.API, "ItemFrameUpdated", CIMI_ArkInventoryUpdateSingle )

    CanIMogIt:RegisterMessage("ResetCache", CIMI_ArkInventoryUpdate)

    function CIMI_ArkInventoryEvents(self, event)
        -- Update based on wow events
        if not CanIMogIt.Events[event] then return end
        CIMI_ArkInventoryUpdate()
    end
    hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_ArkInventoryEvents)
end


local _, _, _, loadable, _ = C_AddOns.GetAddOnInfo("ArkInventory")

if loadable then

    local _, loaded = C_AddOns.IsAddOnLoaded("ArkInventory")
    if loaded then
        AddArkInventoryHooks()
    else
        CanIMogIt.frame:RegisterEvent("ADDON_LOADED")
        CanIMogIt.frame:SetScript("OnEvent", function(self, event, loadedAddon)
            if event == "ADDON_LOADED" and loadedAddon == "ArkInventory" then
                CanIMogIt.frame:UnregisterEvent("ADDON_LOADED")
                AddArkInventoryHooks()
            end
        end)
    end
end
