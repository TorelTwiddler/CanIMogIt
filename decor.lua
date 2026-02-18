-- TODO: add support for showing owned decor quantity (e.g. 2 in storage / 1 in house)

function CanIMogIt:IsItemDecor(itemLink)
    local catalogEntryInfo = C_HousingCatalog.GetCatalogEntryInfoByItem(itemLink, false)
    if catalogEntryInfo and catalogEntryInfo.entryID and catalogEntryInfo.entryID.entryType == 1 then
        return true
    end
    return false
end

function CanIMogIt:PlayerOwnsDecor(itemLink)
    local catalogEntryInfo = C_HousingCatalog.GetCatalogEntryInfoByItem(itemLink, true)
    return catalogEntryInfo.quantity > 0
end


function CanIMogIt:CalculateDecorText(itemLink)
    -- Calculates if player owns decor
    if not CanIMogItOptions["showDecorItems"] then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    end

    local playerOwnsDecor = CanIMogIt:PlayerOwnsDecor(itemLink)

    if playerOwnsDecor then
        return CanIMogIt.KNOWN, CanIMogIt.KNOWN
    else
        return CanIMogIt.UNKNOWN, CanIMogIt.UNKNOWN
    end
end

-- Init catalog searcher when Blizzard's housing catalog cache gets reset (GARRISON_HIDE_LANDING_PAGE is the best timed approximation I could find)
-- Storage quantity lookup functionality stops when that cache reset happens (very often btw, e.g. every time a player swaps zones), so this is a necessicity unfortunately
local function InitDecor()
    if not CanIMogItOptions["showDecorItems"] then return end
    C_HousingCatalog.CreateCatalogSearcher()
end
CanIMogIt.eventFrame:AddSmartEvent(InitDecor, {"GARRISON_HIDE_LANDING_PAGE"})


local function OnLearnedDecor()
    CanIMogIt:ResetCache()
end
CanIMogIt.eventFrame:AddSmartEvent(OnLearnedDecor, {"HOUSE_DECOR_ADDED_TO_CHEST"})