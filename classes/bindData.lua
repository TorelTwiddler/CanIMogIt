
CanIMogIt.BindData = {}
CanIMogIt.BindData.__index = CanIMogIt.BindData


CanIMogIt.BindTypes = {
    Soulbound = "Soulbound",
    Warbound = "Warbound",
    BoE = "BoE"
}


function CanIMogIt.BindData:new(itemLink, bag, slot, tooltipData)
    if not itemLink then return nil end
    local this = setmetatable({}, CanIMogIt.BindData)
    this.itemLink = itemLink
    this.key = CanIMogIt.BindData.CalculateKey(itemLink, bag, slot, tooltipData)
    this.bag = bag
    this.slot = slot
    this.tooltipData = tooltipData
    this.type = this:CalculateType()
    -- If the type is nil, then the item is likely not ready yet.
    if this.type == nil then return nil end
    return this
end


function CanIMogIt.BindData.CalculateKey(itemLink, bag, slot, tooltipData)
    if not itemLink then return nil end
    if bag and slot then
        return "bag-slot:" .. bag .. "-" .. slot
    elseif tooltipData then
        local tooltipString = ""
        for i, line in pairs(tooltipData.lines) do
            if i > 10 then break end
            if line.leftText then
                tooltipString = tooltipString .. line.leftText
            end
            if line.rightText then
                tooltipString = tooltipString .. line.rightText
            end
        end
        return "tooltip:" .. tooltipString
    else
        return CanIMogIt:CalculateKey(itemLink)
    end
end


function CanIMogIt.BindData:CalculateType()
    local warbound = CIMIScanTooltip:IsItemWarbound(self.itemLink, self.bag, self.slot, self.tooltipData)
    if warbound == nil then return nil end
    if warbound then
        return CanIMogIt.BindTypes.Warbound
    end

    local soulbound = CIMIScanTooltip:IsItemSoulbound(self.itemLink, self.bag, self.slot, self.tooltipData)
    if soulbound == nil then return nil end
    if soulbound then
        return CanIMogIt.BindTypes.Soulbound
    end

    return CanIMogIt.BindTypes.BoE
end
