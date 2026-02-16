-- Options for CanIMogIt
--
-- Thanks to Stanzilla and Semlar and their addon AdvancedInterfaceOptions, which I used as reference.

local _G = _G
local L = CanIMogIt.L

local CREATE_DATABASE_TEXT = L["Can I Mog It? Important Message: Please log into all of your characters to compile complete transmog appearance data."]

StaticPopupDialogs["CANIMOGIT_NEW_DATABASE"] = {
    text = CREATE_DATABASE_TEXT,
    button1 = L["Okay, I'll go log onto all of my toons!"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


local DATABASE_MIGRATION = "Can I Mog It?" .. "\n\n" .. L["We need to update our database. This may freeze the game for a few seconds."]


function CanIMogIt.CreateMigrationPopup(dialogName, onAcceptFunc)
    StaticPopupDialogs[dialogName] = {
        text = DATABASE_MIGRATION,
        button1 = L["Okay"],
        button2 = L["Ask me later"],
        OnAccept = onAcceptFunc,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }
    StaticPopup_Show(dialogName)
end


-- OptionsVersion: Keep this as an integer, so comparison is easy.
CanIMogIt_OptionsVersion = "26"


CanIMogItOptions_Defaults = {
    ["options"] = {
        ["version"] = CanIMogIt_OptionsVersion,
        ["debug"] = false,
        ["databaseDebug"] = false,
        ["showUnequippable"] = false,
        ["showNonTransmoggable"] = false,
        ["showUnknownOnly"] = false,
        ["showSetInfo"] = true,
        ["showItemIconOverlay"] = true,
        ["showVerboseText"] = false,
        ["showSourceLocationTooltip"] = false,
        ["iconLocation"] = "TOPRIGHT",
        ["showToyItems"] = true,
        ["showPetItems"] = true,
        ["showMountItems"] = true,
        ["showCatalizableItems"] = true,
        ["showEnsembleItems"] = true,
    },
}


local basic_options = {
    {
        type = "label",
        text = L["Basic Options"],
        size = 16,
    },
    {
        type = "checkbox",
        label = L["Debug Tooltip"],
        var = "debug",
        description = L["Detailed information for debug purposes. Use this when sending bug reports."],
    },
    {
        type = "checkbox",
        label = L["Show on unequippable items"],
        var = "showUnequippable",
        description = L["Show on items that cannot be equipped. For example, hearthstones, quest items, etc."] .. "\n\n" .. L["Please note that if this is disabled, the overlay will still show on items that are not equippable but are toys, mounts, pets, etc, if their respective options are enabled."],
    },
    {
        type = "checkbox",
        label = L["Show on Items that are not transmoggable"],
        var = "showNonTransmoggable",
        description = L["Show on items that are not transmoggable. For example, trinkets, rings, etc."] .. "\n\n" .. L["Please note that if this is disabled, the overlay will still show on items that are not transmoggable but are toys, mounts, pets, etc, if their respective options are enabled."],
    },
    {
        type = "checkbox",
        label = L["Unknown Items Only"],
        var = "showUnknownOnly",
        description = L["Only show on items that you haven't learned."],
    },
    {
        type = "checkbox",
        label = L["Show Transmog Set Info"],
        var = "showSetInfo",
        description = L["Show information on the tooltip about transmog sets."] .. "\n\n" .. L["Also shows a summary in the Appearance Sets UI of how many pieces of a transmog set you have collected."],
    },
    {
        type = "checkbox",
        label = L["Show Bag Icons"],
        var = "showItemIconOverlay",
        description = L["Shows the icon directly on the item in your bag."],
    },
    {
        type = "checkbox",
        label = L["Verbose Text"],
        var = "showVerboseText",
        description = L["Shows a more detailed text for some of the tooltips."],
    },
    {
        type = "checkbox",
        label = L["Show Source Location Tooltip"],
        var = "showSourceLocationTooltip",
        description = L["Shows a tooltip with the source locations of an appearance (ie. Quest, Vendor, World Drop). This only works on items your current class can learn."] .. "\n\n" .. L["Please note that this may not always be correct as Blizzard's information is incomplete."],
    },
    {
        type = "radiogrid",
        var = "iconLocation",
        description = L["Move the icon to a different location on all frames."],
    },
}

local toggle_options = {
    {
        type = "label",
        text = L["Toggle Options"],
        size = 16,
    },
    {
        type = "checkbox",
        label = L["Show Toy Items"],
        var = "showToyItems",
        description = L["Show tooltips and overlays on toys (otherwise, shows as not transmoggable)."],
    },
    {
        type = "checkbox",
        label = L["Show Pet Items"],
        var = "showPetItems",
        description = L["Show tooltips and overlays on pets (otherwise, shows as not transmoggable)."],
    },
    {
        type = "checkbox",
        label = L["Show Mount Items"],
        var = "showMountItems",
        description = L["Show tooltips and overlays on mounts (otherwise, shows as not transmoggable)."],
    },
    {
        type = "checkbox",
        label = L["Show Catalizable Items"],
        var = "showCatalizableItems",
        description = L["Show extra tooltip for items that can be catalyzed."],
    },
    {
        type = "checkbox",
        label = L["Show Ensemble Items"],
        var = "showEnsembleItems",
        description = L["Show tooltips and overlays on Ensemble Items (otherwise, shows as not transmoggable)."],
    },
}

local options_ui = {
    type = "box",
    direction = "horizontal",
    fill = true,
    children = {
        {
            type = "box",
            direction = "vertical",
            outline = true,
            width = 325,
            height = 580,
            children = basic_options,
        },
        {
            type = "box",
            direction = "vertical",
            outline = true,
            width = 325,
            height = 580,
            children = toggle_options,
        }
    },
}


CanIMogIt.frame = CreateFrame("Frame", "CanIMogItOptionsFrame", InterfaceOptionsFramePanelContainer);
CanIMogIt.frame.name = "Can I Mog It?";
local category = Settings.RegisterCanvasLayoutCategory(CanIMogIt.frame, CanIMogIt.frame.name)
CanIMogIt.settingsCategory = category
Settings.RegisterAddOnCategory(category)

local changesSavedStack = {}


local function changesSavedText()
    local frame = CreateFrame("Frame", "CanIMogIt_ChangesSaved", CanIMogIt.frame)
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetJustifyH("RIGHT")
    text:SetText(CanIMogIt.YELLOW .. L["Changes saved!"])

    text:SetAllPoints()

    frame:SetPoint("BOTTOMRIGHT", -20, 0)
    frame:SetSize(200, 20)
    frame:SetShown(false)
    CanIMogIt.frame.changesSavedText = frame
end


local function hideChangesSaved()
    table.remove(changesSavedStack, #changesSavedStack)
    if #changesSavedStack == 0 then
        CanIMogIt.frame.changesSavedText:SetShown(false)
    end
end


local function showChangesSaved()
    CanIMogIt.frame.changesSavedText:SetShown(true)
    table.insert(changesSavedStack, #changesSavedStack + 1)
    C_Timer.After(5, function () hideChangesSaved() end)
end


local function DrawCheckbox(parent, element)
    local checkbox = CreateFrame("CheckButton", "CanIMogItCheckbox_" .. element.var,
            parent, "InterfaceOptionsCheckButtonTemplate")

    -- Get and set value functions
    checkbox.GetValue = function(self)
        return CanIMogItOptions[element.var]
    end
    checkbox.SetValue = function(self, value)
        CanIMogItOptions[element.var] = value
    end

    -- Set up click handler
    checkbox:SetScript("OnClick", function(self)
        local new_value = not self:GetValue()
        PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        self:SetValue(new_value)
        showChangesSaved()
        CanIMogIt:ResetCache()
        CanIMogIt:SendMessage("OptionUpdate")
    end)

    checkbox:SetChecked(checkbox:GetValue())

    -- Set label and tooltip
    checkbox.label = _G[checkbox:GetName() .. "Text"]
    if checkbox.label then
        checkbox.label:SetText(element.label or "")
    end

    checkbox.tooltipText = element.label or ""
    checkbox.tooltipRequirement = element.description or ""

    -- Set up tooltip handlers for consistent behavior
    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltipText, 1, 1, 1)
        if self.tooltipRequirement and self.tooltipRequirement ~= "" then
            GameTooltip:AddLine(self.tooltipRequirement, 1, 1, 0, true)
        end
        GameTooltip:Show()
    end)

    checkbox:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Store reference for later positioning
    element._frame = checkbox

    -- Store frame reference on CanIMogIt.frame for slash command access
    CanIMogIt.frame[element.var] = checkbox

    return checkbox
end


local function DrawLabel(parent, element)
    local label = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    label:SetText(element.text or "")
    label:SetJustifyH("LEFT")

    if element.size then
        -- Create appropriate font string based on size
        local fontPath = "GameFontHighlight"
        if element.size < 12 then
            fontPath = "GameFontHighlightSmall"
        elseif element.size > 14 then
            fontPath = "GameFontHighlightLarge"
        end
        label:SetFontObject(fontPath)
    end

    label:SetSize(600, 20)

    -- Set tooltip if description exists
    if element.description then
        label.tooltipText = element.text or ""
        label.tooltipRequirement = element.description
    end

    -- Store reference for later positioning
    element._frame = label

    return label
end


local function DrawSlider(parent, element)
    -- Mock implementation for now
    print("DrawSlider not yet implemented for: " .. (element.label or "unnamed slider"))
end

local function DrawRadioGrid(parent, element)
    local variableName = element.var
    local frameName = "CanIMogItRadioGrid_" .. variableName
    local frame = CreateFrame("Frame", frameName, parent)
    frame:SetSize(600, 95)

    -- Create texture preview
    local textureFrame = CreateFrame("Frame", frameName .. "_Texture", frame)
    textureFrame:SetSize(58, 58)
    local texture = textureFrame:CreateTexture("CanIMogItRadioTexture", "BACKGROUND")
    texture:SetTexture("Interface/ICONS/INV_Sword_1H_AllianceToy_A_01.blp")
    texture:SetAllPoints()
    texture:SetVertexColor(0.5, 0.5, 0.5)

    -- Create reload button
    local reloadButton = CreateFrame("Button", frameName .. "_ReloadButton", frame, "UIPanelButtonTemplate")
    reloadButton:SetText(L["Reload to apply"])
    reloadButton:SetSize(120, 25)
    reloadButton:SetEnabled(false)
    reloadButton:SetScript("OnClick", function() ReloadUI() end)

    -- Create title
    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    title:SetText(L["Icon Location"])

    -- Create description text
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text:SetText(L["Does not affect Quests or Adventure Journal."])

    local text2 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text2:SetText(L["Default"] .. ": " .. L["Top Right"])

    -- Create 9 radio buttons for 3x3 grid
    local radioTopLeft = CreateFrame("CheckButton", frameName .. "_TopLeft", frame, "UIRadioButtonTemplate")
    local radioTop = CreateFrame("CheckButton", frameName .. "_Top", frame, "UIRadioButtonTemplate")
    local radioTopRight = CreateFrame("CheckButton", frameName .. "_TopRight", frame, "UIRadioButtonTemplate")
    local radioLeft = CreateFrame("CheckButton", frameName .. "_Left", frame, "UIRadioButtonTemplate")
    local radioCenter = CreateFrame("CheckButton", frameName .. "_Center", frame, "UIRadioButtonTemplate")
    local radioRight = CreateFrame("CheckButton", frameName .. "_Right", frame, "UIRadioButtonTemplate")
    local radioBottomLeft = CreateFrame("CheckButton", frameName .. "_BottomLeft", frame, "UIRadioButtonTemplate")
    local radioBottom = CreateFrame("CheckButton", frameName .. "_Bottom", frame, "UIRadioButtonTemplate")
    local radioBottomRight = CreateFrame("CheckButton", frameName .. "_BottomRight", frame, "UIRadioButtonTemplate")

    -- Set initial checked states
    radioTopLeft:SetChecked(CanIMogItOptions[variableName] == "TOPLEFT")
    radioTop:SetChecked(CanIMogItOptions[variableName] == "TOP")
    radioTopRight:SetChecked(CanIMogItOptions[variableName] == "TOPRIGHT")
    radioLeft:SetChecked(CanIMogItOptions[variableName] == "LEFT")
    radioCenter:SetChecked(CanIMogItOptions[variableName] == "CENTER")
    radioRight:SetChecked(CanIMogItOptions[variableName] == "RIGHT")
    radioBottomLeft:SetChecked(CanIMogItOptions[variableName] == "BOTTOMLEFT")
    radioBottom:SetChecked(CanIMogItOptions[variableName] == "BOTTOM")
    radioBottomRight:SetChecked(CanIMogItOptions[variableName] == "BOTTOMRIGHT")

    local allRadios = {
        radioTopLeft, radioTop, radioTopRight,
        radioLeft, radioCenter, radioRight,
        radioBottomLeft, radioBottom, radioBottomRight
    }

    local function createOnRadioClicked(location)
        local function onRadioClicked(self)
            PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            CanIMogItOptions[variableName] = location

            for _, radio in ipairs(allRadios) do
                if radio ~= self then
                    radio:SetChecked(false)
                end
            end
            self:SetChecked(true)
            reloadButton:SetEnabled(true)
            showChangesSaved()
        end
        return onRadioClicked
    end

    -- Set up click handlers
    radioTopLeft:SetScript("OnClick", createOnRadioClicked("TOPLEFT"))
    radioTop:SetScript("OnClick", createOnRadioClicked("TOP"))
    radioTopRight:SetScript("OnClick", createOnRadioClicked("TOPRIGHT"))
    radioLeft:SetScript("OnClick", createOnRadioClicked("LEFT"))
    radioCenter:SetScript("OnClick", createOnRadioClicked("CENTER"))
    radioRight:SetScript("OnClick", createOnRadioClicked("RIGHT"))
    radioBottomLeft:SetScript("OnClick", createOnRadioClicked("BOTTOMLEFT"))
    radioBottom:SetScript("OnClick", createOnRadioClicked("BOTTOM"))
    radioBottomRight:SetScript("OnClick", createOnRadioClicked("BOTTOMRIGHT"))

    -- Position elements
    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -5)
    radioTopLeft:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    radioTop:SetPoint("TOPLEFT", radioTopLeft, "TOPRIGHT", 5, 0)
    radioTopRight:SetPoint("TOPLEFT", radioTop, "TOPRIGHT", 5, 0)
    radioLeft:SetPoint("TOPLEFT", radioTopLeft, "BOTTOMLEFT", 0, -5)
    radioCenter:SetPoint("TOPLEFT", radioLeft, "TOPRIGHT", 5, 0)
    radioRight:SetPoint("TOPLEFT", radioCenter, "TOPRIGHT", 5, 0)
    radioBottomLeft:SetPoint("TOPLEFT", radioLeft, "BOTTOMLEFT", 0, -5)
    radioBottom:SetPoint("TOPLEFT", radioBottomLeft, "TOPRIGHT", 5, 0)
    radioBottomRight:SetPoint("TOPLEFT", radioBottom, "TOPRIGHT", 5, 0)

    text:SetPoint("TOPLEFT", radioTopRight, "TOPRIGHT", 14, -3)
    text2:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -3)
    reloadButton:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 4, -8)
    textureFrame:SetPoint("TOPLEFT", radioTopLeft, "TOPLEFT")

    -- Store reference for later positioning
    element._frame = frame

    -- Store frame reference on CanIMogIt.frame for slash command access
    CanIMogIt.frame[element.var] = frame

    return frame
end

-- Forward declarations to resolve circular dependency
local DrawElement, DrawBox

function DrawBox(parent, element)
    local box = CreateFrame("Frame", nil, parent)

    -- If fill is enabled, stretch to fill parent; otherwise use specified size or default
    if element.fill then
        box:SetAllPoints(parent)
    else
        box:SetSize(element.width or 400, element.height or 400)
        box:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    end

    -- Apply outline if specified
    if element.outline then
        -- Create border textures manually
        local borderColor = {r = 0.5, g = 0.5, b = 0.5, a = 1}
        local borderWidth = 1

        -- Top border
        local topBorder = box:CreateTexture(nil, "BACKGROUND")
        topBorder:SetColorTexture(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
        topBorder:SetPoint("TOPLEFT", box, "TOPLEFT", 0, 0)
        topBorder:SetPoint("TOPRIGHT", box, "TOPRIGHT", 0, 0)
        topBorder:SetHeight(borderWidth)

        -- Bottom border
        local bottomBorder = box:CreateTexture(nil, "BACKGROUND")
        bottomBorder:SetColorTexture(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
        bottomBorder:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 0, 0)
        bottomBorder:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", 0, 0)
        bottomBorder:SetHeight(borderWidth)

        -- Left border
        local leftBorder = box:CreateTexture(nil, "BACKGROUND")
        leftBorder:SetColorTexture(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
        leftBorder:SetPoint("TOPLEFT", box, "TOPLEFT", 0, 0)
        leftBorder:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 0, 0)
        leftBorder:SetWidth(borderWidth)

        -- Right border
        local rightBorder = box:CreateTexture(nil, "BACKGROUND")
        rightBorder:SetColorTexture(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
        rightBorder:SetPoint("TOPRIGHT", box, "TOPRIGHT", 0, 0)
        rightBorder:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", 0, 0)
        rightBorder:SetWidth(borderWidth)
    end

    local lastChild = nil
    local direction = element.direction or "vertical"
    local x, y = 0, 0
    local spacing = 5
    local buffer = element.outline and 5 or 0  -- Add 5px buffer if outline is enabled

    for _, childElement in ipairs(element.children or {}) do
        childElement._parent = box
        childElement._previousSibling = lastChild

        local childFrame = DrawElement(box, childElement)
        if childFrame then
            if direction == "horizontal" then
                if lastChild and lastChild._frame then
                    childFrame:SetPoint("TOPLEFT", lastChild._frame, "TOPRIGHT", spacing, 0)
                else
                    childFrame:SetPoint("TOPLEFT", box, "TOPLEFT", x + buffer, y - buffer)
                end
            else -- vertical (default)
                if lastChild and lastChild._frame then
                    childFrame:SetPoint("TOPLEFT", lastChild._frame, "BOTTOMLEFT", 0, -spacing)
                else
                    childFrame:SetPoint("TOPLEFT", box, "TOPLEFT", x + buffer, y - buffer)
                end
            end
            childElement._frame = childFrame
        end
        lastChild = childElement
    end

    return box
end


function DrawElement(parent, element)
    if element.type == "box" then
        return DrawBox(parent, element)
    elseif element.type == "checkbox" then
        return DrawCheckbox(parent, element)
    elseif element.type == "label" then
        return DrawLabel(parent, element)
    elseif element.type == "slider" then
        return DrawSlider(parent, element)
    elseif element.type == "radiogrid" then
        return DrawRadioGrid(parent, element)
    end
end


local function createOptionsMenu()
    -- Use new declarative UI system
    DrawElement(CanIMogIt.frame, options_ui)
    changesSavedText()
end


function CanIMogIt.frame.Loaded()
    -- Set the Options from defaults.
    if (not CanIMogItOptions) then
        CanIMogItOptions = CanIMogItOptions_Defaults.options
        print(L["CanIMogItOptions not found, loading defaults!"])
    end
    -- Set missing options from the defaults if the version is out of date.
    if (CanIMogItOptions["version"] < CanIMogIt_OptionsVersion) then
        local CanIMogItOptions_temp = CanIMogItOptions_Defaults.options;
        for k,v in pairs(CanIMogItOptions) do
            if (CanIMogItOptions_Defaults.options[k]) then
                CanIMogItOptions_temp[k] = v;
            end
        end
        CanIMogItOptions_temp["version"] = CanIMogIt_OptionsVersion;
        CanIMogItOptions = CanIMogItOptions_temp;
    end
    createOptionsMenu()
    CanIMogIt.MarkAsLoaded()
end

-- Fail-safe to ensure Loaded() gets called even if event handling is disrupted
-- This helps when multiple addons are competing for the same events
local loadedFlag = false

-- Add a function to track whether the addon has been loaded
function CanIMogIt.MarkAsLoaded()
    loadedFlag = true
end

-- Create a fail-safe timer to check if Loaded() has been called
C_Timer.After(2, function()
    if not loadedFlag then
        CanIMogIt.frame.Loaded()
        CanIMogIt.MarkAsLoaded()
    end
end)

CanIMogIt:RegisterChatCommand("cimi", "SlashCommands")
CanIMogIt:RegisterChatCommand("canimogit", "SlashCommands")

local function printHelp()
    CanIMogIt:Print([[
Can I Mog It? help:
    Usage: /cimi <command>
    e.g. /cimi help

    help            Displays this help message.
    debug           Toggles the debug tooltip.
    verbose         Toggles verbose mode on tooltip.
    overlay         Toggles the icon overlay.
    refresh         Refreshes the overlay, forcing a redraw.
    unequippable    Toggles showing overlay on unequippable items.
    transmogonly    Toggles showing overlay on non-transmogable items.
    unknownonly     Toggles showing overlay on known items.
    toyitems        Toggles showing overlay on toy items.
    petitems        Toggles showing overlay on pet items.
    mountitems      Toggles showing overlay on mount items.
    ]])
end

function CanIMogIt:SlashCommands(input)
    -- Slash command router.
    if input == "" then
        self:OpenOptionsMenu()
    elseif input == 'debug' then
        CanIMogIt.frame.debug:Click()
    elseif input == 'overlay' then
        CanIMogIt.frame.showItemIconOverlay:Click()
    elseif input == 'verbose' then
        CanIMogIt.frame.showVerboseText:Click()
    elseif input == 'unequippable' then
        CanIMogIt.frame.showUnequippable:Click()
    elseif input == 'transmogonly' then
        CanIMogIt.frame.showNonTransmoggable:Click()
    elseif input == 'unknownonly' then
        CanIMogIt.frame.showUnknownOnly:Click()
    elseif input == 'toyitems' then
        CanIMogIt.frame.showToyItems:Click()
    elseif input == 'petitems' then
        CanIMogIt.frame.showPetItems:Click()
    elseif input == 'mountitems' then
        CanIMogIt.frame.showMountItems:Click()
    elseif input == 'catalizableitems' then
        CanIMogIt.frame.showCatalizableItems:Click()
    elseif input == 'ensembleitems' then
        CanIMogIt.frame.showEnsembleItems:Click()
    elseif input == 'refresh' then
        self:ResetCache()
    elseif input == 'help' then
        printHelp()
    else
        self:Print("Unknown command!")
    end
end

function CanIMogIt:OpenOptionsMenu()
    Settings.OpenToCategory(CanIMogIt.settingsCategory.ID)
end
