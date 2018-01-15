-- Overlay for quests.
-- Note that the Blizzard functions are "Quest" vs "QuestLog"


----------------------------
-- UpdateIcon functions   --
----------------------------


local function MapQuestFrameUpdateIcon(self)
    -- Updates the icons for the MapQuest Frame
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetQuestLogItemLink(self.rewardType, self.id)
    self.itemLink = itemLink
    if itemLink == nil then
        CIMI_SetIcon(self, MapQuestFrameUpdateIcon, nil)
    else
        CIMI_SetIcon(self, MapQuestFrameUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


local function QuestFrameUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetQuestItemLink(self.rewardType, self.id)
    self.itemLink = itemLink
    if itemLink == nil then
        CIMI_SetIcon(self, QuestFrameUpdateIcon, nil)
    else
        CIMI_SetIcon(self, QuestFrameUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


------------------------
-- Function hooks     --
------------------------


local function QuestOverlayOnClick()
    local numChoices = GetNumQuestLogChoices()
    local numRewards = GetNumQuestLogRewards()
    local totalRewards = numChoices + numRewards

    for i=1,totalRewards do
        local frame = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i]
        if frame then
            MapQuestFrameUpdateIcon(frame.CanIMogItOverlay)
        end
    end

    local numChoices = GetNumQuestChoices()
    local numRewards = GetNumQuestRewards()
    local totalRewards = numChoices + numRewards
    for i=1,totalRewards do
        local frame = _G["QuestInfoRewardsFrameQuestInfoItem"..i]
        if frame then
            QuestFrameUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function AddIndexInfoToCIMIFrame(cimiFrame, numChoices, index, doingChoices)
    -- Add the index of the frame, so we can reference it
    cimiFrame.id = index
    index = index + 1
    if doingChoices then
        cimiFrame.rewardType = "choice"
        if index > numChoices then
            index = 1
            doingChoices = false
        end
    else
        cimiFrame.rewardType = "reward"
    end
    return index, doingChoices
end


local function AddAndUpdateQuestFrames()
    -- Add to the Quest Frame, and update if added.
    local numChoices = GetNumQuestChoices()
    local numRewards = GetNumQuestRewards()
    local totalRewards = numChoices + numRewards

    local doingChoices = true
    local index = 1
    for i=1,totalRewards do
        local frame = _G["QuestInfoRewardsFrameQuestInfoItem"..i]
        if frame then
            local cimiFrame = CIMI_AddToFrame(frame, QuestFrameUpdateIcon)
            if frame.CanIMogItOverlay then
                index, doingChoices = AddIndexInfoToCIMIFrame(frame.CanIMogItOverlay,
                    numChoices, index, doingChoices)
                QuestFrameUpdateIcon(frame.CanIMogItOverlay)
            end
        end
    end
end


local function AddAndUpdateMapQuestFrames()
    -- Add to the MapQuest frames, and update if added.
    local numChoices = GetNumQuestLogChoices()
    local numRewards = GetNumQuestLogRewards()
    local totalRewards = numChoices + numRewards

    local doingChoices = true
    local index = 1
    for i=1,totalRewards do
        local frame = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i]
        if frame then
            local cimiFrame = CIMI_AddToFrame(frame, MapQuestFrameUpdateIcon)
            if frame.CanIMogItOverlay then
                index, doingChoices = AddIndexInfoToCIMIFrame(frame.CanIMogItOverlay,
                    numChoices, index, doingChoices)
                MapQuestFrameUpdateIcon(frame.CanIMogItOverlay)
            end
        end
    end
end


local function HookOverlayQuest(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for clicking on the Continue button in the
    -- quest frame (since there is no event).
    if _G["QuestInfoRewardsFrame"] then
        _G["QuestInfoRewardsFrame"]:HookScript("OnShow", AddAndUpdateQuestFrames)
    end
    if _G["MapQuestInfoRewardsFrame"] then
        _G["MapQuestInfoRewardsFrame"]:HookScript("OnShow", AddAndUpdateMapQuestFrames)
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayQuest)


------------------------
-- Event functions    --
------------------------

local function QuestOverlayEvents(event, ...)
    QuestOverlayOnClick()
end

CanIMogIt.frame:AddOverlayEventFunction(QuestOverlayEvents)
