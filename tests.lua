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
        ["expected"] = CanIMogIt.KNOWN,
    },
    ["Not Learned"] = {
        ["itemID"] = 55325,
        ["expected"] = CanIMogIt.UNKNOWN,
    },
    ["Grey Item Not Learned"] = {
        ["itemID"] = 121341,
        ["expected"] = CanIMogIt.UNKNOWN,
    },
    ["Cannot learn: Classes: Name"] = {
        ["itemID"] = 19148,
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
        ["expected"] = CanIMogIt.KNOWN_BOE,
    },
    ["BoE: Learned for a different item and class"] = {
        ["itemID"] = 15229,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
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
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    },
    ["BoP: Cannot Learn"] = {
        ["itemID"] = 59177,
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
        ["expected"] = CanIMogIt.KNOWN_WARBOUND,
    },
    ["WRB: Learned for a different class and item"] = {
        ["itemID"] = 69764,
        ["expected"] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_WARBOUND,
    },
    ["WRB: Cannot learn"] = {
        ["itemID"] = 128459,
        ["expected"] = CanIMogIt.NOT_TRANSMOGABLE_WARBOUND,
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
    local text, unmodifiedText = CanIMogIt:GetTooltipText(itemLink)
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
    if verbose then
        print(CanIMogIt.BLIZZARD_GREEN .. "Test succeeded: " .. testName)
        print(itemLink, test.itemID)
        print("Expected/Got: " .. test.expected)
    end
    return true
end
