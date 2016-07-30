--[[
    source: http://forums.wowace.com/showthread.php?t=15588&page=2

    To use: 
    CanIMogItTooltipScanner:SetHyperlink(itemLink)
]]

local _G = _G
local L = CanIMogIt.L

-- Tooltip setup
CanIMogItTooltipScanner = {}


local GameTooltip = GameTooltip


local function IsTextRed(text)
    if text and text:GetText() then
        local r,g,b = text:GetTextColor()
        -- Color values from RED_FONT_COLOR (see FrameXML/FontStyles.xml)
        return math.floor(r*256) == 255 and math.floor(g*256) == 32 and math.floor(b*256) == 32
    end
end


local function IsItemSoulbound(text)
    if not text then return end
    if text:GetText() == ITEM_SOULBOUND then
        return true
    end
    return false
end


function CanIMogItTooltipScanner:ScanTooltip(func)
    local tooltip = GameTooltip
    local tooltipName = tooltip:GetName()
    for i = 1, tooltip:NumLines() do
        result = func(_G[tooltipName..'TextLeft'..i]) or func(_G[tooltipName..'TextRight'..i])
        if result then break end
    end
    return result
end


function CanIMogItTooltipScanner:IsItemUsable(itemLink)
    return not self:ScanTooltip(IsTextRed)
end


function CanIMogItTooltipScanner:IsItemSoulbound(itemLink)
    return self:ScanTooltip(IsItemSoulbound)
end
