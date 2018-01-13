-- Overlay for quests.


----------------------------
-- UpdateIcon functions   --
----------------------------


function QuestFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    -- http://wowprogramming.com/docs/api/GetQuestItemLink

    local itemLink = self:GetParent():GetParent().itemLink
    if itemLink == nil then
        CIMI_SetIcon(self, QuestFrame_CIMIUpdateIcon, nil)
    else
        CIMI_SetIcon(self, QuestFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


------------------------
-- Function hooks     --
------------------------


-- http://wowprogramming.com/docs/api/GetNumQuestLogChoices
-- http://wowprogramming.com/docs/api/GetNumQuestLogRewards

function QuestFrame_CIMIOnClick()
    for i=1,CanIMogIt.QUEST_INFO_REWARD_ITEMS do
        local frame = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i]
        if frame then
            QuestFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function HookOverlayMapQuest(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the Map Quest Log frames.
    for i=1,CanIMogIt.QUEST_INFO_REWARD_ITEMS do
        local frame = _G["MapQuestInfoRewardsFrameQuestInfoItem"..i]
        if frame then
            CIMI_AddToFrame(frame, QuestFrame_CIMIUpdateIcon)
        end
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayMapQuest)


------------------------
-- Event functions    --
------------------------

local function QuestOverlayEvents(event, ...)
    QuestFrame_CIMIOnClick()
end

CanIMogIt.frame:AddOverlayEventFunction(QuestOverlayEvents)
