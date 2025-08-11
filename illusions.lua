local L = CanIMogIt.L

-- 55 items from https://www.wowhead.com/items/consumables/name:illusion
-- 88 illusions from https://wago.tools/db2/TransmogIllusion
-- Illusion names are from https://wago.tools/db2/SpellItemEnchantment
-- Add missing ones from https://warcraft-secrets.com/guides/hidden-weapon-illusions
-- There are 7 basic illusions without illusion books.
-- 12 PvP illusions without illusion books.
-- 69 illusions matched from all 55 items by name or description.
local Illusions = {
    {IllusionID=5360,Source=""}, -- Hide Weapon Enchant
    {IllusionID=1898,Source=""}, -- Lifestealing
    {IllusionID=5387,Source=""}, -- Agility
    {IllusionID=5389,Source=""}, -- Striking
    {IllusionID=5393,Source=""}, -- Crusader
    {IllusionID=5861,Source=""}, -- Beastslayer
    {IllusionID=5862,Source=""}, -- Titanguard

    {IllusionID=5394,ItemID=118572,Source=""}, -- Flames of Ragnaros
    {IllusionID=5448,ItemID=128649,Source="Holiday"}, -- Winter's Grasp
    {IllusionID=3225,ItemID=138796,Source="Vendor: Reputation - The Consortium"}, -- Executioner
    {IllusionID=2673,ItemID=138797,Source="Boss Drop: Moroes in Karazhan"}, -- Mongoose
    {IllusionID=5865,ItemID=138798,Source="Boss Drop: Shade of Aran in Karazhan"}, -- Sunfire
    {IllusionID=5866,ItemID=138799,Source="Boss Drop: Terestian Illhoof in Karazhan"}, -- Soulfrost
    {IllusionID=3869,ItemID=138800,Source="Boss Drop: Hodir, Mimiron, Freya, Thorim in Ulduar (25 Player)"}, -- Blade Ward
    {IllusionID=5392,ItemID=138801,Source="Boss Drop: Yogg-Saron in Ulduar (25 Player)"}, -- Blood Draining
    {IllusionID=4097,ItemID=138802,Source="Boss Drop: Nefarian in Blackwing Descent"}, -- Power Torrent
    {IllusionID=4066,ItemID=138803,Source="Vendor: Reputation - Guardians of Hyjal"}, -- Mending
    {IllusionID=4445,ItemID=138804,Source="Boss Drop: Will of the Emperor in Mogu'shan Vaults"}, -- Colossus
    {IllusionID=4442,ItemID=138805,Source="Boss Drop: Sha of Fear in Terrace of Endless Spring"}, -- Jade Spirit
    {IllusionID=5335,ItemID=138806,Source="Boss Drop: Ner'zhul in Shadowmoon Burial Grounds"}, -- Mark of Shadowmoon
    {IllusionID=5331,ItemID=138807,Source="Boss Drop: Kargath in Highmaul"}, -- Mark of the Shattered Hand
    {IllusionID=5384,ItemID=138808,Source="Boss Drop: Kilrogg in Hellfire Citadel"}, -- Mark of Bleeding Hollow
    {IllusionID=5336,ItemID=138809,Source="Boss Drop: Blackhand in Blackrock Foundry"}, -- Mark of Blackrock
    {IllusionID=5876,ItemID=138827,Source="Boss Drop: Xavius in The Emerald Nightmare"}, -- Nightmare
    {IllusionID=5877,ItemID=138828,Source="Boss Drop: Chronomatic Anomaly in The Nighthold"}, -- Chronos
    {IllusionID=3273,ItemID=138838,Source="Boss Drop: Ahune in The Slave Pens"}, -- Deathfrost
    {IllusionID=6174,ItemID=174932,Source="Drop: Valeera's Corrupted Chest - Horrific Vision of Stormwind"}, -- Void Edge
    {IllusionID=6672,ItemID=200470,Source="Profession: Enchanting - Illusion: Primal Mastery"}, -- Primal Mastery
    {IllusionID=6675,ItemID=200883,Source="Profession: Enchanting - Illusion: Primal Air"}, -- Primal Air
    {IllusionID=6676,ItemID=200905,Source="Profession: Enchanting - Illusion: Primal Earth"}, -- Primal Earth
    {IllusionID=6677,ItemID=200906,Source="Profession: Enchanting - Illusion: Primal Fire"}, -- Primal Fire
    {IllusionID=6678,ItemID=200907,Source="Profession: Enchanting - Illusion: Primal Frost"}, -- Primal Frost
    {IllusionID=7322,ItemID=220765,Source="Pandaria Remix"}, -- Sha Corruption
    {IllusionID=8246,ItemID=250776,Source=""}, -- Sha Corruption

    -- Shaman
    {IllusionID=5871,ItemID=138832,Source="Boss Drop: Valithria Dreamwalker in Icecrown Citadel (25 Player)"}, -- Earthliving
    {IllusionID=5872,ItemID=138833,Source="Boss Drop: Ragnaros in Molten Core"}, -- Flametongue
    {IllusionID=5873,ItemID=138834,Source="Boss Drop: Hydross the Unstable in Serpentshrine Cavern"}, -- Frostbrand
    {IllusionID=5874,ItemID=138835,Source="Boss Drop: Tectus in Highmaul"}, -- Rockbiter
    {IllusionID=5875,ItemID=138836,Source="Boss Drop: Al'Akir in Throne of the Four Winds"}, -- Windfury

    -- Rogue
    {IllusionID=5364,ItemID=138954,Source="Vendor: Griftah"}, -- Poisoned

    -- Death Knight
    {IllusionID=5869,ItemID=138955,Source="Boss Drop: The Lich King in Icecrown Citadel"}, -- Rune of Razorice

    {IllusionID=1899,ItemID=138787,Source="Profession: Enchanting - Tome of Illusions: Azeroth"}, -- Unholy Weapon
    {IllusionID=803,ItemID=138787,Source="Profession: Enchanting - Tome of Illusions: Azeroth"}, -- Fiery Weapon
    {IllusionID=5863,ItemID=138787,Source="Profession: Enchanting - Tome of Illusions: Azeroth"}, -- Coldlight
    {IllusionID=2674,ItemID=138789,Source="Profession: Enchanting - Tome of Illusions: Outland"}, -- Spellsurge
    {IllusionID=5390,ItemID=138789,Source="Profession: Enchanting - Tome of Illusions: Outland"}, -- Battlemaster
    {IllusionID=5864,ItemID=138789,Source="Profession: Enchanting - Tome of Illusions: Outland"}, -- Netherflame
    {IllusionID=1894,ItemID=138790,Source="Profession: Enchanting - Tome of Illusions: Northrend"}, -- Icy Chill
    {IllusionID=5391,ItemID=138790,Source="Profession: Enchanting - Tome of Illusions: Northrend"}, -- Berserking
    {IllusionID=5388,ItemID=138790,Source="Profession: Enchanting - Tome of Illusions: Northrend"}, -- Greater Spellpower
    {IllusionID=4098,ItemID=138791,Source="Profession: Enchanting - Tome of Illusions: Cataclysm"}, -- Windwalk
    {IllusionID=4084,ItemID=138791,Source="Profession: Enchanting - Tome of Illusions: Cataclysm"}, -- Heartsong
    {IllusionID=5867,ItemID=138791,Source="Profession: Enchanting - Tome of Illusions: Cataclysm"}, -- Light of the Earth-Warder
    {IllusionID=4074,ItemID=138792,Source="Profession: Enchanting - Tome of Illusions: Elemental Lords"}, -- Elemental Slayer
    {IllusionID=4099,ItemID=138792,Source="Profession: Enchanting - Tome of Illusions: Elemental Lords"}, -- Landslide
    {IllusionID=4067,ItemID=138792,Source="Profession: Enchanting - Tome of Illusions: Elemental Lords"}, -- Avalanche
    {IllusionID=4441,ItemID=138793,Source="Profession: Enchanting - Tome of Illusions: Pandaria"}, -- Windsong
    {IllusionID=4443,ItemID=138793,Source="Profession: Enchanting - Tome of Illusions: Pandaria"}, -- Elemental Force
    {IllusionID=5868,ItemID=138793,Source="Profession: Enchanting - Tome of Illusions: Pandaria"}, -- Breath of Yu'lon
    {IllusionID=4444,ItemID=138794,Source="Profession: Enchanting - Tome of Illusions: Shado-Pan Arts"}, -- Dancing Steel
    {IllusionID=4446,ItemID=138794,Source="Profession: Enchanting - Tome of Illusions: Shado-Pan Arts"}, -- River's Song
    {IllusionID=5330,ItemID=138795,Source="Profession: Enchanting - Tome of Illusions: Draenor"}, -- Mark of the Thunderlord
    {IllusionID=5334,ItemID=138795,Source="Profession: Enchanting - Tome of Illusions: Draenor"}, -- Mark of the Frostwolf

    -- Shadowlands Covenant Renown
    {IllusionID=6257,ItemID=184352,Source="You must be a member of the Kyrian Covenant or have reached Renown 80 with the Kyrian."}, -- Transcendent Soul
    {IllusionID=6262,ItemID=183462,Source="You must be a member of the Necrolord Covenant or have reached Renown 80 with the Necrolords."}, -- Unbreakable Resolve
    {IllusionID=6263,ItemID=184164,Source="You must be a member of the Night Fae Covenant or have reached Renown 80 with the Night Fae."}, -- Wild Soul
    {IllusionID=6258,ItemID=182204,Source="You must be a member of the Venthyr Covenant or have reached Renown 80 with the Venthyr."}, -- Sinwrath

    -- Shadowlands Reputation
    {IllusionID=6256,ItemID=184351,Source="Requires Exalted with the Ascended."}, -- Devoted Spirit
    {IllusionID=6261,ItemID=183189,Source="Requires Exalted with the Undying Army."}, -- Undying Spirit
    {IllusionID=6264,ItemID=183134,Source="Requires Exalted with the Wild Hunt."}, -- Hunt's Favor
    {IllusionID=6259,ItemID=182207,Source="Requires Exalted with the Court of Harvesters."}, -- Sinsedge

    {IllusionID=6162,ItemID=172177,Source="Shadowlands Epic Edition"}, -- Wraithchill
    {IllusionID=6158,ItemID=171363,Source="Recruit-A-Friend"}, -- Stinging Sands

    -- PvP Seasons
    {IllusionID=5396,ItemID=120286,Source="Obtained by achieving 2400 PvP Rating during Warlords of Draenor PvP Seasons 1, 2 or 3"}, -- Glorious Tyranny
    {IllusionID=5397,ItemID=120287,Source="Obtained by achieving 2400 PvP Rating during Warlords of Draenor PvP Seasons 1, 2 or 3"}, -- Primal Victory
    {IllusionID=5924,ItemID=147778,Source="Obtained by achieving 2400 PvP Rating during Legion PvP Season 3, 4, 5, 6 or 7"}, -- Demonic Tyranny
    {IllusionID=6096,Source="Obtained by achieving 2100 PvP Rating during Battle for Azeroth PvP Season 1, 2, 3 and 4"}, -- Dreadflame
    {IllusionID=6266,Source="Obtained by achieving 2100 PvP Rating during Shadowlands PvP Season 1"}, -- Sinful Flame
    {IllusionID=6344,Source="Obtained by achieving 2100 PvP Rating during Shadowlands PvP Season 2"}, -- Unchained Fury
    {IllusionID=6351,Source="Obtained by achieving 2100 PvP Rating during Shadowlands PvP Season 3"}, -- Cosmic Flow
    {IllusionID=6378,Source="Obtained by achieving 2100 PvP Rating during Shadowlands PvP Season 4"}, -- Eternal Flux
    {IllusionID=6786,Source="Obtained by achieving 2100 PvP Rating during Dragonflight Season 1"}, -- Primal Storm
    {IllusionID=6836,Source="Obtained by achieving 2100 PvP Rating during Dragonflight Season 2"}, -- Shadow Flame
    {IllusionID=7032,Source="Obtained by achieving 2100 PvP Rating during Dragonflight Season 3"}, -- Verdant Crush
    {IllusionID=7100,Source="Obtained by achieving 2100 PvP Rating during Dragonflight Season 4"}, -- Bronze Infinite
    {IllusionID=7521,Source="Obtained by achieving 1950 PvP Rating during The War Within Season 1"}, -- Holy Fire
    {IllusionID=7640,Source="Obtained by achieving 1950 PvP Rating during The War Within Season 2"}, -- Jackpot
    {IllusionID=7641,Source="Obtained by achieving 1950 PvP Rating during The War Within Season 3"}, -- Arcane
}

local IllusionsMap = {}
local ItemToIllusion = {}
for _, v in ipairs(Illusions) do
    IllusionsMap[v.IllusionID] = v
    if v.ItemID then
        if not ItemToIllusion[v.ItemID] then
            ItemToIllusion[v.ItemID] = {}
        end
        table.insert(ItemToIllusion[v.ItemID], v.IllusionID)
    end
end

CanIMogIt.Illusions = Illusions
CanIMogIt.IllusionsMap = IllusionsMap

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
