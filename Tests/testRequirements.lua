
local function TestGetRequirements()
    requirements = CanIMogIt.Requirements:GetRequirements()
    assert(requirements["classRestrictions"] == select(1, UnitClass('player')))
end


local function RequirementsTests()
    CanIMogIt:Print("Running Requirements tests...")
    TestGetRequirements()
end


CanIMogIt.Tests:AddTest('requirements', RequirementsTests)
