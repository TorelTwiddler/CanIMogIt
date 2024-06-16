function CanIMogIt:IsItemEnsemble(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    if C_Item.GetItemLearnTransmogSet(itemID) then
        return true
    end
    return false
end


function CanIMogIt:EnsembleItemsKnown(itemLink)
    -- Returns the number of appearances known, and the number of appearances total in the ensemble.
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return 0, 0 end
    local setID = C_Item.GetItemLearnTransmogSet(itemID)
    if setID == nil then return 0, 0 end
    local setAppearances = C_Transmog.GetAllSetAppearancesByID(setID)
    local known = 0
    local total = 0
    if setAppearances == nil then return 0, 0 end
    for _, source in ipairs(setAppearances) do
        -- We have to use our custom function for this, since the WoW one doesn't include
        -- checking if items are from the correct armor type.
        local sourceID = source.itemModifiedAppearanceID
        local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
        local playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmog(sourceItemLink)
        if playerKnowsTransmog then
            known = known + 1
        end
        total = total + 1
    end
    return known, total
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
