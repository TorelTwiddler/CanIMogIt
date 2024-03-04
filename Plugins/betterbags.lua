-- Adds overlays to items in the addon BetterBags: https://www.curseforge.com/wow/addons/better-bags

if C_AddOns.IsAddOnLoaded("BetterBags") then

    local betterBags = LibStub("AceAddon-3.0"):GetAddon("BetterBags")
    local events = betterBags:GetModule("Events")

    local function onItemUpdate(_, item)
        local cimiFrame = item.button.CanIMogItOverlay
        if not cimiFrame then
            if item.button.frame then
                CIMI_AddToFrame(item.button.frame, function () end)
            else
                CIMI_AddToFrame(item.button, function () end)
            end
        end
        if not cimiFrame then return end
        if not CIMI_CheckOverlayIconEnabled() then
            cimiFrame.CIMIIconTexture:SetShown(false)
            cimiFrame:SetScript("OnUpdate", nil)
            return
        end
        local slot, bag = item.data.slotid, item.data.bagid
        CIMI_SetIcon(cimiFrame, function () end, CanIMogIt:GetTooltipText(nil, bag, slot))
    end
    events:RegisterMessage('item/Updated', onItemUpdate)

    local function onBagsOpenClose()
        local bags = betterBags.Bags.Backpack
        if not bags.currentView then return end
        local itemList = bags.currentView.itemsByBagAndSlot
        for _, item in pairs(itemList) do
            onItemUpdate(_, item)
        end
    end
    events:RegisterMessage('bags/OpenClose', onBagsOpenClose)

    CanIMogIt:Print('BetterBags integration enabled.')
end