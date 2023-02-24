

CIMIScanTooltip = {}

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
        local leftText, rightText, leftColorRed, rightColorRed;
        for j, arg in pairs(line.args) do
            if arg.field == "leftText" then
                leftText = arg.stringVal
            end
            if arg.field == "rightText" then
                rightText = arg.stringVal
            end
            if arg.field == "leftColor" then
                leftColorRed = IsColorValRed(arg.colorVal)
            end
            if arg.field == "rightColor" then
                rightColorRed = IsColorValRed(arg.colorVal)
            end
        end

        if leftColorRed then
            table.insert(redTexts, leftText)
        end
        if rightColorRed then
            table.insert(redTexts, rightText)
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
    local tooltipData = C_TooltipInfo.GetItemByID(CanIMogIt:GetItemID(itemLink))
    for i, line in pairs(tooltipData.lines) do
        local leftText;
        for j, arg in pairs(line.args) do
            if arg.field == "leftText" then
                leftText = arg.stringVal
            end
            local req_classes = GetClassesText(leftText)
            if req_classes then
                return CanIMogIt.Utils.strsplit(",%s*", req_classes)
            end
        end
    end
end


function CIMIScanTooltip:IsItemSoulbound(itemLink, bag, slot)
    -- Returns whether the item is soulbound or not.
    if bag and slot then
        return C_Container.GetContainerItemInfo(bag, slot).isBound
    else
        return select(14, GetItemInfo(itemLink)) == 1
    end
end


function CIMIScanTooltip:IsItemBindOnEquip(itemLink, bag, slot)
    -- Returns whether the item is bind on equip or not.
    if bag and slot and not itemLink then
        itemLink = C_Container.GetContainerItemLink(bag, slot)
    end
    local bind_type = select(14, GetItemInfo(itemLink))
    return bind_type == 2 or bind_type == 3
end
