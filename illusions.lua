local L = CanIMogIt.L

-- all 52 items are from https://www.wowhead.com/items/consumables/name:illusion
-- all 88 illusions are from https://wago.tools/db2/TransmogIllusion
-- illusion names are from https://wago.tools/db2/SpellItemEnchantment
local ItemToIllusion = {
    [118572] = {5394}, -- Flames of Ragnaros
    [120286] = {5396}, -- Glorious Tyranny
    [120287] = {5397}, -- Primal Victory
    [128649] = {5448}, -- Winter's Grasp
    [138796] = {3225}, -- Executioner
    [138797] = {2673}, -- Mongoose
    [138798] = {5865}, -- Sunfire
    [138799] = {5866}, -- Soulfrost
    [138800] = {3869}, -- Blade Ward
    [138801] = {5392}, -- Blood Draining
    [138802] = {4097}, -- Power Torrent
    [138803] = {4066}, -- Mending
    [138804] = {4445}, -- Colossus
    [138805] = {4442}, -- Jade Spirit
    [138806] = {5335}, -- Mark of Shadowmoon
    [138807] = {5331}, -- Mark of the Shattered Hand
    [138808] = {5384}, -- Mark of Bleeding Hollow
    [138809] = {5336}, -- Mark of Blackrock
    [138827] = {5876}, -- Nightmare
    [138828] = {5877}, -- Chronos
    [138832] = {5871}, -- Earthliving
    [138833] = {5872}, -- Flametongue
    [138834] = {5873}, -- Frostbrand
    [138835] = {5874}, -- Rockbiter
    [138836] = {5875}, -- Windfury
    [138838] = {3273}, -- Deathfrost
    [138954] = {5364}, -- Poisoned
    [138955] = {5869}, -- Rune of Razorice
    [147778] = {5924}, -- Demonic Tyranny
    [174932] = {6174}, -- Void Edge
    [182204] = {6258}, -- Sinwrath
    [183134] = {6264}, -- Hunt's Favor
    [183189] = {6261}, -- Undying Spirit
    [183462] = {6262}, -- Unbreakable Resolve
    [184164] = {6263}, -- Wild Soul
    [184351] = {6256}, -- Devoted Spirit
    [184352] = {6257}, -- Transcendent Soul
    [200470] = {6672}, -- Primal Mastery
    [200883] = {6675}, -- Primal Air
    [200905] = {6676}, -- Primal Earth
    [200906] = {6677}, -- Primal Fire
    [200907] = {6678}, -- Primal Frost
    [220765] = {7322}, -- Sha Corruption
    [250776] = {8246}, -- Sha Corruption
    [138787] = {803,1899,5863}, -- Tome of Illusions: Azeroth
    [138789] = {5390,2674,5864}, -- Tome of Illusions: Outland
    [138790] = {5391,1894,5388}, -- Tome of Illusions: Northrend
    [138791] = {4098,4084,5867}, -- Tome of Illusions: Cataclysm
    [138792] = {4067,4099,4074}, -- Tome of Illusions: Elemental Lords
    [138793] = {4441,4443,5868}, -- Tome of Illusions: Pandaria
    [138794] = {4446,4444}, -- Tome of Illusions: Secrets of the Shado-Pan
    [138795] = {5330,5334}, -- Tome of Illusions: Draenor
}

function CanIMogIt:IsItemIllusion(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return false end
    if ItemToIllusion[itemID] then
        return true
    end
    return false
end
CanIMogIt.IsItemIllusion = CanIMogIt.RetailWrapper(CanIMogIt.IsItemIllusion, false)

function CanIMogIt:IllusionItemsKnown(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    if itemID == nil then return end
    local illusions = ItemToIllusion[itemID]
    if illusions == nil then return end
    local knownCount = 0
    local totalCount = #illusions
    for i,v in ipairs(illusions) do
        local illusionInfo = C_TransmogCollection.GetIllusionInfo(v)
        if illusionInfo and illusionInfo.isCollected then
            knownCount = knownCount + 1
        end
    end
    return knownCount, totalCount
end

function CanIMogIt:CalculateIllusionText(itemLink)
    if not CanIMogItOptions["showIllusionItems"] then
        return CanIMogIt.NOT_TRANSMOGABLE, CanIMogIt.NOT_TRANSMOGABLE
    end

    local knownCount, totalCount = CanIMogIt:IllusionItemsKnown(itemLink)
    local ratio = ""
    if totalCount > 1 then
        ratio = "(" .. knownCount .. "/" .. totalCount .. ")"
    end
    if knownCount == 0 then
        return CanIMogIt.UNKNOWN .. ratio, CanIMogIt.UNKNOWN
    elseif knownCount == totalCount then
        return CanIMogIt.KNOWN .. ratio, CanIMogIt.KNOWN
    else
        return CanIMogIt.PARTIAL .. ratio, CanIMogIt.PARTIAL
    end
end
