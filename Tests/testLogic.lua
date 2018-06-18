
local function TestItemKnownForDifferentClass()
    --[[
        #185 Test that an appearance know by a specific class doesn't cause
        all classes to show that appearance as known.

        Sources 44549 and 46684 share an appearance.
        86651 (source 44549) is Druid only, and is known.
        89957 (source 46684) is not class restricted, and is unknown.
    ]]

    -- The known Druid item
    assert(CanIMogIt:PlayerKnowsTransmogFromItem(CanIMogIt:GetItemLinkFromSourceID(44549)) == true)

    if CanIMogIt.Tests:ForPlayer("Konayuki") then
        -- Monk doesn't know generic item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(46684)) == false)
    end

    if CanIMogIt.Tests:ForPlayer("Euclid") then
        -- Druid knows generic item (for different class)
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(46684)) == true)
    end
end

local function TestPlayerKnowsTransmogGeneric()
    if CanIMogIt.Tests:ForPlayer("Riemann") then
        -- Rogue knows known rogue item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(88588)) == true)
        -- Rogue knows known druid item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(88276)) == true)
        -- Rogue knows rogue version of monk item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(88766)) == true)
    end

    if CanIMogIt.Tests:ForPlayer("Konayuki") then
        -- Monk doesn't know rogue item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(88588)) == false)
        -- Monk doesn't know druid item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(88276)) == false)
        -- Monk doesn't know unknown druid item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(88766)) == false)
        -- Monk knows monk item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(79817)) == true)
        -- Monk knows non-monk item
        assert(CanIMogIt:PlayerKnowsTransmog(CanIMogIt:GetItemLinkFromSourceID(80509)) == true)
    end
end

local function TestPlayerKnowsTransmog()
    TestItemKnownForDifferentClass()
    TestPlayerKnowsTransmogGeneric()
end


local function LogicTests(account)
    CanIMogIt:Print("Running Logic tests...")
    TestPlayerKnowsTransmog()
end


CanIMogIt.Tests:AddTest('logic', LogicTests)
