CanIMogIt.Tests = {
    tests={}
}

function CanIMogIt.Tests:AddTest(name, testFunction)
    -- Add a new test to the test suite
    self.tests[name] = testFunction
end


function CanIMogIt.Tests:RunTests()
    -- Run all of the tests.
    CanIMogIt:Print("Running Tests...")
    for name, testFunction in pairs(self.tests) do
        testFunction()
    end
    CanIMogIt:Print("Tests ran successfully!")
end

function CanIMogIt.Tests:ForPlayer(player_name)
    return select(1, UnitName("player")) == player_name
end
