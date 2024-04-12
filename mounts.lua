function CanIMogIt:IsItemMount(itemLink)
    if C_MountJournal.GetMountFromItem(CanIMogIt:GetItemID(itemLink)) then
        return true
    end
    return false
end


function CanIMogIt:PlayerKnowsMount(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    local mountID = C_MountJournal.GetMountFromItem(itemID)
    local playerKnowsMount = select(11, C_MountJournal.GetMountInfoByID(mountID))
    return playerKnowsMount
end


function CanIMogIt:CalculateMountText(itemLink)
    -- Calculates if the mount is known or not.
    if not CanIMogItOptions["showMountItems"] then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    end

    local playerKnowsMount = CanIMogIt:PlayerKnowsMount(itemLink)

    if playerKnowsMount then
        return CanIMogIt.KNOWN, CanIMogIt.KNOWN
    else
        return CanIMogIt.UNKNOWN, CanIMogIt.UNKNOWN
    end
end

