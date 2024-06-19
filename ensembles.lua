function CanIMogIt:IsItemEnsemble(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    if C_Item.GetItemLearnTransmogSet(itemID) then
        return true
    end
    return false
end
CanIMogIt.IsItemEnsemble = CanIMogIt.RetailWrapper(CanIMogIt.IsItemEnsemble, false)


function CanIMogIt:EnsembleItemsKnown(itemLink)
    -- Returns the number of appearances known, and the number of appearances total in the ensemble.
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return 0, 0 end
    local setID = C_Item.GetItemLearnTransmogSet(itemID)
    if setID == nil then return 0, 0 end
    local setAppearances = C_Transmog.GetAllSetAppearancesByID(setID)
    local known = 0
    local total = 0
    -- knownAppearances keys are the "appearanceIDs|armorSubClass" and the values are true if it's known.
    local knownAppearances = {}
    -- totalAppearances keys are the "appearanceIDs|armorSubClass" and the values are always true.
    local totalAppearances = {}
    if setAppearances == nil then return 0, 0 end
    for _, source in ipairs(setAppearances) do
        -- We have to use our custom function for this, since the WoW one doesn't include
        -- checking if items are from the correct armor type.
        local sourceID = source.itemModifiedAppearanceID
        local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
        local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
        local playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmog(sourceItemLink)
        local itemSubClass = "unknown"
        -- If it's armor, get the subclass. If not, it should be fine as unknown.
        if CanIMogIt:IsItemArmor(itemLink) then
            itemSubClass = CanIMogIt:GetItemSubClassName(sourceItemLink) or "unknown"
        end
        local key = appearanceID .. "|" .. itemSubClass
        if playerKnowsTransmog and not knownAppearances[key] then
            knownAppearances[key] = true
            known = known + 1
        end
        if not totalAppearances[key] then
            totalAppearances[key] = true
            total = total + 1
        end
    end
    return known, total
end


function CanIMogIt:CalculateEnsembleText(itemLink)
    -- Displays the standard KNOWN or UNKNOWN, then include the ratio of known to total.
    local known, total = CanIMogIt:EnsembleItemsKnown(itemLink)
    local ratio = known .. "/" .. total
    if total == 0 then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    elseif known == total then
        return CanIMogIt.KNOWN .. " " .. ratio, CanIMogIt.KNOWN
    elseif known > 0 then
        return CanIMogIt.PARTIAL .. " " .. ratio, CanIMogIt.PARTIAL
    elseif known == 0 then
        return CanIMogIt.UNKNOWN .. " " .. ratio, CanIMogIt.UNKNOWN
    end
end
