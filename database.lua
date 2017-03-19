--[[
    global = {
        "appearances" = {
            appearanceID = {
                "slot" = "INVTYPE_HEAD",
                "sources" = {
                    sourceID = {
                        "subClass" = "Mail",
                        "classRestrictions" = {"Mage", "Priest", "Warlock"}
                    }
                }
            }
        }
    }
]]

local L = CanIMogIt.L

local default = {
    global = {
        appearances = {},
        setItems = {}
    }
}


function CanIMogIt:OnInitialize()
    if (not CanIMogItDatabase) then
        StaticPopup_Show("CANIMOGIT_NEW_DATABASE")
    end
    self.db = LibStub("AceDB-3.0"):New("CanIMogItDatabase", default)
end


function CanIMogIt:DBHasAppearance(appearanceID)
    return self.db.global.appearances[appearanceID] ~= nil
end


function CanIMogIt:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasAppearance(appearanceID) then
        self.db.global.appearances[appearanceID] = {
            ["slot"] = self:GetItemSlotName(itemLink),
            ["sources"] = {},
        }
    end
end


function CanIMogIt:DBRemoveAppearance(appearanceID)
    self.db.global.appearances[appearanceID] = nil
end


function CanIMogIt:DBHasSource(appearanceID, sourceID)
    if appearanceID == nil or sourceID == nil then return end
    if CanIMogIt:DBHasAppearance(appearanceID) then
        return self.db.global.appearances[appearanceID].sources[sourceID] ~= nil
    end
    return false
end


function CanIMogIt:DBGetSources(appearanceID)
    -- Returns the table of sources for the appearanceID.
    if self:DBHasAppearance(appearanceID) then
        return self.db.global.appearances[appearanceID].sources
    end
end


function CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
    -- Adds the item to the database. Returns true if it added something, false otherwise.
    if appearanceID == nil or sourceID == nil then
        appearanceID, sourceID = self:GetAppearanceID(itemLink)
    end
    if appearanceID == nil or sourceID == nil then return end
    self:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasSource(appearanceID, sourceID) then
        self.db.global.appearances[appearanceID].sources[sourceID] = {
            ["subClass"] = self:GetItemSubClassName(itemLink),
            ["classRestrictions"] = self:GetItemClassRestrictions(itemLink),
        }
        if self:GetItemSubClassName(itemLink) == nil then
            CanIMogIt:Print("nil subclass: " .. itemLink)
        end
        -- For testing:
        -- CanIMogIt:Print("New item found: " .. itemLink)
        return true
    end
    return false
end


function CanIMogIt:DBRemoveItem(appearanceID, sourceID)
    if self.db.global.appearances[appearanceID] == nil then return end
    if self.db.global.appearances[appearanceID].sources[sourceID] ~= nil then
        self.db.global.appearances[appearanceID].sources[sourceID] = nil
        if next(self.db.global.appearances[appearanceID].sources) == nil then
            self:DBRemoveAppearance(appearanceID)
        end
        -- For testing:
        -- local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
        -- CanIMogIt:Print("Item removed: " .. itemLink)
    end
end


function CanIMogIt:DBHasItem(itemLink)
    local appearanceID, sourceID = self:GetAppearanceID(itemLink)
    if appearanceID == nil or sourceID == nil then return end
    return self:DBHasSource(appearanceID, sourceID)
end


function CanIMogIt:DBReset()
    CanIMogItDatabase = nil
    CanIMogIt.db = nil
    ReloadUI()
end


function CanIMogIt:SetsDBAddSetItem(set, sourceID)
    if CanIMogIt.db.global.setItems == nil then
        CanIMogIt.db.global.setItems = {}
    end

    CanIMogIt.db.global.setItems[sourceID] = set.setID
end

function CanIMogIt:SetsDBGetSetFromSourceID(sourceID)
    if CanIMogIt.db.global.setItems == nil then return end

    return CanIMogIt.db.global.setItems[sourceID]
end


function CanIMogIt.frame:GetAppearancesEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        -- add all known appearanceID's to the database
        CanIMogIt:GetAppearances()
        CanIMogIt:GetSets()
    end
end

local transmogEvents = {
    ["TRANSMOG_COLLECTION_SOURCE_ADDED"] = true,
    ["TRANSMOG_COLLECTION_SOURCE_REMOVED"] = true,
    ["TRANSMOG_COLLECTION_UPDATED"] = true,
}

function CanIMogIt.frame:TransmogCollectionUpdated(event, sourceID, ...)
    if transmogEvents[event] then
        -- Get the appearanceID from the sourceID
        if event == "TRANSMOG_COLLECTION_SOURCE_ADDED" then
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
        elseif event == "TRANSMOG_COLLECTION_SOURCE_REMOVED" then
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            CanIMogIt:DBRemoveItem(appearanceID, sourceID)
        end
        CanIMogIt:ResetCache()
    end
end


-- function CanIMogIt.frame:GetItemInfoReceived(event, ...)
--     if event ~= "GET_ITEM_INFO_RECEIVED" then return end
--     Database:GetItemInfoReceived()
-- end
