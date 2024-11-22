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


function CIMI_UpdateMerchantFrame()
    for i=1,MERCHANT_ITEMS_PER_PAGE do
        local frame = _G["MerchantItem"..i.."ItemButton"]
        if frame then
            MerchantFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function HookOverlayMerchant(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the Merchant frames.
    for i=1,MERCHANT_ITEMS_PER_PAGE do
        local frame = _G["MerchantItem"..i.."ItemButton"]
        if frame then
            CIMI_AddToFrame(frame, MerchantFrame_CIMIUpdateIcon)
        end
    end

    -- Add hook for clicking on the next or previous buttons in the
    -- merchant frames (since there is no event).
    if _G["MerchantNextPageButton"] then
        _G["MerchantNextPageButton"]:HookScript("OnClick", CIMI_UpdateMerchantFrame)
    end
    if _G["MerchantPrevPageButton"] then
        _G["MerchantPrevPageButton"]:HookScript("OnClick", CIMI_UpdateMerchantFrame)
    end
    if _G["MerchantFrame"] then
        _G["MerchantFrame"]:HookScript("OnMouseWheel", CIMI_UpdateMerchantFrame)
    end
end

CanIMogIt.frame:AddSmartEvent(HookOverlayMerchant, {"PLAYER_LOGIN"})
CanIMogIt.frame:AddSmartEvent(CIMI_UpdateMerchantFrame, {"MERCHANT_SHOW"})

------------------------
-- Event functions    --
------------------------

CanIMogIt:RegisterMessage("OptionUpdate", CIMI_UpdateMerchantFrame)
CanIMogIt:RegisterMessage("ResetCache", CIMI_UpdateMerchantFrame)
