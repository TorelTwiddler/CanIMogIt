function CanIMogIt:IsItemToy(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    if C_ToyBox.GetToyInfo(itemID) then
        return true
    end
    return false
end

function CanIMogIt:PlayerKnowsToy(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    return PlayerHasToy(itemID)
end


function CanIMogIt:CalculateToyText(itemLink)
    -- Calculates if the toy is known or not.
    if not CanIMogItOptions["showToyItems"] then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    end

    local playerKnowsToy = CanIMogIt:PlayerKnowsToy(itemLink)

    if playerKnowsToy then
        return CanIMogIt.KNOWN, CanIMogIt.KNOWN
    else
        return CanIMogIt.UNKNOWN, CanIMogIt.UNKNOWN
    end
end


local function OnLearnedToy(event)
    if event ~= "NEW_TOY_ADDED" then return end
    CanIMogIt:ResetCache()
end
CanIMogIt.frame:AddSmartEvent(OnLearnedToy, {"NEW_TOY_ADDED"})
