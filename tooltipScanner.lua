--[[
    source: http://forums.wowace.com/showthread.php?t=15588&page=2

    To use: 
    CanIMogItTooltipScanner:SetHyperlink(itemLink)
]]

local _G = _G
local L = CanIMogIt.L

-- Tooltip setup
CanIMogItTooltipScanner = CreateFrame( "GameTooltip", "CanIMogItTooltipScanner");
CanIMogItTooltipScanner:SetOwner( WorldFrame, "ANCHOR_NONE" );
CanIMogItTooltipScanner:AddFontStrings(
    CanIMogItTooltipScanner:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
    CanIMogItTooltipScanner:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ) );


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
    if text:GetText() == ITEM_SOULBOUND then
        return true
    end
    return false
end


function CanIMogItTooltipScanner:CIMI_SetItem(itemLink, bag, slot)
    -- Sets the item for the tooltip based on the itemLink or bag and slot.
    if bag and slot and bag == BANK_CONTAINER then
        self:SetInventoryItem("player", BankButtonIDToInvSlotID(slot, nil))
    elseif bag and slot then
        self:SetBagItem(bag, slot)
    else
        self:SetHyperlink(itemLink)
    end
end


function CanIMogItTooltipScanner:ScanTooltipBreak(func, itemLink, bag, slot)
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


function CanIMogItTooltipScanner:ScanTooltip(func, itemLink, bag, slot)
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


function CanIMogItTooltipScanner:GetRedText(itemLink)
    -- Returns all of the red text as space seperated string.
    local results = self:ScanTooltip(GetRedText, itemLink)
    local red_texts = {}
    for key, value in pairs(results) do
        if value then
            table.insert(red_texts, value)
        end
    end
    return table.concat(red_texts, " ")
end


function CanIMogItTooltipScanner:IsItemSoulbound(bag, slot)
    -- Returns whether the item is soulbound or not.
    if bag and slot then
        return self:ScanTooltipBreak(IsItemSoulbound, nil, bag, slot)
    else
        return false
    end
end
