-- Tabelle mit registrierten Events
local chatEvents = {
    CHAT_MSG_SAY = "Say",
    CHAT_MSG_YELL = "Yell",
    CHAT_MSG_WHISPER = "Whisper",
    CHAT_MSG_GUILD = "Guild",
    CHAT_MSG_PARTY = "Party",
    CHAT_MSG_RAID = "Raid",
}

-- Haupt-Frame für alle Events
local frame = CreateFrame("Frame")

-- Logging-Funktion
local function LogChatMessage(event, message, sender)
   -- Übersetze den Eventnamen in eine benutzerfreundliche Form
   local friendlyName = chatEvents[event] or event

   -- Nachricht formatieren und speichern
   local formattedMessage = "[" .. friendlyName .. "] " .. sender .. ": " .. message
--    print("Formatiere Nachricht:", formattedMessage) -- Debug-Ausgabe
   table.insert(AutoChatLogData, formattedMessage)

   -- Logs im UI aktualisieren
   if AutoChatLog_UpdateLogs then
       AutoChatLog_UpdateLogs()
   else
        print("AutoChatLog_UpdateLogs nicht verfügbar.") -- Debug-Ausgabe
    end
end

function AutoChatLog_UpdateUIFromSavedVariables()
    -- print("Aktualisiere UI mit geladenen Daten.") -- Debug-Ausgabe

    -- Tab: Einstellungen
    if AutoChatLogSettings and AutoChatLog_UpdateSettingsTab then
        AutoChatLog_UpdateSettingsTab()
    else
        print("Einstellungen können nicht aktualisiert werden.") -- Debug-Ausgabe
    end

    -- Tab: Logs
    if AutoChatLog_UpdateLogs then
        AutoChatLog_UpdateLogs()
    else
        print("Logs können nicht aktualisiert werden.") -- Debug-Ausgabe
    end
end


-- Event-Callback
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AutoChatLog" then
            -- Initialisiere SavedVariables
            -- InitializeSavedVariables()
            AutoChatLogData = AutoChatLogData or {}

            AutoChatLogSettings = AutoChatLogSettings or {
                say = true,
                yell = true,
                whisper = true,
                guild = true,
                party = true,
                raid = true,
            }

            -- Initialisiere Logging-Events
            for chatEvent, _ in pairs(chatEvents) do
                frame:RegisterEvent(chatEvent)
            end

            -- Aktualisiere das UI
            AutoChatLog_UpdateUIFromSavedVariables()

            -- UI initialisieren
            AutoChatLog_UI_Initialize()
            
            -- Entferne das ADDON_LOADED-Event
            frame:UnregisterEvent("ADDON_LOADED")

            print("AutoChatLog wurde geladen.")
        end
    elseif event:match("^CHAT_MSG_") then
        local message, sender = ...
        -- print("Event empfangen:", event, "Nachricht:", message, "Sender:", sender) -- Debug-Ausgabe

        -- Nachrichtentyp bestimmen
        local messageType = chatEvents[event]
        -- print("Nachrichtentyp erkannt:", messageType) -- Debug-Ausgabe

        if messageType and AutoChatLogSettings[messageType] then
            LogChatMessage(event, message, sender)
        else
            print("Nachrichtentyp deaktiviert oder unbekannt:", messageType) -- Debug-Ausgabe
        end
    end
end

-- Eventhandler setzen
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnEvent)

-- Slash-Befehl für das UI
SLASH_AUTOCHATLOG1 = "/chatlogui"
SlashCmdList["AUTOCHATLOG"] = function()
    AutoChatLog_UI_Toggle()
end
