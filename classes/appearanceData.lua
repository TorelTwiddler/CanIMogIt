CanIMogIt.AppearanceData = {}
CanIMogIt.AppearanceData.__index = CanIMogIt.AppearanceData


function CanIMogIt.AppearanceData:new(itemLink, playerKnowsTransmogFromItem, playerKnowsTransmog, isValidAppearanceForCharacter, characterCanLearnTransmog)
    if itemLink == nil
        or playerKnowsTransmogFromItem == nil
        or playerKnowsTransmog == nil
        or isValidAppearanceForCharacter == nil
        or characterCanLearnTransmog == nil then
        return nil
    end
    local this = setmetatable({}, CanIMogIt.AppearanceData)
    this.itemLink = itemLink
    this.key = CanIMogIt:CalculateKey(itemLink)
    this.playerKnowsTransmogFromItem = playerKnowsTransmogFromItem
    this.playerKnowsTransmog = playerKnowsTransmog
    this.isValidAppearanceForCharacter = isValidAppearanceForCharacter
    this.characterCanLearnTransmog = characterCanLearnTransmog
    this.status = this:CalculateKnownStatus()
    return this
end


function CanIMogIt.AppearanceData.FromItemLink(itemLink)
    if itemLink == nil then return end
    local playerKnowsTransmogFromItem = CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
    if playerKnowsTransmogFromItem == nil then return end
    local playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmog(itemLink)
    if playerKnowsTransmog == nil then return end
    local isValidAppearanceForCharacter = CanIMogIt:IsValidAppearanceForCharacter(itemLink)
    if isValidAppearanceForCharacter == nil then return end
    local characterCanLearnTransmog = CanIMogIt:CharacterCanLearnTransmog(itemLink)
    if characterCanLearnTransmog == nil then return end
    return CanIMogIt.AppearanceData:new(itemLink, playerKnowsTransmogFromItem, playerKnowsTransmog, isValidAppearanceForCharacter, characterCanLearnTransmog)
end


function CanIMogIt.AppearanceData:CalculateKnownStatus()
    local status
    if self.playerKnowsTransmogFromItem then
        if self.isValidAppearanceForCharacter then
            -- The player knows the appearance from this item
            -- and the character can transmog it.
            status = CanIMogIt.KNOWN
        else
            -- The player knows the appearance from this item, but
            -- the character can't use this appearance.
            status = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
        end
    -- Does the player know the appearance from a different item?
    elseif self.playerKnowsTransmog then
        if self.isValidAppearanceForCharacter then
            -- The player knows the appearance from another item, and
            -- the character can use it.
            status = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
        else
            -- The player knows the appearance from another item, but
            -- this character can never use/learn the appearance.
            status = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
        end
    else
        if self.characterCanLearnTransmog then
            -- The player does not know the appearance and the character
            -- can learn this appearance.
            status = CanIMogIt.UNKNOWN
        else
            -- Warbound shouldn't be possible in this state.
            status = CanIMogIt.UNKNOWABLE_BY_CHARACTER
        end
    end
    return status
end

function CanIMogIt.AppearanceData:CalculateBindStateText(bindData)
    local isItemWarbound = bindData.type == CanIMogIt.BindTypes.Warbound
    local isItemSoulbound = bindData.type == CanIMogIt.BindTypes.Soulbound
    local text, unmodifiedText;
    if self.status == CanIMogIt.KNOWN then
        if isItemWarbound then
            -- Pink Check
            text = CanIMogIt.KNOWN_WARBOUND
            unmodifiedText = CanIMogIt.KNOWN_WARBOUND
        elseif isItemSoulbound then
            -- Blue Check
            text = CanIMogIt.KNOWN
            unmodifiedText = CanIMogIt.KNOWN
        else -- BoE
            -- Yellow Check
            text = CanIMogIt.KNOWN_BOE
            unmodifiedText = CanIMogIt.KNOWN_BOE
        end
    elseif self.status == CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER then
        if isItemWarbound then
            -- Pink Check
            text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_WARBOUND
            unmodifiedText = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_WARBOUND
        elseif isItemSoulbound then
            -- Green Check
            text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
            unmodifiedText = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
        else -- BoE
            -- Yellow Check
            text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE
            unmodifiedText = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE
        end
    elseif self.status == CanIMogIt.KNOWN_FROM_ANOTHER_ITEM then
        if isItemWarbound then
            -- Pink Circle Check
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_WARBOUND
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_WARBOUND
        elseif isItemSoulbound then
            -- Blue Circle Check
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
        else -- BoE
            -- Yellow Circle Check
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE
        end
    elseif self.status == CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER then
        if isItemWarbound then
            -- Pink Circle Check
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_WARBOUND
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_WARBOUND
        elseif isItemSoulbound then
            -- Green Circle Check
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
        else -- BoE
            -- Yellow Circle Check
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
        end
    elseif self.status == CanIMogIt.UNKNOWN then
        -- Orange X
        text = CanIMogIt.UNKNOWN
        unmodifiedText = CanIMogIt.UNKNOWN
    elseif self.status == CanIMogIt.UNKNOWABLE_BY_CHARACTER then
        if isItemWarbound then
            -- Pink Star
            text = CanIMogIt.UNKNOWABLE_BY_CHARACTER_WARBOUND
                    .. CanIMogIt.BLIZZARD_RED .. CanIMogIt:GetReason(self.itemLink)
            unmodifiedText = CanIMogIt.UNKNOWABLE_BY_CHARACTER_WARBOUND
        elseif isItemSoulbound then
            -- Green Dash
            text = CanIMogIt.UNKNOWABLE_SOULBOUND
                    .. CanIMogIt.BLIZZARD_RED .. CanIMogIt:GetReason(self.itemLink)
            unmodifiedText = CanIMogIt.UNKNOWABLE_SOULBOUND
        else
            -- Yellow Star
            text = CanIMogIt.UNKNOWABLE_BY_CHARACTER
                    .. CanIMogIt.BLIZZARD_RED .. CanIMogIt:GetReason(self.itemLink)
            unmodifiedText = CanIMogIt.UNKNOWABLE_BY_CHARACTER
        end
    end
    return text, unmodifiedText
end
