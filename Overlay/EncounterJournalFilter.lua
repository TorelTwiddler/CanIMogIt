-- Add a filter based on CIMI to Encounter Journal loot items

local CIMIFilterList = { 'EJFilter_All', 'EJFilter_Learnable', 'EJFilter_Unkonwn' }
local CIMIFilterMap = {
    EJFilter_All = {},
    EJFilter_Learnable = {
        [CanIMogIt.UNKNOWN] = true,
        [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = true,
        [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE] = true,
        [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_WARBOUND] = true,
        [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = true,
        [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = true,
        [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_WARBOUND] = true,
    },
    EJFilter_Unkonwn = {
        [CanIMogIt.UNKNOWN] = true,
    }
}
local CIMIFilterSelected = 'EJFilter_All'

local function ShouldShowLootItem(itemInfo)
    if CIMIFilterSelected == nil or CIMIFilterSelected == 'EJFilter_All' then
        return true
    elseif CIMIFilterMap[CIMIFilterSelected] then
        local text, unmodifiedText = CanIMogIt:GetTooltipText(itemInfo.link)
        return CIMIFilterMap[CIMIFilterSelected][unmodifiedText]
    end
        -- something goes wrong, keep show the item
        return true
end

-- create a new filtered loot item dataProvider
local function FilterLootItems(dataProvider)
    local newDataProvider = CreateDataProvider()
    newDataProvider.CIMI_Filtered = true
    dataProvider:ForEach(function(elementData)
        if elementData.itemInfo then
            if ShouldShowLootItem(elementData.itemInfo) then
                newDataProvider:Insert(elementData)
            end
        else
            -- keep headers, unknown and unprocessed
            newDataProvider:Insert(elementData)
        end
    end)
    return newDataProvider
end

-- in-place mutate the original loot items, won't add or remove any item, only add itemInfo to each item
local function ProcessLootItems(dataProvider)
    local allLootDataReceived = true
    dataProvider:ForEach(function(elementData)
        if elementData.header then
            return
        elseif elementData.itemInfo then
            return
        elseif elementData.index then
            local itemInfo = C_EncounterJournal.GetLootInfoByIndex(elementData.index)
            if itemInfo.link then
                elementData.itemInfo = itemInfo
            else
                -- incomplete itemInfo, wait next run triggered by EJ_LOOT_DATA_RECIEVED
                allLootDataReceived = false
            end
        end
    end)
    return allLootDataReceived
end

-- cache the original loot items
local cacheLootItemsDataProvider = nil

local function TryProcessLootItems(forceDone)
    local lootItemsScrollBox = EncounterJournalEncounterFrameInfo.LootContainer.ScrollBox
    if not cacheLootItemsDataProvider then return end
    if cacheLootItemsDataProvider.CIMI_Processed then return end

    local allLootDataReceived = ProcessLootItems(cacheLootItemsDataProvider)
    if allLootDataReceived or forceDone then
        cacheLootItemsDataProvider.CIMI_Processed = true
        lootItemsScrollBox:SetDataProvider(FilterLootItems(cacheLootItemsDataProvider))
    end
end

local lootItemsId = 0
local function GetNextLootItemId()
    lootItemsId = lootItemsId + 1
    return lootItemsId
end

-- based on the data set in EncounterJournal_LootUpdate()
local function BeginProcessLootItems()
    local lootItemsScrollBox = EncounterJournalEncounterFrameInfo.LootContainer.ScrollBox
    local dataProvider = lootItemsScrollBox:GetDataProvider()
    if not dataProvider then return end
    if dataProvider.CIMI_Filtered then return end

    -- a new and unfiltered list, cache it and try process
    cacheLootItemsDataProvider = dataProvider
    local thisLootItemsId = GetNextLootItemId()
    dataProvider.CIMI_LootItemsId = thisLootItemsId
    TryProcessLootItems()
    if not cacheLootItemsDataProvider.CIMI_Processed then
        -- add a timeout call to TryProcessLootItems
        C_Timer.After(2, function()
            local dataProvider = lootItemsScrollBox:GetDataProvider()
            if not dataProvider then return end
            if dataProvider.CIMI_Filtered then return end
            if dataProvider.CIMI_LootItemsId ~= thisLootItemsId then return end

            TryProcessLootItems(true)
        end, 2000)
    end
end

local function IsCIMIFilterSelected(selectedID)
    return CIMIFilterSelected == selectedID
end

local function SetCIMIFilterSelected(selectedID)
    CIMIFilterSelected = selectedID
    CanIMogItOptions.CIMIFilterSelected = selectedID
    if cacheLootItemsDataProvider and cacheLootItemsDataProvider.CIMI_Processed then
        local lootItemsScrollBox = EncounterJournalEncounterFrameInfo.LootContainer.ScrollBox
        lootItemsScrollBox:SetDataProvider(FilterLootItems(cacheLootItemsDataProvider))
    end
end

function SetupEncounterJournalFilter(encounterJournalLootFrame)
    CIMIFilterSelected = CanIMogItOptions.CIMIFilterSelected or 'EJFilter_All'

    encounterJournalLootFrame.ScrollBox:RegisterCallback("OnDataProviderReassigned", BeginProcessLootItems)

    CanIMogIt.frame:AddSmartEvent(TryProcessLootItems, {"EJ_LOOT_DATA_RECIEVED"})

    local CIMIFilter = CreateFrame("DropdownButton", "EncounterJournalCIMIFilter", encounterJournalLootFrame, "WowStyle1DropdownTemplate")
    encounterJournalLootFrame.CIMIFilter = CIMIFilter
    CIMIFilter:SetWidth(105)
    CIMIFilter:SetPoint("RIGHT", encounterJournalLootFrame.filter, "LEFT", -10, 0)
    CIMIFilter:SetupMenu(function(dropdown, rootDescription)
        local L = CanIMogIt.L
        rootDescription:SetTag("MENU_EJ_CIMI")
        for i, filter in ipairs(CIMIFilterList) do
            rootDescription:CreateRadio(L[filter], IsCIMIFilterSelected, SetCIMIFilterSelected, filter)
        end
    end)
end
