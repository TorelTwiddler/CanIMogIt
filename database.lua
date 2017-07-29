--[[
    global = {
        setItems = {
            sourceID = setID,
        }
    }
]]

local L = CanIMogIt.L


CanIMogIt_DatabaseVersion = 1.1


local default = {
    global = {
        setItems = {}
    }
}


function CanIMogIt:OnInitialize()
    if (not CanIMogItDatabase) then
        StaticPopup_Show("CANIMOGIT_NEW_DATABASE")
    end
    self.db = LibStub("AceDB-3.0"):New("CanIMogItDatabase", default)
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


function CanIMogIt.frame:DatabaseScanEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        CanIMogIt:GetSets()
    end
end