
CanIMogIt.ItemData = {}
CanIMogIt.ItemData.__index = CanIMogIt.ItemData


CanIMogIt.ItemTypes = {
    Transmogable = "Transmogable",
    Mount = "Mount",
    Toy = "Toy",
    Pet = "Pet",
    Ensemble = "Ensemble",
    Other = "Other"
}


function CanIMogIt.ItemData:new(itemLink, isTransmogable, isItemMount, isItemToy, isItemPet, isItemEnsemble, isItemEquippable)
    if itemLink == nil
        or isTransmogable == nil
        or isItemMount == nil
        or isItemToy == nil
        or isItemPet == nil
        or isItemEnsemble == nil
        or isItemEquippable == nil then
        return nil
    end
    local this = setmetatable({}, CanIMogIt.ItemData)
    this.itemLink = itemLink
    this.key = CanIMogIt:CalculateKey(itemLink)
    this.isTransmogable = isTransmogable
    this.isItemMount = isItemMount
    this.isItemToy = isItemToy
    this.isItemPet = isItemPet
    this.isItemEnsemble = isItemEnsemble
    this.isItemEquippable = isItemEquippable
    this.type = this:CalculateType()
    return this
end


function CanIMogIt.ItemData.FromItemLink(itemLink)
    if itemLink == nil then return end
    local isTransmogable = CanIMogIt:IsTransmogable(itemLink)
    if isTransmogable == nil then return end
    local isItemMount = CanIMogIt:IsItemMount(itemLink)
    if isItemMount == nil then return end
    local isItemToy = CanIMogIt:IsItemToy(itemLink)
    if isItemToy == nil then return end
    local isItemPet = CanIMogIt:IsItemPet(itemLink)
    if isItemPet == nil then return end
    local isItemEnsemble = CanIMogIt:IsItemEnsemble(itemLink)
    if isItemEnsemble == nil then return end
    local isItemEquippable = CanIMogIt:IsEquippable(itemLink)
    if isItemEquippable == nil then return end
    return CanIMogIt.ItemData:new(itemLink, isTransmogable, isItemMount, isItemToy, isItemPet, isItemEnsemble, isItemEquippable)
end


function CanIMogIt.ItemData:CalculateType()
    if self.isTransmogable then
        return CanIMogIt.ItemTypes.Transmogable
    elseif self.isItemMount then
        return CanIMogIt.ItemTypes.Mount
    elseif self.isItemToy then
        return CanIMogIt.ItemTypes.Toy
    elseif self.isItemPet then
        return CanIMogIt.ItemTypes.Pet
    elseif self.isItemEnsemble then
        return CanIMogIt.ItemTypes.Ensemble
    else
        return CanIMogIt.ItemTypes.Other
    end
end
