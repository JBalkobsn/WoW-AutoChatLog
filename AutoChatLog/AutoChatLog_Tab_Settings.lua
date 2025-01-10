-- Tab 1: Einstellungen
local settingsContent = CreateFrame("Frame", nil, UIParent)
settingsContent:SetAllPoints()

-- Nachrichtentypen und Labels
local messageTypes = {
    { key = "Say", label = "Sagen" },
    { key = "Yell", label = "Schreien" },
    { key = "Whisper", label = "Flüstern" },
    { key = "Guild", label = "Gilde" },
    { key = "Party", label = "Gruppe" },
    { key = "Raid", label = "Schlachtzug" },
}

local checkboxes = {}

AutoChatLogSettings = AutoChatLogSettings or {
    Say = true,
    Yell = true,
    Whisper = true,
    Guild = true,
    Party = true,
    Raid = true,
}

-- Checkboxen erstellen
for i, msgType in ipairs(messageTypes) do
    local checkbox = CreateFrame("CheckButton", nil, settingsContent, "ChatConfigCheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", 20, -30 * i)
    checkbox.Text:SetText(msgType.label)

    -- Checkbox-Status basierend auf gespeicherten Einstellungen setzen
    checkbox:SetChecked(AutoChatLogSettings[msgType.key] ~= false)

    checkbox:SetScript("OnClick", function(self)
        AutoChatLogSettings[msgType.key] = self:GetChecked()
        print(msgType.label .. " ist " .. (self:GetChecked() and "aktiviert" or "deaktiviert"))
    end)

    checkboxes[msgType.key] = checkbox
end

function AutoChatLog_UpdateSettingsTab()
    -- print("Aktualisiere Einstellungen-Tab.") -- Debug-Ausgabe

    for key, checkbox in pairs(checkboxes) do
        if AutoChatLogSettings[key] ~= nil then
            checkbox:SetChecked(AutoChatLogSettings[key])
        else
            -- print("Kein Wert für Checkbox:", key) -- Debug-Ausgabe
        end
    end
end

-- Tab registrieren
AutoChatLog_UI_AddTab(1, "Einstellungen", settingsContent)
