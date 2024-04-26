function CanIMogIt:IsItemPet(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    if C_PetJournal.GetPetInfoByItemID(itemID) then
        return true
    end
    return false
end

function CanIMogIt:PlayerKnowsPet(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    local speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
    return C_PetJournal.GetNumCollectedInfo(speciesID) > 0
end


function CanIMogIt:CalculatePetText(itemLink)
    -- Calculates if the pet is known or not.
    if not CanIMogItOptions["showPetItems"] then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    end

    local playerKnowsPet = CanIMogIt:PlayerKnowsPet(itemLink)

    if playerKnowsPet then
        return CanIMogIt.KNOWN, CanIMogIt.KNOWN
    else
        return CanIMogIt.UNKNOWN, CanIMogIt.UNKNOWN
    end
end
