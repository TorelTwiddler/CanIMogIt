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

        if not item.currentData then
            if item.slotkey then
                local bagAndSlot = {}
                for value in string.gmatch(item.slotkey, "%d+") do
                    table.insert(bagAndSlot, value)
                end
                CIMI_SetIcon(cimiFrame, function() end, CanIMogIt:GetTooltipText(nil, bagAndSlot[1], bagAndSlot[2]))
            end

            return
        end

        local bag, slot = item.currentData.bagid, item.currentData.slotid
        CIMI_SetIcon(cimiFrame, function () end, CanIMogIt:GetTooltipText(nil, bag, slot))
    end
    events:RegisterMessage('item/Updated', onItemUpdate)

    local function onBagRendered()
        local bags = betterBags.Bags.Backpack
        if not bags.currentView then return end
        local itemList = bags.currentView.itemsByBagAndSlot
        for _, item in pairs(itemList) do
            onItemUpdate(_, item)
        end
    end
    events:RegisterMessage('bag/Rendered', onBagRendered)

    CanIMogIt:RegisterMessage("OptionUpdate", onBagRendered)
end