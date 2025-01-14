-- Tab 1: Einstellungen
local settingsContent = CreateFrame("Frame", nil, UIParent)
settingsContent:SetAllPoints()

-- Nachrichtentypen und Labels
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

-- Checkboxen erstellen
for i, msgType in ipairs(messageTypes) do
    local checkbox = CreateFrame("CheckButton", nil, settingsContent, "ChatConfigCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", 20, -30 * i)
    checkbox.Text:SetText(msgType.label)

    -- Checkbox-Status basierend auf gespeicherten Einstellungen setzen
    checkbox:SetChecked(_G.AutoChatLogSettings[msgType.key] ~= false)

    checkbox:SetScript("OnClick", function(self)
        _G.AutoChatLogSettings[msgType.key] = self:GetChecked()
        print(msgType.label .. " ist " .. (self:GetChecked() and "aktiviert" or "deaktiviert"))
    end)

    checkboxes[msgType.key] = checkbox
end

function AutoChatLog_UpdateSettingsTab()
    -- print("Aktualisiere Einstellungen-Tab.") -- Debug-Ausgabe

    for key, checkbox in pairs(checkboxes) do
        if _G.AutoChatLogSettings[key] ~= nil then
            checkbox:SetChecked(_G.AutoChatLogSettings[key])
        else
            -- print("Kein Wert für Checkbox:", key) -- Debug-Ausgabe
        end
    end
end

-- Tab registrieren
AutoChatLog_UI_AddTab(1, "Einstellungen", settingsContent)
