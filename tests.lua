--[[
This file contains tests and diagnostic tools for CanIMogIt.

---------------------------------------------------------------------
Account-specific tests (only useful for the creator's accounts):
---------------------------------------------------------------------

The items here are always considered _not_ in your bags, so
they will not always match up to what may be in your bags.
For example, if an item is BoE normally, but you have it soulbound,
it will show as BoE here. It effectively means we don't include
the bind state in these tests.

/script CanIMogIt.Tests:RunTests("Adele")

or for verbose:
/script CanIMogIt.Tests:RunTests("Adele", true)

---------------------------------------------------------------------
General-purpose diagnostic tools (useful for any user):
---------------------------------------------------------------------

Print detailed diagnostic info about any item by ID or item link:
/script CanIMogIt.Tests:ItemInfo(35514)
/script CanIMogIt.Tests:ItemInfo(itemLink)

Scan all bag slots and report tooltip results (flags errors/nils):
/script CanIMogIt.Tests:ScanBags()

Verbose bag scan (prints result for every slot):
/script CanIMogIt.Tests:ScanBags(true)

Check whether overlay frames are attached to visible UI frames:
/script CanIMogIt.Tests:CheckFrames()
]]

CanIMogIt.Tests = {}

local testsAdele = {
    ["Learned"] = {
        ["itemID"] = 35514,
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Shirt"] = {
        ["itemID"] = 52019,
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Tabard"] = {
        ["itemID"] = 22999,
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Cosmetic"] = {
        ["itemID"] = 22206,
        ["expected"] = CanIMogIt.KNOWN_WARBOUND,
    },
    ["Not Learned"] = {
        ["itemID"] = 55325,
        ["expected"] = CanIMogIt.UNKNOWN,
    },
    ["Grey Item Not Learned"] = {
        ["itemID"] = 1820,
        ["expected"] = CanIMogIt.UNKNOWN,
    },
    ["Cannot learn: Classes: Name"] = {
        ["itemID"] = 98903,
        ["expected"] = CanIMogIt.UNKNOWABLE_BY_CHARACTER,
    },
    ["Learned from a Cosmetic source"] = {
        ["itemID"] = 6612,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
    },
    ["All sources not showing up in sources tooltip"] = {
        ["itemID"] = 116913,
        ["expected"] = CanIMogIt.NOT_TRANSMOGABLE,
    },
    ["Exception items (Cannot be learned, nil sourceID & appearanceID)"] = {
        ["itemID"] = 119556,
        ["expected"] = CanIMogIt.NOT_TRANSMOGABLE,
    },
    ["BoE: Learned from another item"] = {
        ["itemID"] = 25255,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
    },
    ["BoE: Learned for a different class"] = {
        ["itemID"] = 121224,
        ["expected"] = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE,
    },
    ["BoE: Learned for a different item and class"] = {
        ["itemID"] = 15229,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE,
    },
    ["BoE: Not Learned"] = {
        ["itemID"] = 2276,
        ["expected"] = CanIMogIt.UNKNOWN,
    },
    ["BoP: Learned for a different class"] = {
        ["itemID"] = 13346,
        ["expected"] = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER,
    },
    ["BoP: Learned for a different class and item"] = {
        ["itemID"] = 11924,
        ["expected"] = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER,
    },
    ["BoP: Cannot Learn"] = {
        ["itemID"] = 152145,
        ["expected"] = CanIMogIt.UNKNOWABLE_SOULBOUND,
    },
    ["BoP: Not Transmogable"] = {
        ["itemID"] = 116913,
        ["expected"] = CanIMogIt.NOT_TRANSMOGABLE,
    },
    ["WRB: Learned"] = {
        ["itemID"] = 118365,
        ["expected"] = CanIMogIt.KNOWN_WARBOUND,
    },
    ["WRB: Learned from another item"] = {
        ["itemID"] = 64644,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_WARBOUND,
    },
    ["WRB: Learned for a different class"] = {
        ["itemID"] = 141000,
        ["expected"] = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_WARBOUND,
    },
    ["WRB: Learned for a different class and item"] = {
        ["itemID"] = 69764,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_WARBOUND,
    },
    ["WRB: Cannot learn"] = {
        ["itemID"] = 128459,
        ["expected"] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_WARBOUND,
    },
}

local testsKamadyn = {
    ["Learned"] = {
        ["itemID"] = 204961,
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Learned Warbound item"] = {
        ["itemID"] = 219234,
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Cannot be learned"] = {
        ["itemID"] = 191352,
        ["expected"] = CanIMogIt.NOT_TRANSMOGABLE_BOE,
    }
}

local testsBriarlynn = {
    ["Cosmetic source Sage's Boots"] = {
        ["itemID"] = 6612,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
    },
    ["Cosmetic source Warm Blue Woolen Socks"] = {
        ["itemID"] = 116451,
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Warband item green instead of pink"] = {
        ["itemID"] = 69764,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_WARBOUND,
    },
    ["Cannot Learn: other faction, Frostwolf Leggings"] = {
        ["itemID"] = 128459,
        ["expected"] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_WARBOUND,
    },
    ["Warbound items hide with Transmogable Only on"] = {
        ["itemID"] = 220304,
        ["expected"] = CanIMogIt.NOT_TRANSMOGABLE_WARBOUND,
        ["textExpected"] = "",
        ["options"] = {
            ["showTransmoggableOnly"] = true,
        },
    },
}

local tests = {
    ["Adele"] = testsAdele,
    ["Kamadyn"] = testsKamadyn,
    ["Briarlynn"] = testsBriarlynn,
}


function CanIMogIt.Tests:RunTests(characterName, verbose)
    if characterName == nil then
        characterName = UnitName("player")
    end
    if verbose == nil then
        verbose = false
    end

    CanIMogIt:Print("Running tests for " .. characterName)
    local testsToRun = tests[characterName]
    if testsToRun == nil then
        print("No tests found for " .. characterName)
        return
    end

    local testResultsString = ""
    for testName, test in pairs(testsToRun) do
        local success = CanIMogIt.Tests:RunTest(testName, test, verbose)
        if success then
            testResultsString = testResultsString .. "."
            if verbose then
                print("-----")
            end
        else
            testResultsString = testResultsString .. "F"
            print("-----")
        end
    end
    print(testResultsString)
end

function CanIMogIt.Tests:RunTest(testName, test, verbose)
    if test.expected == nil or test.itemID == nil then
        print(CanIMogIt.BLIZZARD_RED .. "Test failed: " .. testName .. " [" .. tostring(test.itemID) .. "]")
        print("Invalid test data! Check the test in Lua.")
        return false
    end
    local itemName, itemLink = C_Item.GetItemInfo(test.itemID)
    if itemLink == nil then
        print(CanIMogIt.BLIZZARD_RED .. "Test failed: " .. testName .. " [" .. test.itemID .. "]")
        print("Item not found")
        return false
    end

    -- Set the options for the test
    if test.options ~= nil then
        CanIMogIt.Tests:SetOptions(test.options)
    end

    local status, text, unmodifiedText = pcall(CanIMogIt.GetTooltipText, CanIMogIt, itemLink)
    CanIMogIt.Tests:ResetOptions()
    if not status then
        print(CanIMogIt.BLIZZARD_RED .. "Test failed: " .. testName)
        print(itemLink, test.itemID)
        print("Error getting tooltip text")
        return false
    end

    if unmodifiedText == nil then
        print(CanIMogIt.BLIZZARD_RED .. "Test failed: " .. testName)
        print(itemLink, test.itemID)
        print("No tooltip text found")
        return false
    end

    if unmodifiedText ~= test.expected then
        print(CanIMogIt.BLIZZARD_RED .. "Test failed: " .. testName)
        print(itemLink, test.itemID)
        print("Expected: " .. test.expected)
        print("Got: " .. unmodifiedText)
        return false
    end

    if test.textExpected ~= nil and text ~= test.textExpected then
        print(CanIMogIt.BLIZZARD_RED .. "Test failed: " .. testName)
        print(itemLink, test.itemID)
        print("Text Expected: " .. test.textExpected)
        print("Text Got: " .. text)
        return false
    end
    if verbose then
        print(CanIMogIt.BLIZZARD_GREEN .. "Test succeeded: " .. testName)
        print(itemLink, test.itemID)
        print("Expected/Got: " .. test.expected)
    end
    return true
end


local currentOptions = {}

function CanIMogIt.Tests:SetOptions(options)
    for key, value in pairs(options) do
        currentOptions[key] = CanIMogItOptions[key]
        CanIMogItOptions[key] = value
    end
end

function CanIMogIt.Tests:ResetOptions()
    for key, value in pairs(currentOptions) do
        CanIMogItOptions[key] = value
    end
    currentOptions = {}
end


function CanIMogIt.Tests:EnableSkipTimer()
    CanIMogIt:Print("Skip Timer enabled")

    -- Function to round a number to a specified number of decimal places
    local function roundToDecimalPlaces(number, decimalPlaces)
        local multiplier = 10^decimalPlaces
        return math.floor(number * multiplier + 0.5) / multiplier
    end

    -- Create a frame to handle the OnUpdate event
    CanIMogIt.Tests.frame = CreateFrame("Frame")

    -- Variable to store the time of the last frame
    local lastTime = GetTime()

    -- Threshold for large frame time (in seconds)
    local threshold = 0.05  -- Example: 50 milliseconds

    -- OnUpdate event handler
    CanIMogIt.Tests.frame:SetScript("OnUpdate", function(self, elapsed)
        -- Get the current time
        local currentTime = GetTime()

        -- Calculate the time difference between frames
        local deltaTime = currentTime - lastTime

        -- Check if the time difference exceeds the threshold
        if deltaTime > threshold then
            local roundedDeltaTime = roundToDecimalPlaces(deltaTime, 3)
            print("Large frame time detected: " .. roundedDeltaTime .. " seconds")
        end

        -- Update the last time
        lastTime = currentTime
    end)
end

function CanIMogIt.Tests:DisableSkipTimer()
    CanIMogIt:Print("Skip Timer disabled")
    CanIMogIt.Tests.frame:SetScript("OnUpdate", nil)
    CanIMogIt.Tests.frame = nil
end

function CanIMogIt.Tests:ToggleSkipTimer()
    if CanIMogIt.Tests.frame then
        CanIMogIt.Tests:DisableSkipTimer()
    else
        CanIMogIt.Tests:EnableSkipTimer()
    end
end


---------------------------------------------------------------------
-- General-purpose diagnostic tools                               --
---------------------------------------------------------------------


function CanIMogIt.Tests:ItemInfo(itemIDOrLink)
    --[[
        Print comprehensive diagnostic information about an item to the chat
        window. Accepts either a numeric item ID or an item link string.

        Usage:
            /script CanIMogIt.Tests:ItemInfo(35514)
            /script CanIMogIt.Tests:ItemInfo(itemLink)
    ]]
    local itemLink
    if type(itemIDOrLink) == "number" then
        local _, link = C_Item.GetItemInfo(itemIDOrLink)
        if not link then
            print(CanIMogIt.BLIZZARD_RED .. "ItemInfo: item not found for ID " .. tostring(itemIDOrLink))
            return
        end
        itemLink = link
    else
        itemLink = itemIDOrLink
    end

    if not itemLink then
        print(CanIMogIt.BLIZZARD_RED .. "ItemInfo: invalid item link")
        return
    end

    print("=== CanIMogIt ItemInfo ===")
    print("Item: " .. tostring(itemLink))

    local itemID = CanIMogIt:GetItemID(itemLink)
    print("Item ID: " .. tostring(itemID))

    if itemID then
        local _, _, _, _, _, itemClass, itemSubClass, _, equipSlot, _, _, _, _, _, expansion =
            C_Item.GetItemInfo(itemID)
        print("Item class: " .. tostring(itemClass))
        print("Item subClass: " .. tostring(itemSubClass))
        print("Item equipSlot: " .. tostring(equipSlot))
        print("Item expansion: " .. tostring(expansion))
    end

    local sourceID, sourceIDSource = CanIMogIt:GetSourceID(itemLink)
    print("sourceID: " .. tostring(sourceID) .. " (via " .. tostring(sourceIDSource) .. ")")

    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    print("appearanceID: " .. tostring(appearanceID))

    local setID = CanIMogIt:SetsDBGetSetFromSourceID(sourceID) or "nil"
    print("setID: " .. tostring(setID))

    print("---")

    if sourceID then
        local isReady = select(1, C_TransmogCollection.PlayerCanCollectSource(sourceID))
        local canCollect = select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID))
        print("PlayerCanCollectSource (isReady): " .. tostring(isReady))
        print("PlayerCanCollectSource (canCollect): " .. tostring(canCollect))
    end

    if itemID then
        print("PlayerHasTransmog: " .. tostring(C_TransmogCollection.PlayerHasTransmog(itemID)))
    end

    if sourceID then
        print("PlayerHasTransmogItemModifiedAppearance: " ..
            tostring(C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)))
    end

    print("---")
    print("IsTransmogable: " .. tostring(CanIMogIt:IsTransmogable(itemLink)))
    print("PlayerKnowsTransmogFromItem: " .. tostring(CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)))
    print("PlayerKnowsTransmog: " .. tostring(CanIMogIt:PlayerKnowsTransmog(itemLink)))
    print("CharacterCanLearnTransmog: " .. tostring(CanIMogIt:CharacterCanLearnTransmog(itemLink)))
    print("IsItemSoulbound: " .. tostring(CanIMogIt:IsItemSoulbound(itemLink)))
    print("IsItemWarbound: " .. tostring(CanIMogIt:IsItemWarbound(itemLink)))

    local bindData = CanIMogIt.BindData:new(itemLink)
    print("BindType: " .. tostring(bindData and bindData.type or "nil"))

    print("IsValidAppearanceForCharacter: " .. tostring(CanIMogIt:IsValidAppearanceForCharacter(itemLink)))

    local classesRequired = CIMIScanTooltip:GetClassesRequired(itemLink)
    if classesRequired then
        print("Required Classes: " .. table.concat(classesRequired, ", "))
    else
        print("Required Classes: nil")
    end

    print("---")
    local text, unmodifiedText = CanIMogIt:GetTooltipText(itemLink)
    if unmodifiedText ~= nil then
        for key, value in pairs(CanIMogIt) do
            if type(value) == "string" and value == unmodifiedText then
                print("Matching Constant: " .. key)
                break
            end
        end
    end
    print("Tooltip result: " .. tostring(text))
    print("=========================")
end


function CanIMogIt.Tests:ScanBags(verbose)
    --[[
        Scan every slot in the player's bags and report the tooltip result
        computed by CanIMogIt. Errors and unexpected nil results are always
        printed; passing verbose=true also prints the result for every slot.

        Usage:
            /script CanIMogIt.Tests:ScanBags()
            /script CanIMogIt.Tests:ScanBags(true)
    ]]
    if verbose == nil then verbose = false end

    local totalSlots = 0
    local errorSlots = 0
    local nilSlots = 0

    print("=== CanIMogIt ScanBags ===")

    for bag = 0, NUM_BAG_SLOTS do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                totalSlots = totalSlots + 1
                local ok, text, unmodifiedText = pcall(CanIMogIt.GetTooltipText, CanIMogIt, itemLink, bag, slot)
                if not ok then
                    errorSlots = errorSlots + 1
                    print(CanIMogIt.BLIZZARD_RED .. "ERROR [bag=" .. bag .. " slot=" .. slot .. "] " .. tostring(itemLink))
                    print("  " .. tostring(text))
                elseif unmodifiedText == nil then
                    nilSlots = nilSlots + 1
                    if verbose then
                        print(CanIMogIt.BLIZZARD_YELLOW .. "NIL [bag=" .. bag .. " slot=" .. slot .. "] " .. tostring(itemLink))
                    end
                else
                    if verbose then
                        print("[bag=" .. bag .. " slot=" .. slot .. "] " .. tostring(itemLink) .. " => " .. tostring(unmodifiedText))
                    end
                end
            end
        end
    end

    print("Scanned: " .. totalSlots .. " items | Errors: " .. errorSlots .. " | Nil results: " .. nilSlots)
    print("=========================")
end


function CanIMogIt.Tests:CheckFrames()
    --[[
        Check whether CanIMogIt overlay frames are attached to visible UI
        frames. Reports the count of frames with and without overlays for
        each supported frame type that is currently visible.

        Usage:
            /script CanIMogIt.Tests:CheckFrames()
    ]]
    print("=== CanIMogIt CheckFrames ===")

    local function checkItemList(label, items)
        if not items or #items == 0 then return end
        local withOverlay = 0
        local withoutOverlay = 0
        for _, frame in ipairs(items) do
            if frame.CanIMogItOverlay then
                withOverlay = withOverlay + 1
            else
                withoutOverlay = withoutOverlay + 1
            end
        end
        local color = withoutOverlay == 0 and CanIMogIt.BLIZZARD_GREEN or CanIMogIt.BLIZZARD_YELLOW
        print(color .. label .. ": " .. withOverlay .. " with overlay, " .. withoutOverlay .. " without")
    end

    -- Combined bags
    local combinedBags = _G["ContainerFrameCombinedBags"]
    if combinedBags and combinedBags:IsVisible() then
        checkItemList("ContainerFrameCombinedBags", combinedBags.Items)
    end

    -- Separate bag frames
    local containerFrameContainer = _G["ContainerFrameContainer"]
    if containerFrameContainer and containerFrameContainer:IsVisible() then
        for _, bag in ipairs(containerFrameContainer.ContainerFrames) do
            if bag:IsVisible() then
                checkItemList("Bag: " .. (bag:GetName() or "unknown"), bag.Items)
            end
        end
    end

    -- Bank frame
    local bankFrame = _G["BankFrame"]
    if bankFrame and bankFrame:IsVisible() then
        local bankPanel = bankFrame.BankPanel
        if bankPanel then
            local bankFrames = {}
            for i = 1, CanIMogIt.NUM_BANK_ITEMS do
                local frame = bankPanel:FindItemButtonByContainerSlotID(i)
                if frame then
                    bankFrames[#bankFrames + 1] = frame
                end
            end
            checkItemList("BankFrame", bankFrames)
        end
    end

    -- Merchant frame
    local merchantFrame = _G["MerchantFrame"]
    if merchantFrame and merchantFrame:IsVisible() then
        local merchantFrames = {}
        for i = 1, MERCHANT_ITEMS_PER_PAGE do
            local frame = _G["MerchantItem" .. i .. "ItemButton"]
            if frame then
                merchantFrames[#merchantFrames + 1] = frame
            end
        end
        checkItemList("MerchantFrame", merchantFrames)
    end

    -- Guild bank
    local guildBankFrame = _G["GuildBankFrame"]
    if guildBankFrame and guildBankFrame:IsVisible() then
        local guildBankFrames = {}
        if guildBankFrame.Columns then
            for _, column in ipairs(guildBankFrame.Columns) do
                for _, frame in ipairs(column.Buttons) do
                    guildBankFrames[#guildBankFrames + 1] = frame
                end
            end
        end
        checkItemList("GuildBankFrame", guildBankFrames)
    end

    if not (
        (combinedBags and combinedBags:IsVisible()) or
        (containerFrameContainer and containerFrameContainer:IsVisible()) or
        (bankFrame and bankFrame:IsVisible()) or
        (merchantFrame and merchantFrame:IsVisible()) or
        (guildBankFrame and guildBankFrame:IsVisible())
    ) then
        print("No supported frames are currently visible.")
        print("Open your bags, bank, merchant, or guild bank and run again.")
    end

    print("============================")
end
