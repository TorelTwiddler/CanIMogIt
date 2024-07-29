local L = CanIMogIt.L

CanIMogIt_DatabaseVersion = 1.3

local default = {
    global = {
        setItems = {},
        appearances = {},
    }
}

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


function CanIMogIt:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("CanIMogItDatabase", default)
end


-- Adding items to the database --


function CanIMogIt:CreateUpdateDatabaseCoroutine()
    local function UpdateDatabaseCoroutine ()
        local blockSize = 100000
        local counter = 0

        if CanIMogItOptions["printDatabaseScan"] then
            CanIMogIt:Print(CanIMogIt.DATABASE_START_UPDATE_TEXT)
        end
        coroutine.yield()

        -- Remove appearances from the database
        local sourcesRemovedCount = 0
        for hash, appearance in pairs(CanIMogIt.db.global.appearances) do
            for sourceID, source in pairs(appearance.sources) do
                local hasSource = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
                if not hasSource then
                    local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
                    local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
                    CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink, hash)
                    sourcesRemovedCount = sourcesRemovedCount + 1
                end
                counter = counter + 1
                if counter % blockSize * 5 == 0 then
                    coroutine.yield()
                end
            end
        end

        -- Add appearances to the database
        local appearanceCount = 0
        local sourceCount = 0
        local sourcesAddedCount = 0
        for categoryID=1,28 do
            local categoryAppearances = C_TransmogCollection.GetCategoryAppearances(categoryID)
            for i, categoryAppearance in pairs(categoryAppearances) do
                if categoryAppearance.isCollected then
                    appearanceCount = appearanceCount + 1
                end
                local sources = C_TransmogCollection.GetAppearanceSources(categoryAppearance.visualID)
                local sourcesCollected = 0
                for j, source in pairs(sources) do
                    if source.isCollected then
                        local itemLink = CanIMogIt:GetItemLinkFromSourceID(source.sourceID)
                        local added = CanIMogIt:DBAddItem(itemLink, categoryAppearance.visualID, source.sourceID)
                        if added then
                            sourcesAddedCount = sourcesAddedCount + 1
                        end
                        sourcesCollected = sourcesCollected + 1
                    end
                    counter = counter + 1
                    if counter % blockSize == 0 then
                        coroutine.yield()
                    end
                end
                if sourcesCollected > 0 then
                    sourceCount = sourceCount + 1
                end
            end
        end
        CanIMogIt:ResetCache()

        if CanIMogItOptions["printDatabaseScan"] then
            CanIMogIt:Print(CanIMogIt.DATABASE_DONE_UPDATE_TEXT..CanIMogIt.BLUE.."+" .. sourcesAddedCount .. ", "..CanIMogIt.ORANGE.."-".. sourcesRemovedCount)
        end
    end
    return coroutine.create(UpdateDatabaseCoroutine)
end

function CanIMogIt:UpdateDatabaseAppearances()
    -- Run the coroutine in OnUpdate until it's done.
    local co = CanIMogIt:CreateUpdateDatabaseCoroutine()
    CanIMogIt.frame:SetScript("OnUpdate", function()
        if coroutine.status(co) == "dead" then
            -- Remove the OnUpdate script
            CanIMogIt.frame:SetScript("OnUpdate", nil)
            return true
        end
        coroutine.resume(co)
    end)

end


-- Appearances --


function CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
    if not appearanceID or not itemLink then return end
    local slot = self:GetItemSlotName(itemLink)
    return appearanceID .. ":" .. slot
end

local function SourcePassesRequirement(source, requirementName, requirementValue)
    if source[requirementName] then
        if type(source[requirementName]) == "string" then
            -- single values, such as subClass = Plate
            if source[requirementName] ~= requirementValue then
                return false
            end
        elseif type(source[requirementName]) == "table" then
            -- multi-values, such as classRestrictions = Shaman, Hunter
            local found = false
            for index, sourceValue in pairs(source[requirementName]) do
                if sourceValue == requirementValue then
                    found = true
                end
            end
            if not found then
                return false
            end
        else
            return false
        end
    end
    return true
end


function CanIMogIt:DBHasAppearanceForRequirements(appearanceID, itemLink, requirements)
    --[[
        @param requirements: a table of {requirementName: value}, which will be
            iterated over for each known item to determine if all requirements are met.
            If the requirements are not met for any item, this will return false.
            For example, {"classRestrictions": "Druid"} would filter out any that don't
            include Druid as a class restriction. If the item doesn't have a restriction, it
            is assumed to not be a restriction at all.
    ]]
    if not self:DBHasAppearance(appearanceID, itemLink) then
        return false
    end
    for sourceID, source in pairs(self:DBGetSources(appearanceID, itemLink)) do
        for name, value in pairs(requirements) do
            if SourcePassesRequirement(source, name, value) then
                return true
            end
        end
    end
    return false
end


function CanIMogIt:DBHasAppearance(appearanceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    return self.db.global.appearances[hash] ~= nil
end


function CanIMogIt:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasAppearance(appearanceID, itemLink) then
        local hash = CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
        if hash == nil then return end
        self.db.global.appearances[hash] = {
            ["sources"] = {},
        }
    end
end


function CanIMogIt:DBRemoveAppearance(appearanceID, itemLink, dbHash)
    local hash = dbHash or self:GetAppearanceHash(appearanceID, itemLink)
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


CanIMogIt.itemsToAdd = {}

local function LateAddItems(event, itemID, success)
    if event == "GET_ITEM_INFO_RECEIVED" and itemID then
        -- The 8.0.1 update is causing this event to return a bunch of itemID=0
        if not success or itemID <= 0 then
            return
        end
        -- If the itemID is in itemsToAdd, first remove it from the table, then add it to the database.
        if CanIMogIt.itemsToAdd[itemID] then
            for sourceID, _ in pairs(CanIMogIt.itemsToAdd[itemID]) do
                local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
                local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
                CanIMogIt.itemsToAdd[itemID][sourceID] = nil
                CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
            end
            if next(CanIMogIt.itemsToAdd[itemID]) == nil then
                CanIMogIt.itemsToAdd[itemID] = nil
            end
        end
    end
end
CanIMogIt.frame:AddEventFunction(LateAddItems)


function CanIMogIt:_DBSetItem(itemLink, appearanceID, sourceID)
    -- Sets the item in the database, or at least schedules for it to be set
    -- when we get item info back.
    -- if GetItemInfo(itemLink) then
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    if self.db.global.appearances[hash] == nil then
        return
    end
    local subClass = self:GetItemSubClassName(itemLink)
    local classRestrictions = self:GetItemClassRestrictions(itemLink)

    self.db.global.appearances[hash].sources[sourceID] = {
        ["subClass"] = subClass,
    }
    if classRestrictions then
        self.db.global.appearances[hash].sources[sourceID]["classRestrictions"] = classRestrictions
    else
        self.db.global.appearances[hash].sources[sourceID]["classRestrictions"] = nil
    end
    if subClass == nil then
        CanIMogIt:Print("nil subclass: " .. itemLink)
    end
    if CanIMogItOptions['databaseDebug'] then
        -- enabled/disabled via the `/cimi printdb` command
        CanIMogIt:Print("New item found: " .. itemLink .. " itemID: " .. CanIMogIt:GetItemID(itemLink) .. " sourceID: " .. sourceID .. " appearanceID: " .. appearanceID)
    end
    -- else
    --     -- local itemID = CanIMogIt:GetItemID(itemLink)
    --     -- if not CanIMogIt.itemsToAdd[itemID] then
    --     --     CanIMogIt.itemsToAdd[itemID] = {}
    --     -- end
    --     -- CanIMogIt.itemsToAdd[itemID][sourceID] = true
    --     print("no item info: " .. itemLink)
    -- end
end


function CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
    -- Adds the item to the database. Returns true if it added something, false otherwise.
    if appearanceID == nil or sourceID == nil then
        appearanceID, sourceID = self:GetAppearanceID(itemLink)
    end
    if appearanceID == nil or sourceID == nil then return end
    self:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasSource(appearanceID, sourceID, itemLink) then
        CanIMogIt:_DBSetItem(itemLink, appearanceID, sourceID)
        return true
    end
    return false
end


function CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink, dbHash)
    -- The specific dbHash can be passed in to bypass trying to generate it.
    -- This is used mainly when Blizzard removes or changes item appearanceIDs.
    local hash = dbHash or self:GetAppearanceHash(appearanceID, itemLink)
    appearanceID = appearanceID or CanIMogIt.Utils.strsplit(":", hash)[1]
    if self.db.global.appearances[hash] == nil then return end
    if self.db.global.appearances[hash].sources[sourceID] ~= nil then
        self.db.global.appearances[hash].sources[sourceID] = nil
        if next(self.db.global.appearances[hash].sources) == nil then
            self:DBRemoveAppearance(appearanceID, itemLink, dbHash)
        end
        if CanIMogItOptions['databaseDebug'] then
            local itemID, itemLink
            if itemLink then
                itemID = CanIMogIt:GetItemID(itemLink)
            else
                itemID = "nil"
            end
            if sourceID then
                itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            end
            if not itemLink then
                itemLink = "nil"
            end
            CanIMogIt:Print("Item removed: " .. itemLink .. " itemID: " .. itemID .. " sourceID: " .. sourceID .. " appearanceID: " .. appearanceID)
        end
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


local transmogEvents = {
    ["TRANSMOG_COLLECTION_SOURCE_ADDED"] = true,
    ["TRANSMOG_COLLECTION_SOURCE_REMOVED"] = true,
    ["TRANSMOG_COLLECTION_UPDATED"] = true,
}


local function TransmogCollectionUpdated(event, sourceID, ...)
    if transmogEvents[event] and sourceID then
        -- Get the appearanceID from the sourceID
        if event == "TRANSMOG_COLLECTION_SOURCE_ADDED" then
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            if itemLink and appearanceID then
                CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
            end
        elseif event == "TRANSMOG_COLLECTION_SOURCE_REMOVED" then
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            if itemLink and appearanceID then
                CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink)
            end
        end
        if sourceID then
            CanIMogIt.cache:RemoveItemBySourceID(sourceID)
        end
        CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
    end
end

CanIMogIt.frame:AddEventFunction(TransmogCollectionUpdated)

-- Sets --


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


local function OnLoginDatabaseEvents(event, ...)
    if event == "PLAYER_LOGIN" then
        CanIMogIt:UpdateDatabaseAppearances()
        CanIMogIt:GetSets()
    end
end
CanIMogIt.frame:AddEventFunction(OnLoginDatabaseEvents)
