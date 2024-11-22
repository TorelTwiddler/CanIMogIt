CanIMogIt.cache = {}

function CanIMogIt.cache:Clear()
    self.data = {
        ["source"] = {},
        ["dressup_source"] = {},
        ["sets"] = {},
        ["setsSumRatio"] = {},
        ["appearanceData"] = {},
        ["itemData"] = {},
        ["bindData"] = {},
    }
end


function CanIMogIt.cache:GetAppearanceDataValue(itemLink)
    return self.data["appearanceData"][CanIMogIt:CalculateKey(itemLink)]
end


function CanIMogIt.cache:SetAppearanceDataValue(appData)
    if appData == nil then return end
    self.data["appearanceData"][appData.key] = appData
end


function CanIMogIt.cache:GetItemDataValue(itemLink)
    return self.data["itemData"][CanIMogIt:CalculateKey(itemLink)]
end


function CanIMogIt.cache:SetItemDataValue(itemData)
    if itemData == nil then return end
    self.data["itemData"][itemData.key] = itemData
end


function CanIMogIt.cache:GetBindDataValue(itemLink, bag, slot)
    return self.data["bindData"][CanIMogIt.BindData.CalculateKey(itemLink, bag, slot)]
end


function CanIMogIt.cache:SetBindDataValue(bindData)
    if bindData == nil then return end
    self.data["bindData"][bindData.key] = bindData
end


function CanIMogIt.cache:DeleteBindDataValue(itemLink, bag, slot)
    if itemLink == nil and (bag == nil or slot == nil) then
        return
    end
    if itemLink == nil then
        itemLink = C_Container.GetContainerItemLink(bag, slot)
    end
    if self.data["bindData"][CanIMogIt.BindData.CalculateKey(itemLink, bag, slot)] ~= nil then
        self.data["bindData"][CanIMogIt.BindData.CalculateKey(itemLink, bag, slot)] = nil
    end
    if itemLink then
        -- Delete the itemLink key as well, since it may be cached without the bag and slot.
        self.data["bindData"][CanIMogIt:CalculateKey(itemLink)] = nil
    end
end


function CanIMogIt.cache:RemoveItem(itemLink)
    self.data["source"][CanIMogIt:CalculateKey(itemLink)] = nil
    -- Have to remove all of the set data, since other itemLinks may cache
    -- the same set information. Alternatively, we scan through and find
    -- the same set on other items, but they're loaded on mouseover anyway,
    -- so it shouldn't be slow. Also applies to RemoveItemBySourceID.
    self:ClearSetData()
end


function CanIMogIt.cache:GetItemSourcesValue(itemLink)
    return self.data["source"][CanIMogIt:CalculateKey(itemLink)]
end


function CanIMogIt.cache:SetItemSourcesValue(itemLink, value)
    self.data["source"][CanIMogIt:CalculateKey(itemLink)] = value
end


function CanIMogIt.cache:GetSetsInfoTextValue(itemLink)
    return self.data["sets"][CanIMogIt:CalculateKey(itemLink)]
end


function CanIMogIt.cache:SetSetsInfoTextValue(itemLink, value)
    self.data["sets"][CanIMogIt:CalculateKey(itemLink)] = value
end


function CanIMogIt.cache:GetDressUpModelSource(itemLink)
    return self.data["dressup_source"][itemLink]
end

function CanIMogIt.cache:SetDressUpModelSource(itemLink, value)
    self.data["dressup_source"][itemLink] = value
end


function CanIMogIt.cache:ClearSetData()
    self.data["sets"] = {}
    self.data["setsSumRatio"] = {}
end


function CanIMogIt.cache:GetSetsSumRatioTextValue(key)
    return self.data["setsSumRatio"][key]
end


function CanIMogIt.cache:SetSetsSumRatioTextValue(key, value)
    self.data["setsSumRatio"][key] = value
end


local function OnClearCacheEvent(event)
    if event == "TRANSMOG_COLLECTION_UPDATED" then
        CanIMogIt.cache:Clear()
    end
end

CanIMogIt.frame:AddSmartEvent(OnClearCacheEvent, {"TRANSMOG_COLLECTION_UPDATED"})

local function OnClearBindCacheEvent(event, bag, slot)
    if event == "ITEM_LOCK_CHANGED" then
        CanIMogIt.cache:DeleteBindDataValue(nil, bag, slot)
    end
end

CanIMogIt.frame:AddSmartEvent(OnClearBindCacheEvent, {"ITEM_LOCK_CHANGED"})

CanIMogIt.cache:Clear()
