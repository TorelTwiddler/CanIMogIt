

CIMIScanTooltip = {}

if CanIMogIt.isRetail then
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
        if bag and slot then
            return C_Container.GetContainerItemInfo(bag, slot).isBound
        else
            return select(14, C_Item.GetItemInfo(itemLink)) == 1
        end
    end

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
                if line.leftText == ITEM_ACCOUNTBOUND
                    or line.leftText == ITEM_ACCOUNTBOUND_UNTIL_EQUIP then
                    return true
                end
                if line.rightText == ITEM_ACCOUNTBOUND
                    or line.rightText == ITEM_ACCOUNTBOUND_UNTIL_EQUIP then
                    return true
                end
            end
        end
        return false
    end

else

    -- This works for Classic, though it is slower and more limited.

    local _G = _G
    local L = CanIMogIt.L


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


    -- Tooltip setup
    CIMIScanTooltip = CreateFrame( "GameTooltip", "CIMIScanTooltip");
    CIMIScanTooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );
    CIMIScanTooltip:AddFontStrings(
        CIMIScanTooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
        CIMIScanTooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ) );


    local function GetRedText(text)
        if text and text:GetText() then
            local r,g,b = text:GetTextColor()
            -- Color values from RED_FONT_COLOR (see FrameXML/FontStyles.xml)
            if math.floor(r*256) == 255 and math.floor(g*256) == 32 and math.floor(b*256) == 32 then
                return text:GetText()
            end
        end
    end


    local function IsItemSoulbound(text)
        if not text then return end
        if text:GetText() == ITEM_SOULBOUND or text:GetText() == ITEM_BIND_ON_PICKUP then
            return true
        end
        return false
    end


    local function IsItemBindOnEquip(text)
        if not text then return end
        if text:GetText() == ITEM_BIND_ON_EQUIP or text:GetText() == ITEM_BIND_ON_USE then
            return true
        end
        return false
    end


    -- local function GetRequiredText(text)
    --     -- Returns {Profession = level} if the text has a profession in it,
    --     if text and text:GetText() then
    --         return partOf(text:GetText(), ITEM_REQ_SKILL)
    --     end
    -- end


    local function GetClassesText(text)
        -- Returns the text of classes required by this item, or nil if None
        if text and text:GetText() then
            return partOf(text:GetText(), ITEM_CLASSES_ALLOWED)
        end
    end


    function CIMIScanTooltip:CIMI_SetItem(itemLink, bag, slot)
        -- Sets the item for the tooltip based on the itemLink or bag and slot.
        if bag and slot and bag == BANK_CONTAINER then
            self:SetInventoryItem("player", BankButtonIDToInvSlotID(slot, nil))
        elseif bag and slot then
            self:SetBagItem(bag, slot)
        else
            local isBattlepet = string.match(itemLink, ".*(battlepet):.*") == "battlepet"
            if not isBattlepet then
                self:SetHyperlink(itemLink)
            end
        end
    end


    function CIMIScanTooltip:ScanTooltipBreak(func, itemLink, bag, slot)
        -- Scans the tooltip, breaking when an item is found.
        self:CIMI_SetItem(itemLink, bag, slot)
        local result;
        local tooltipName = self:GetName()
        for i = 1, self:NumLines() do
            result = func(_G[tooltipName..'TextLeft'..i]) or func(_G[tooltipName..'TextRight'..i])
            if result then break end
        end
        self:ClearLines()
        return result
    end


    function CIMIScanTooltip:ScanTooltip(func, itemLink, bag, slot)
        -- Scans the tooltip, returning a table of all of the results.
        self:CIMI_SetItem(itemLink, bag, slot)
        local tooltipName = self:GetName()
        local results = {}
        for i = 1, self:NumLines() do
            results[tooltipName..'TextLeft'..i] = func(_G[tooltipName..'TextLeft'..i])
            results[tooltipName..'TextRight'..i] = func(_G[tooltipName..'TextRight'..i])
        end
        self:ClearLines()
        return results
    end


    function CIMIScanTooltip:GetNumberOfLines(itemLink, bag, slot)
        -- Returns the number of lines on the tooltip with this item
        self:CIMI_SetItem(itemLink, bag, slot)
        local numberOfLines = self:NumLines()
        self:ClearLines()
        return numberOfLines
    end


    function CIMIScanTooltip:GetRedText(itemLink)
        -- Returns all of the red text as space seperated string.
        local results = self:ScanTooltip(GetRedText, itemLink)
        local red_texts = {}
        for key, value in pairs(results) do
            if value then
                table.insert(red_texts, value)
            end
        end
        return string.sub(table.concat(red_texts, " "), 1, 80)
    end


    -- function CIMIScanTooltip:GetProfessionInfo(itemLink)
    --     -- Returns all of the red text as space seperated string.
    --     local result = self:ScanTooltipBreak(GetProfessionText, itemLink)

    --     return
    -- end


    function CIMIScanTooltip:GetClassesRequired(itemLink)
        -- Returns a table of classes required for the item.
        local result = self:ScanTooltipBreak(GetClassesText, itemLink)
        if result then
            return CanIMogIt.Utils.strsplit(",%s*", result)
        end
    end


    function CIMIScanTooltip:IsItemSoulbound(itemLink, bag, slot)
        -- Returns whether the item is soulbound or not.
        if bag and slot then
            return self:ScanTooltipBreak(IsItemSoulbound, nil, bag, slot)
        else
            return self:ScanTooltipBreak(IsItemSoulbound, itemLink)
        end
    end


    function CIMIScanTooltip:IsItemBindOnEquip(itemLink, bag, slot)
        -- Returns whether the item is bind on equip or not.
        if bag and slot then
            return self:ScanTooltipBreak(IsItemBindOnEquip, nil, bag, slot)
        else
            return self:ScanTooltipBreak(IsItemBindOnEquip, itemLink)
        end
    end
end
