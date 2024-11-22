function CanIMogIt:IsItemPet(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then
        -- Check to see if it's a pet cage.
        if string.find(itemLink, "battlepet:") then
            return true
        end
        return false
    end
    if C_PetJournal.GetPetInfoByItemID(itemID) then
        return true
    end
    return false
end
CanIMogIt.IsItemPet = CanIMogIt.RetailWrapper(CanIMogIt.IsItemPet, false)

function CanIMogIt:PlayerKnowsPet(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    local speciesID
    if itemID ~= nil then
        speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
    else
        _, _, speciesID = string.find(itemLink, "battlepet:(%d+)")
        if speciesID ~= nil then
            speciesID = tonumber(speciesID)
        end
    end
    if speciesID == nil then return false end
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

local function OnPetUpdate(event)
    if event ~= "PET_JOURNAL_LIST_UPDATE" then return end
    CanIMogIt:ResetCache()
end
CanIMogIt.frame:AddSmartEvent(OnPetUpdate, {"PET_JOURNAL_LIST_UPDATE"})
