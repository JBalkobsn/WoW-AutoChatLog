----------------------------------------------------------------------
-- 	AutoChatLog 1.0.4 (24th January 2025)
----------------------------------------------------------------------

--  01:Variables,       02:Functions

----------------------------------------------------------------------
--  01: Variables
----------------------------------------------------------------------

    local settingsContent = CreateFrame("Frame", nil, UIParent)
    settingsContent:SetAllPoints()

    -- Message-Types and Labels
    local messageTypes = {
        { key = "Say",       label = "Say" },
        { key = "Yell",      label = "Yell" },
        { key = "Whisper",   label = "Whisper" },
        { key = "BattleNet", label = "Battle-Net" },
        { key = "Party",     label = "Party" },
        { key = "Raid",      label = "Raid" },
        { key = "Guild",     label = "Guild" },
        { key = "Instance",  label = "Instance" },
        { key = "Channel",   label = "Channel" }
    }

    local checkboxes = {}

    _G.AutoChatLogSettings = _G.AutoChatLogSettings or {
        Say = true,
        Yell = true,
        Whisper = true,
        BattleNet = true,
        Party = true,
        Raid = true,
        Guild = true,
        Instance = true,
        Channel = true
    }

----------------------------------------------------------------------
--  01: Functions
----------------------------------------------------------------------

    -- Create Checkboxes
    for i, msgType in ipairs(messageTypes) do
        local checkbox = CreateFrame("CheckButton", nil, settingsContent, "ChatConfigCheckButtonTemplate")
        checkbox:SetPoint("TOPLEFT", 20, -30 * i)
        checkbox.Text:SetText(msgType.label)

        checkbox:SetChecked(_G.AutoChatLogSettings[msgType.key] ~= false)

        checkbox:SetScript("OnClick", function(self)
            _G.AutoChatLogSettings[msgType.key] = self:GetChecked()
            print("[AutoChatLog Info] Logging for: " .. msgType.label .. (self:GetChecked() and "activated." or "deactivated."))
        end)

        checkboxes[msgType.key] = checkbox
    end

    function AutoChatLog_UpdateSettingsTab()
        for key, checkbox in pairs(checkboxes) do
            if _G.AutoChatLogSettings[key] ~= nil then
                checkbox:SetChecked(_G.AutoChatLogSettings[key])
            -- else
                -- print("No Value for Checkbox:", key) -- Debug
            end
        end
    end

    -- Register Tab
    AutoChatLog_UI_AddTab(1, "Settings", settingsContent)
