-- Overlay for vendors.


----------------------------
-- UpdateIcon functions   --
----------------------------


function MerchantFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = self:GetParent().link
    if itemLink == nil then
        CIMI_SetIcon(self, MerchantFrame_CIMIUpdateIcon, nil)
    else
        CIMI_SetIcon(self, MerchantFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


------------------------
-- Function hooks     --
------------------------


function MerchantFrame_CIMIOnClick()
    for i=1,10 do
        local frame = _G["MerchantItem"..i.."ItemButton"]
        if frame then
            MerchantFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


function CanIMogIt.frame:HookItemOverlay(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the Merchant frames.
    -- 10 is the number of merchant items visible at once.
    for i=1,10 do
        local frame = _G["MerchantItem"..i.."ItemButton"]
        if frame then
            CIMI_AddToFrame(frame, MerchantFrame_CIMIUpdateIcon)
        end
    end

    -- Add hook for clicking on the next or previous buttons in the
    -- merchant frames (since there is no event).
    if _G["MerchantNextPageButton"] then
        _G["MerchantNextPageButton"]:HookScript("OnClick", MerchantFrame_CIMIOnClick)
    end
    if _G["MerchantPrevPageButton"] then
        _G["MerchantPrevPageButton"]:HookScript("OnClick", MerchantFrame_CIMIOnClick)
    end
    if _G["MerchantFrame"] then
        _G["MerchantFrame"]:HookScript("OnMouseWheel", MerchantFrame_CIMIOnClick)
    end
end


------------------------
-- Event functions    --
------------------------

CIMIEvents = {
    ["UNIT_INVENTORY_CHANGED"] = true,
    ["PLAYER_SPECIALIZATION_CHANGED"] = true,
    ["BAG_UPDATE"] = true,
    ["BAG_NEW_ITEMS_UPDATED"] = true,
    ["QUEST_ACCEPTED"] = true,
    ["BAG_SLOT_FLAGS_UPDATED"] = true,
    ["BANK_BAG_SLOT_FLAGS_UPDATED"] = true,
    ["PLAYERBANKSLOTS_CHANGED"] = true,
    ["BANKFRAME_OPENED"] = true,
    ["START_LOOT_ROLL"] = true,
    ["MERCHANT_SHOW"] = true,
    ["VOID_STORAGE_OPEN"] = true,
    ["VOID_STORAGE_CONTENTS_UPDATE"] = true,
    ["GUILDBANKBAGSLOTS_CHANGED"] = true,
    ["PLAYERREAGENTBANKSLOTS_CHANGED"] = true,
}

function CanIMogIt.frame:MerchantOverlayEvents(event, ...)
    if not CIMIEvents[event] then return end

    -- merchant frames
    MerchantFrame_CIMIOnClick()

end
