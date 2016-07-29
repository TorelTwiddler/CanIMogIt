-- Thanks to BJockeyR

local _, L = ...;
if GetLocale() == "deDE" then
    -- Tooltips
    L["Learned."] = "Bereits erlernt."
    L["Learned from another item."] =  "Von einem anderen Gegenstand erlernt."
    L["Learned for a different class."] = "Von einer anderen Klasse erlernt."
    L["Learned but cannot transmog yet."] = "Bereits erlernt, aber noch nicht zum transmogrifizieren verwendbar."
    -- L["Learned from another item but cannot transmog yet."] = ""
    L["Learned for a different class and item."] = "Von einer anderen Klasse oder einem anderen Gegenstand erlernt."
    L["Not learned."] = "Nicht erlernt."
    L["Another class can learn this item."] = "Eine andere Klasse kann diese Vorlage erlernen."
    -- L["Cannot be learned by this character."] = ""
    -- L["Can be learned by:"] = "" -- list of classes
    L["Cannot be learned."] = "Kann nicht erlernt werden."
    -- L["Cannot determine status on other characters."] = ""

    -- Messages
    -- L["CanIMogItOptions not found, loading defaults!"] = ""
    -- L["Can I Mog It? Important Message: Please log into all of your characters to compile complete transmog appearance data."] = ""

    -- Options
    -- L["Debug Tooltip"] = ""
    -- L["Detailed information for debug purposes. Use this when sending bug reports."] = ""
    -- L["Equippable Items Only"] = ""
    -- L["Only show on items that can be equipped."] = ""
    -- L["Transmoggable Items Only"] = ""
    -- L["Only show on items that can be transmoggrified."] = ""
    -- L["Unknown Items Only"] = ""
    -- L["Only show on items that you haven't learned."] = ""
end
