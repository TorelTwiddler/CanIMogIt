--[[
This file contains tests explicitly for the creator's accounts.
This won't work for anyone else, due to requiring your account
to be in a certain state.

The items here are always considered _not_ in your bags, so
they will not always match up to what may be in your bags.
For example, if an item is BoE normally, but you have it soulbound,
it will show as BoE here. It effectively means we don't include
the bind state in these tests.

To use:

/script CanIMogIt.Tests:RunTests("Adele")

or for verbose:
/script CanIMogIt.Tests:RunTests("Adele", true)
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
