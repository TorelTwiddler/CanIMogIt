
local function TestDBHasAppearanceForRequirements()
    assert(CanIMogIt:DBHasAppearance(9776, "item:38666") == true)

    -- Get appearance from generic version of item (when there is some restriction on an item)
    assert(CanIMogIt:DBHasAppearanceForRequirements(9776, "item:38666", {classRestrictions="Death"}))
    assert(CanIMogIt:DBHasAppearanceForRequirements(9776, "item:38666", {classRestrictions="Paladin"}))
    assert(CanIMogIt:DBHasAppearanceForRequirements(9776, "item:157564", {classRestrictions="Paladin"}))

    -- Get appearance from restricted only items
    assert(CanIMogIt:DBHasAppearanceForRequirements(35441, "item:149680", {classRestrictions="Monk"}))
    assert(CanIMogIt:DBHasAppearanceForRequirements(35441, "item:149680", {classRestrictions="Druid"}))
    -- Same, but not collected yet on Rogue
    assert(not CanIMogIt:DBHasAppearanceForRequirements(35441, "item:149680", {classRestrictions="Rogue"}))
end


local function DatabaseTests()
    CanIMogIt:Print("Running Database tests...")
    TestDBHasAppearanceForRequirements()
end


CanIMogIt.Tests:AddTest('database', DatabaseTests)
