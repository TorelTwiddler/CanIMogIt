
CanIMogIt.BindData = {}
CanIMogIt.BindData.__index = CanIMogIt.BindData


CanIMogIt.BindTypes = {
    Soulbound = "Soulbound",
    Accountbound = "Accountbound",
    BoE = "BoE"
}


function CanIMogIt.BindData:new(itemLink, bag, slot)
    if not itemLink then return nil end
    local this = setmetatable({}, CanIMogIt.BindData)
    this.itemLink = itemLink
    this.key = CanIMogIt.BindData.CalculateKey(itemLink, bag, slot)
    this.bag = bag
    this.slot = slot
    this.type = this:CalculateType()
    -- If the type is nil, then the item is likely not ready yet.
    if this.type == nil then return nil end
    return this
end


function CanIMogIt.BindData.CalculateKey(itemLink, bag, slot)
    if not itemLink then return nil end
    if bag and slot then
        return "bag-slot:" .. bag .. "-" .. slot
    else
        return CanIMogIt:CalculateKey(itemLink)
    end
end


function CanIMogIt.BindData:CalculateType()
    local accountbound = CIMIScanTooltip:IsItemAccountbound(self.itemLink, self.bag, self.slot)
    if accountbound == nil then return nil end
    if accountbound then
        return CanIMogIt.BindTypes.Accountbound
    end

    local soulbound = CIMIScanTooltip:IsItemSoulbound(self.itemLink, self.bag, self.slot)
    if soulbound == nil then return nil end
    if soulbound then
        return CanIMogIt.BindTypes.Soulbound
    end

    return CanIMogIt.BindTypes.BoE
end
