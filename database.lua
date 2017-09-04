--[[
    global = {
        "appearances" = {
            appearanceID:INVTYPE_HEAD = {
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


CanIMogIt_DatabaseVersion = 1.1


local default = {
    global = {
        appearances = {},
        setItems = {}
    }
}


local function UpdateDatabase()
    CanIMogIt:Print("Updating Database to version: " .. CanIMogIt_DatabaseVersion)
    local appearancesTable = copyTable(CanIMogIt.db.global.appearances)
    for appearanceID, appearance in pairs(appearancesTable) do
        local sources = appearance.sources
        for sourceID, source in pairs(sources) do
            -- Get the appearance hash for the source
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local hash = CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
            -- Add the source to the appearances with the new hash key
            if not CanIMogIt.db.global.appearances[hash] then
                CanIMogIt.db.global.appearances[hash] = {
                    ["sources"] = {},
                }
            end
            CanIMogIt.db.global.appearances[hash].sources[sourceID] = source
        end
        -- Remove the old one
        CanIMogIt.db.global.appearances[appearanceID] = nil
    end
    CanIMogIt.db.global.databaseVersion = CanIMogIt_DatabaseVersion
    CanIMogIt:Print("Database updated!")
end


function CanIMogIt:OnInitialize()
    if (not CanIMogItDatabase) then
        StaticPopup_Show("CANIMOGIT_NEW_DATABASE")
    end
    self.db = LibStub("AceDB-3.0"):New("CanIMogItDatabase", default)

    if not self.db.global.databaseVersion
            or self.db.global.databaseVersion < CanIMogIt_DatabaseVersion then
        UpdateDatabase()
    end
end




function CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
    if not appearanceID or not itemLink then return end
    local slot = self:GetItemSlotName(itemLink)
    return appearanceID .. ":" .. slot
end


function CanIMogIt:DBHasAppearance(appearanceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    return self.db.global.appearances[hash] ~= nil
end


function CanIMogIt:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasAppearance(appearanceID, itemLink) then
        local hash = CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
        self.db.global.appearances[hash] = {
            ["sources"] = {},
        }
    end
end


function CanIMogIt:DBRemoveAppearance(appearanceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    self.db.global.appearances[hash] = nil
end


function CanIMogIt:DBHasSource(appearanceID, sourceID, itemLink)
    if appearanceID == nil or sourceID == nil then return end
    if CanIMogIt:DBHasAppearance(appearanceID, itemLink) then
        local hash = self:GetAppearanceHash(appearanceID, itemLink)
        return self.db.global.appearances[hash].sources[sourceID] ~= nil
    end
    return false
end


function CanIMogIt:DBGetSources(appearanceID, itemLink)
    -- Returns the table of sources for the appearanceID.
    if self:DBHasAppearance(appearanceID, itemLink) then
        local hash = self:GetAppearanceHash(appearanceID, itemLink)
        return self.db.global.appearances[hash].sources
    end
end


function CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
    -- Adds the item to the database. Returns true if it added something, false otherwise.
    if appearanceID == nil or sourceID == nil then
        appearanceID, sourceID = self:GetAppearanceID(itemLink)
    end
    if appearanceID == nil or sourceID == nil then return end
    self:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasSource(appearanceID, sourceID, itemLink) then
        local hash = self:GetAppearanceHash(appearanceID, itemLink)
        self.db.global.appearances[hash].sources[sourceID] = {
            ["subClass"] = self:GetItemSubClassName(itemLink),
            ["classRestrictions"] = self:GetItemClassRestrictions(itemLink),
        }
        if self:GetItemSubClassName(itemLink) == nil then
            CanIMogIt:Print("nil subclass: " .. itemLink)
        end
        -- For testing:
        -- CanIMogIt:Print("New item found: " .. itemLink .. " sourceID: " .. sourceID .. " appearanceID: " .. appearanceID)
        return true
    end
    return false
end


function CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    if self.db.global.appearances[hash] == nil then return end
    if self.db.global.appearances[hash].sources[sourceID] ~= nil then
        self.db.global.appearances[hash].sources[sourceID] = nil
        if next(self.db.global.appearances[hash].sources) == nil then
            self:DBRemoveAppearance(appearanceID, itemLink)
        end
        -- For testing:
        -- CanIMogIt:Print("Item removed: " .. CanIMogIt:GetItemLinkFromSourceID(sourceID) .. " sourceID: " .. sourceID .. " appearanceID: " .. appearanceID)
    end
end


function CanIMogIt:DBHasItem(itemLink)
    local appearanceID, sourceID = self:GetAppearanceID(itemLink)
    if appearanceID == nil or sourceID == nil then return end
    return self:DBHasSource(appearanceID, sourceID, itemLink)
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


local function GetAppearancesEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        -- add all known appearanceID's to the database
        CanIMogIt:GetAppearances()
        CanIMogIt:GetSets()
    end
end
CanIMogIt.frame:AddEventFunction(GetAppearancesEvent)


local transmogEvents = {
    ["TRANSMOG_COLLECTION_SOURCE_ADDED"] = true,
    ["TRANSMOG_COLLECTION_SOURCE_REMOVED"] = true,
    ["TRANSMOG_COLLECTION_UPDATED"] = true,
}

local function TransmogCollectionUpdated(event, sourceID, ...)
    if transmogEvents[event] then
        -- Get the appearanceID from the sourceID
        if event == "TRANSMOG_COLLECTION_SOURCE_ADDED" then
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
        elseif event == "TRANSMOG_COLLECTION_SOURCE_REMOVED" then
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink)
        end
        CanIMogIt:ResetCache()
    end
end

CanIMogIt.frame:AddEventFunction(TransmogCollectionUpdated)


-- function CanIMogIt.frame:GetItemInfoReceived(event, ...)
--     if event ~= "GET_ITEM_INFO_RECEIVED" then return end
--     Database:GetItemInfoReceived()
-- end
