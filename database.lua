--[[
    The database has the following structure:
    {
        [appearanceID] = {
            [itemLink] = true,
        },
    }

    It is updated at the following events:
        Character is logged on.
        The Transmog collection is updated.
]]

local L = CanIMogIt.L

local Database = {}
CanIMogIt.Database = Database

CanIMogIt.sourceIDQueue = {}
local getItemInfoReceivedCount = 0


local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function Database:AddItem(itemLink, appearanceID)
    --[[ 
        Adds the given itemLink to the database. Returns whether it was added or not.
        Will use the given appearanceID if passed, instead of recalculating.
    ]]
    appearanceID = appearanceID or CanIMogIt:GetAppearanceID(itemLink)
    if not appearanceID then return false end
    local appearanceTable = CanIMogItDatabase[appearanceID]
    if not appearanceTable then
        appearanceTable = self:AddAppearance(appearanceID)
    end
    if not appearanceTable[itemLink] then
        appearanceTable[itemLink] = true
        return true
    end
    return false
end


function Database:AddAppearance(appearanceID)
    --[[
        Adds the appearanceID to the database if it's not there already. 
        Returns the appearanceTable if it was created, false otherwise.
    ]] 
    if not appearanceID then return false end
    if not CanIMogItDatabase[appearanceID] then
        local appearanceTable = {}
        CanIMogItDatabase[appearanceID] = appearanceTable
        return appearanceTable
    end
    return false
end


function Database:RemoveItem(itemLink)
    -- Removes the item from the database.
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    if not appearanceID then return false end
    local appearanceTable = CanIMogItDatabase[appearanceID]
    if appearanceTable and appearanceTable[itemLink] then
        appearanceTable[itemLink] = nil
        return true
    end
    return false
end


function Database:RemoveAppearance(appearanceID)
    --[[
        Removes the appearanceID from the database. Returns whether
        it was removed or not.
    ]]
    if CanIMogItDatabase[appearanceID] then
        CanIMogItDatabase[appearanceID] = nil
        return true
    end
    return false
end


function Database:GetAppearanceTable(itemLink)
    -- Returns the appearance table for the item in the database.
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    return CanIMogItDatabase[appearanceID]
end


function Database:GetItem(itemLink)
    -- Returns whether the item is in the database.
    local appearanceTable = Database:GetAppearanceTable(itemLink)
    if appearanceTable then
        return appearanceTable[itemLink] or false
    end
    return false
end


function Database:UpdateAppearances()
    --[[
        Updates the database with the current appearances,
        adding or removing as needed.
    ]]
    local appearances = CanIMogIt:GetAppearances()
    for appearanceID, appearance in pairs(appearances) do
        if appearance.isCollected then
            self:AddAppearance(appearanceID)
            self:AddAppearanceSources(appearanceID)
        else
            self:RemoveAppearance(appearanceID)
        end
    end
end


function Database:AddItemBySourceID(sourceID, appearanceID)
    local itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
    if string.find(itemLink, '|h%[%]|h') then -- still cooking
        -- Call GetItemInfo here so that we can capture the event when it's done cooking.
        GetItemInfo(itemLink)
        CanIMogIt.sourceIDQueue[sourceID] = appearanceID
        return
    end
    self:AddItem(itemLink, appearanceID)
end


function Database:AddAppearanceSources(appearanceID)
    -- Adds the sources (the items) of the appearance to the database.
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    if not sources then return end
    for i, source in pairs(sources) do
        if source.isCollected then
            self:AddItemBySourceID(source.sourceID, appearanceID)
        end
    end
end


function Database:UpdateFromKnownSources(knownSources, appearanceID)
    -- Updates the items given from knownSources.
    for sourceID, source in pairs(knownSources) do
        self:AddItemBySourceID(sourceID, appearanceID)
    end
end


function Database:UpdateItem(itemLink, hasTransmogFromItem)
    -- Updates the status of the item in the database.
    if hasTransmogFromItem then
        self:AddItem(itemLink)
    else
        self:RemoveItem(itemLink)
        --[[ Need to update appearances in case the last item was 
            removed from an appearanceTable]]
        local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
        if CanIMogItDatabase[appearanceID] and next(CanIMogItDatabase[appearanceID]) == nil then
            -- if it's the last item in the appearanceTable, then remove the table.
            CanIMogItDatabase[appearanceID] = nil
        end
    end
end


function Database:GetItemInfoReceived()
    if next(CanIMogIt.sourceIDQueue) == nil then return end
    -- Update the database with any items that were still cooking.
    getItemInfoReceivedCount = getItemInfoReceivedCount + 1
    if getItemInfoReceivedCount >= 300 or tablelength(CanIMogIt.sourceIDQueue) <= 300 then
        getItemInfoReceivedCount = 0
        local done = {}
        for sourceID, appearanceID in pairs(CanIMogIt.sourceIDQueue) do
            local itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
            if not string.find(itemLink, '|h%[%]|h') then
                -- Done cooking!
                Database:AddItem(itemLink, appearanceID)
                done[sourceID] = true
            end
        end
        for sourceID, bool in pairs(done) do
            CanIMogIt.sourceIDQueue[sourceID] = nil
        end
    end
end


-- function CanIMogIt.frame:PlayerLogin(event, ...)
--     if event == "PLAYER_LOGIN" then
--         -- add all known appearanceID's to the database
--         Database:UpdateAppearances()
--     end
-- end


-- function CanIMogIt.frame:TransmogCollectionUpdated(event, ...)
--     if event == "TRANSMOG_COLLECTION_UPDATED" then
--         -- add the equipment slot that was changed to the database
--         Database:UpdateAppearances()
--     end
-- end


-- function CanIMogIt.frame:GetItemInfoReceived(event, ...)
--     if event ~= "GET_ITEM_INFO_RECEIVED" then return end
--     Database:GetItemInfoReceived()
-- end
