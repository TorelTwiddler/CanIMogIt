-- Overlay for vendors.


-- Cached merchant item button frames
local buttons = {}


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

function MerchantFrame_CIMIUpdateBuybackIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    CIMI_SetIcon(self, MerchantFrame_CIMIUpdateBuybackIcon, nil)
end


------------------------
-- Function hooks     --
------------------------


function CIMI_UpdateMerchantFrame()
    for _, button in ipairs(buttons) do
        MerchantFrame_CIMIUpdateIcon(button.CanIMogItOverlay)
    end
end

function CIMI_UpdateBuybackFrame()
    for _, button in ipairs(buttons) do
        MerchantFrame_CIMIUpdateBuybackIcon(button.CanIMogItOverlay)
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function HookOverlayMerchant(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the button frames and cache those buttons locally
    if not next(buttons) then
        for i=1,MERCHANT_ITEMS_PER_PAGE do
            local frame = _G["MerchantItem"..i.."ItemButton"]
            if frame then
                buttons[i] = frame
                CIMI_AddToFrame(frame, MerchantFrame_CIMIUpdateIcon)
            end
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
    
    -- Add hook for clicking on the Merchant/Buyback tabs
    if _G["MerchantFrameTab1"] then
        _G["MerchantFrameTab1"]:HookScript("OnClick", CIMI_UpdateMerchantFrame)
    end
    if _G["MerchantFrameTab2"] then
        _G["MerchantFrameTab2"]:HookScript("OnClick", CIMI_UpdateBuybackFrame)
    end
end

CanIMogIt.eventFrame:AddSmartEvent(HookOverlayMerchant, {"PLAYER_LOGIN"})
CanIMogIt.eventFrame:AddSmartEvent(CIMI_UpdateMerchantFrame, {"MERCHANT_SHOW"})

------------------------
-- Event functions    --
------------------------

CanIMogIt:RegisterMessage("OptionUpdate", CIMI_UpdateMerchantFrame)
CanIMogIt:RegisterMessage("ResetCache", CIMI_UpdateMerchantFrame)
