-- Overlay for quests.
-- Note that the Blizzard functions are "Quest" vs "QuestLog"


local questInfoRewardsFrame = _G["QuestInfoRewardsFrame"]

local function GetItemLinkForQuests(rewardType, id)
    -- Gets the item link for the currently selected quest.
    -- rewardType is either "choice" or "reward"
    -- id is the ID of the reward button frame.
    local questInfoFrame = _G["QuestInfoFrame"]
    if questInfoFrame.questLog then
        return GetQuestLogItemLink(rewardType, id)
    else
        return GetQuestItemLink(rewardType, id)
    end
end


local function GetRewardButtons()
    -- Gets the reward buttons that the CIMI frame is attached to.
    local questInfoFrame = _G["QuestInfoFrame"]
    if questInfoFrame and questInfoFrame.rewardsFrame then
        return questInfoFrame.rewardsFrame.RewardButtons
    end
end

----------------------------
-- UpdateIcon functions   --
----------------------------


local function QuestFrameUpdateIcon(self)
    -- Updates the icons for the Quest Frame
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    if not self:IsVisible() then
        -- Don't do anything if frame isn't visible
        return
    elseif self.objectType ~= "item" then
        -- Remove icon if frame is not holding an item
        CIMI_SetIcon(self, QuestFrameUpdateIcon, nil)
    end

    local itemLink = GetItemLinkForQuests(self.rewardType, self.id)
    if itemLink == nil then
        CIMI_SetIcon(self, QuestFrameUpdateIcon, nil)
    else
        CIMI_SetIcon(self, QuestFrameUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function AddIndexInfoToCIMIFrame(cimiFrame, rewardButton)
    -- Save the index/ID of the frame, and if it is a choice or not, so we can reference it
    -- when figuring out the icon.
    cimiFrame.id = rewardButton:GetID()
    cimiFrame.rewardType = rewardButton.type
    cimiFrame.objectType = rewardButton.objectType
end


local function AddAndUpdateQuestFrames()
    -- Add to the Quest Frame, and update if added.
    -- Use QuestInfoRewardsFrameQuestInfoItem#, which has questID on it <-- old stand alone details frame
    -- Right-click on objectives quest for old stand alone frame
    local rewardButtons = GetRewardButtons()
    if rewardButtons then
        for _, rewardButton in ipairs(rewardButtons) do
            if rewardButton then
                CIMI_AddToFrame(rewardButton, QuestFrameUpdateIcon, nil, "TOPRIGHT")
                if rewardButton.CanIMogItOverlay then
                    AddIndexInfoToCIMIFrame(rewardButton.CanIMogItOverlay, rewardButton)
                    QuestFrameUpdateIcon(rewardButton.CanIMogItOverlay)
                end
            end
        end
    end
end


local function HookOverlayQuest(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Hook for opening the Quest Log and clicking on the Continue button in quest frame
    if questInfoRewardsFrame then
        questInfoRewardsFrame:HookScript("OnShow", function () AddAndUpdateQuestFrames() end)
    end

    -- Hook for when quest is clicked in the Quest Log
    if (_G["QuestLogListScrollFrame"]) then
        local children = {_G["QuestLogListScrollFrame"].ScrollChild:GetChildren()}
        for i, button in ipairs(children) do
            button:HookScript("OnClick", function(self)
                if self.isHeader then return end -- Ignore header buttons
                AddAndUpdateQuestFrames()
            end)
        end
    end
end

CanIMogIt.eventFrame:AddSmartEvent(HookOverlayQuest, {"PLAYER_LOGIN"})


------------------------
-- Event functions    --
------------------------

-- Triggers when clicking a quest in the Quest Tracker
local function HookQuestLogUpdate(event)
    if event ~= "QUEST_LOG_UPDATE" then return end
    if not questInfoRewardsFrame:IsVisible() then return end -- Don't update if we can't see the frame
    AddAndUpdateQuestFrames()
end
CanIMogIt.eventFrame:AddSmartEvent(HookQuestLogUpdate, {"QUEST_LOG_UPDATE"})


-- Fires when any CIMI option is updated
local function OptionUpdateListener(event, ...)
    local rewardButtons = GetRewardButtons()
    if rewardButtons then
        for _, rewardButton in ipairs(rewardButtons) do
            if rewardButton then
                QuestFrameUpdateIcon(rewardButton.CanIMogItOverlay)
            end
        end
    end
end
CanIMogIt:RegisterMessage("OptionUpdate", OptionUpdateListener)
