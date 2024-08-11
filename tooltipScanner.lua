

CIMIScanTooltip = {}

-- This only works for Retail.

local function IsColorValRed(colorVal)
    return colorVal.r == 1 and colorVal.g < 0.126 and colorVal.b < 0.126
end

local rootStringMemoized = {}
local function getBeforeAfter(rootString)
    if not rootStringMemoized[rootString] then
        local s, e = string.find(rootString, '%%s')
        local before = string.sub(rootString, 1, s-1)
        local after = string.sub(rootString, e+1, -1)
        rootStringMemoized[rootString] = {before, after}
    end
    return unpack(rootStringMemoized[rootString])
end

local function partOf(input, rootString)
    -- Pulls the rootString out of input, leaving the rest of the string.
    -- rootString is a constant with %s, such as "Required %s" or "Hello %s!"
    -- We must assume that no part (before or after) of rootString is in the sub string...
    local before, after = getBeforeAfter(rootString)
    local cleanBefore, count = input:gsub(before, "")
    if before and count == 0 then return false end
    local cleanAfter, count = cleanBefore:gsub(after, "")
    if after and count == 0 then return false end
    return cleanAfter
end

function CIMIScanTooltip:GetRedText(itemLink)
    -- Returns all of the red text as space separated string.
    local redTexts = {}
    local tooltipData = C_TooltipInfo.GetItemByID(CanIMogIt:GetItemID(itemLink))
    for i, line in pairs(tooltipData.lines) do
        local leftColorRed, rightColorRed;
        if line.leftColor then
            leftColorRed = IsColorValRed(line.leftColor)
        end
        if line.rightColor then
            rightColorRed = IsColorValRed(line.rightColor)
        end

        if leftColorRed then
            table.insert(redTexts, line.leftText)
        end
        if rightColorRed then
            table.insert(redTexts, line.rightText)
        end
    end
    return string.sub(table.concat(redTexts, " "), 1, 80)
end

local function GetClassesText(text)
    -- Returns the text of classes required by this item, or nil if None
    if text then
        return partOf(text, ITEM_CLASSES_ALLOWED)
    end
end

function CIMIScanTooltip:GetClassesRequired(itemLink)
    -- Returns a table of classes required for the item, if any, or nil if none.
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
    for i, line in pairs(tooltipData.lines) do
        local req_classes = GetClassesText(line.leftText)
        if req_classes then
            return CanIMogIt.Utils.strsplit(",%s*", req_classes)
        end
    end
end


function CIMIScanTooltip:IsItemSoulbound(itemLink, bag, slot, tooltipData)
    -- Returns whether the item is soulbound or not.
    if bag and slot then
        return C_Container.GetContainerItemInfo(bag, slot).isBound
    end

    if tooltipData and tooltipData.lines then
        for i, line in pairs(tooltipData.lines) do
            if line.leftText == ITEM_SOULBOUND then
                return true
            end
            if line.rightText == ITEM_SOULBOUND then
                return true
            end
        end
    end

    return select(14, C_Item.GetItemInfo(itemLink)) == 1
end

local accountBoundTexts = {
    ITEM_ACCOUNTBOUND,
    ITEM_ACCOUNTBOUND_UNTIL_EQUIP,
    ITEM_BIND_TO_ACCOUNT,
    ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP,
}

function CIMIScanTooltip:IsItemWarbound(itemLink, bag, slot, tooltipData)
    -- Returns whether the item is warbound or not.
    if not tooltipData then
        if bag and slot then
            tooltipData = C_TooltipInfo.GetBagItem(bag, slot)
        else
            tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
        end
    end
    if tooltipData and tooltipData.lines then
        for i, line in pairs(tooltipData.lines) do
            for _, accountBoundText in pairs(accountBoundTexts) do
                if line.leftText == accountBoundText then
                    return true
                end
                if line.rightText == accountBoundText then
                    return true
                end
            end
        end
    end
    return false
end
