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
        appearances = {}
    }
}


function CanIMogIt:OnInitialize()
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
            print("nil subclass: " .. itemLink)
        end
    end
end


function CanIMogIt:DBHasItem(itemLink)
    local appearanceID, sourceID = self:GetAppearanceID(itemLink)
    if appearanceID == nil or sourceID == nil then return end
    return self:DBHasSource(appearanceID, sourceID)
end


-- CanIMogIt.sourceIDQueue = {}
-- local getItemInfoReceivedCount = 0


-- local function tablelength(T)
--     local count = 0
--     for _ in pairs(T) do count = count + 1 end
--     return count
-- end


-- function CanIMogIt.Database:UpdateAppearances()
--     --[[
--         Updates the database with the current appearances,
--         adding or removing as needed.
--     ]]
--     local appearances = CanIMogIt:GetAppearances()
--     for appearanceID, appearance in pairs(appearances) do
--         if appearance.isCollected then
--             self:AddAppearance(appearanceID)
--             self:AddAppearanceSources(appearanceID)
--         else
--             self:RemoveAppearance(appearanceID)
--         end
--     end
-- end


-- function CanIMogIt.Database:AddItemBySourceID(sourceID, appearanceID)
--     local itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
--     if string.find(itemLink, '|h%[%]|h') then -- still cooking
--         -- Call GetItemInfo here so that we can capture the event when it's done cooking.
--         GetItemInfo(itemLink)
--         CanIMogIt.sourceIDQueue[sourceID] = appearanceID
--         return
--     end
--     self:AddItem(itemLink, appearanceID)
-- end


-- function CanIMogIt.Database:AddAppearanceSources(appearanceID)
--     -- Adds the sources (the items) of the appearance to the database.
--     local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
--     if not sources then return end
--     for i, source in pairs(sources) do
--         if source.isCollected then
--             self:AddItemBySourceID(source.sourceID, appearanceID)
--         end
--     end
-- end


-- function CanIMogIt.Database:UpdateFromKnownSources(knownSources, appearanceID)
--     -- Updates the items given from knownSources.
--     for sourceID, source in pairs(knownSources) do
--         self:AddItemBySourceID(sourceID, appearanceID)
--     end
-- end


-- function CanIMogIt.Database:UpdateItem(itemLink, hasTransmogFromItem)
--     -- Updates the status of the item in the database.
--     if hasTransmogFromItem then
--         self:AddItem(itemLink)
--     else
--         self:RemoveItem(itemLink)
--         --[[ Need to update appearances in case the last item was 
--             removed from an appearanceTable]]
--         local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
--         if CanIMogItDatabase[appearanceID] and next(CanIMogItDatabase[appearanceID]) == nil then
--             -- if it's the last item in the appearanceTable, then remove the table.
--             CanIMogItDatabase[appearanceID] = nil
--         end
--     end
-- end


-- function CanIMogIt.Database:GetItemInfoReceived()
--     if next(CanIMogIt.sourceIDQueue) == nil then return end
--     -- Update the database with any items that were still cooking.
--     getItemInfoReceivedCount = getItemInfoReceivedCount + 1
--     if getItemInfoReceivedCount >= 300 or tablelength(CanIMogIt.sourceIDQueue) <= 300 then
--         getItemInfoReceivedCount = 0
--         local done = {}
--         for sourceID, appearanceID in pairs(CanIMogIt.sourceIDQueue) do
--             local itemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
--             if not string.find(itemLink, '|h%[%]|h') then
--                 -- Done cooking!
--                 Database:AddItem(itemLink, appearanceID)
--                 done[sourceID] = true
--             end
--         end
--         for sourceID, bool in pairs(done) do
--             CanIMogIt.sourceIDQueue[sourceID] = nil
--         end
--     end
-- end


function CanIMogIt.frame:PlayerLogin(event, ...)
    if event == "PLAYER_LOGIN" then
        -- add all known appearanceID's to the database
        CanIMogIt:GetAppearances()
    end
end


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
