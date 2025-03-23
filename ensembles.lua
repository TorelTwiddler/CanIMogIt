local L = CanIMogIt.L

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
    local setSources = C_Transmog.GetAllSetAppearancesByID(setID)
    local knownAppearancesCount = 0
    local totalAppearancesCount = 0
    local knownSourcesCount = 0
    -- knownAppearances keys are the "appearanceIDs|armorSubClass" and the values are true if it's known.
    local knownAppearances = {}
    -- totalAppearances keys are the "appearanceIDs|armorSubClass" and the values are always true.
    local totalAppearances = {}
    if setSources == nil then return 0, 0 end
    for _, source in ipairs(setSources) do
        -- We have to use our custom function for this, since the WoW one doesn't include
        -- checking if items are from the correct armor type.
        local sourceID = source.itemModifiedAppearanceID
        if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
            knownSourcesCount = knownSourcesCount + 1
        end
        local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
        local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
        local playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmogFromItem(sourceItemLink)
            or CanIMogIt:PlayerKnowsTransmog(sourceItemLink)
        local itemSubClass = "unknown"
        -- If it's armor, get the subclass. If not, it should be fine as unknown.
        if CanIMogIt:IsItemArmor(itemLink) then
            itemSubClass = CanIMogIt:GetItemSubClassName(sourceItemLink) or "unknown"
        end
        local key = appearanceID .. "|" .. itemSubClass
        if playerKnowsTransmog and not knownAppearances[key] then
            knownAppearances[key] = true
            knownAppearancesCount = knownAppearancesCount + 1
        end
        if not totalAppearances[key] then
            totalAppearances[key] = true
            totalAppearancesCount = totalAppearancesCount + 1
        end
    end
    return knownAppearancesCount, totalAppearancesCount, knownSourcesCount, #setSources
end


function CanIMogIt:CalculateEnsembleText(itemLink)
    -- Displays the standard KNOWN or UNKNOWN, then include the ratio of known to total.
    if not CanIMogItOptions["showEnsembleItems"] then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    end

    local knownAppearances, totalAppearances, knownSources, totalSources = CanIMogIt:EnsembleItemsKnown(itemLink)
    local ratio = knownAppearances .. "/" .. totalAppearances
    if CanIMogItOptions["showVerboseText"] then
        ratio = ratio .. " (".. L["Sources"] .. ": " .. knownSources .. "/" .. totalSources .. ")"
        if totalAppearances == 0 then
            return CanIMogIt.NOT_TRANSMOGABLE .. " " .. ratio, CanIMogIt.NOT_TRANSMOGABLE
        elseif knownSources == totalSources then
            return CanIMogIt.KNOWN .. " " .. ratio, CanIMogIt.KNOWN
        elseif knownAppearances == totalAppearances and knownSources > 0 then
            return CanIMogIt.KNOWN_FROM_ANOTHER_ITEM .. " " .. ratio, CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
        elseif knownAppearances > 0 then
            return CanIMogIt.PARTIAL .. " " .. ratio, CanIMogIt.PARTIAL
        elseif knownSources == 0 then
            return CanIMogIt.UNKNOWN .. " " .. ratio, CanIMogIt.UNKNOWN
        end
    else
        if totalAppearances == 0 then
            return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
        elseif knownAppearances == totalAppearances then
            return CanIMogIt.KNOWN .. " " .. ratio, CanIMogIt.KNOWN
        elseif knownAppearances > 0 then
            return CanIMogIt.PARTIAL .. " " .. ratio, CanIMogIt.PARTIAL
        elseif knownAppearances == 0 then
            return CanIMogIt.UNKNOWN .. " " .. ratio, CanIMogIt.UNKNOWN
        end
    end
end
