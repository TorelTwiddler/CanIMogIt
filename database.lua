local L = CanIMogIt.L


local default = {
    global = {
        setItems = {}
    }
}


function CanIMogIt:OnInitialize()
    self.db = default
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
        CanIMogIt:GetSets()
    end
end
CanIMogIt.frame:AddSmartEvent(GetAppearancesEvent, {"PLAYER_LOGIN"})
