function CanIMogIt:IsItemEnsemble(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    if C_Item.GetItemLearnTransmogSet(itemID) then
        return true
    end
    return false
end


function CanIMogIt:EnsembleItemsKnown(itemLink)
    -- Returns the number of items known, and the number of items total in the ensemble.
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return 0, 0 end
    local setID = C_Item.GetItemLearnTransmogSet(itemID)
    if setID == nil then return 0, 0 end
    local setInfo = C_TransmogSets.GetSetPrimaryAppearances(setID)
    local known = 0
    local total = 0
    if setInfo then
        for _, appearanceInfo in ipairs(setInfo) do
            total = total + 1
            if appearanceInfo["collected"] then
                known = known + 1
            end
        end
        return known, total
    end
    return 0, 0
end


function CanIMogIt:CalculateEnsembleText(itemLink)
    -- Displays the standard KNOWN or UNKNOWN, then include the ratio of known to total.
    local known, total = CanIMogIt:EnsembleItemsKnown(itemLink)
    local ratio = known .. "/" .. total
    if known == total then
        return CanIMogIt.KNOWN .. " " .. ratio, CanIMogIt.KNOWN
    else
        return CanIMogIt.UNKNOWN .. " " .. ratio, CanIMogIt.UNKNOWN
    end
end
