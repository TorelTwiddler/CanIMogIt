-- Thanks to missing2014

local _, L = ...;
if GetLocale() == "znCN" then
    -- Tooltips
    L["Learned."] = "已解锁."
    L["Learned from another item."] =  "已解锁-来自同模型装备."
    L["Learned for a different class."] = "其他角色已解锁."
    L["Learned but cannot transmog yet."] = "已解锁但不能幻化."
    -- L["Learned from another item but cannot transmog yet."] = ""
    -- L["Learned for a different class and item."] = ""
    L["Not learned."] = "未解锁."
    -- L["Another class can learn this item."] = ""
    L["Cannot be learned by this character."] = "使用其他角色解锁."
    -- L["Can be learned by:"] = "" -- list of classes
    L["Cannot be learned."] = "不能解锁."
    L["Cannot determine status on other characters."] = "无法确认其他角色的状态."

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
