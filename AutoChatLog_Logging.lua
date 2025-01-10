-- Dummy-Initialisierung für die Logging-Logik
function AutoChatLog_Logging_Initialize()
    print("Logging-Logik initialisiert.")
end

-- Initialisiere die gespeicherte Variable, falls sie nicht existiert
AutoChatLogData = AutoChatLogData or {}

-- Tabelle für deduplizierte Nachrichten
local lastLoggedMessages = {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT") -- Speichern beim Spielende

-- Funktion zum Speichern von Nachrichten
local function SaveLogEntry(message)
    -- Prüfen, ob die Nachricht bereits geloggt wurde
    if lastLoggedMessages[message] then
        print("Nachricht bereits geloggt: " .. message) -- Debug-Ausgabe
        return
    end

    -- Nachricht in der gespeicherten Tabelle ablegen
    table.insert(AutoChatLogData, message)
    lastLoggedMessages[message] = true -- Nachricht als geloggt markieren
    print("Nachricht gespeichert: " .. message) -- Debug-Ausgabe
end

-- Funktion zum Filtern und Speichern von Spieler-Nachrichten
local function FilterPlayerMessages(self, event, message, sender, ...)
    print("Filter aufgerufen für Event: " .. event) -- Debug-Ausgabe

    -- Spielername ermitteln (für eigene Nachrichten)
    local playerName = UnitName("player")
    local logMessage

    if event == "CHAT_MSG_WHISPER_INFORM" then
        -- Eigene Flüsternachricht an andere Spieler
        logMessage = date("%m/%d %H:%M:%S") .. " (Du flüsterst an): " .. message
    elseif sender == playerName or sender == nil then
        -- Eigene Nachricht (z. B. /sagen, /gilde)
        logMessage = date("%m/%d %H:%M:%S") .. " (Du): " .. message
    elseif sender and not sender:find("-") and not sender:match("^%[") then
        -- Nachricht von anderen Spielern
        logMessage = date("%m/%d %H:%M:%S") .. " " .. sender .. ": " .. message
    else
        -- Ignoriere andere Nachrichten
        print("Nachricht ignoriert: " .. (message or "nil")) -- Debug-Ausgabe
        return false -- Nachricht im Chat anzeigen
    end

    -- Nachricht speichern
    SaveLogEntry(logMessage)
    return false -- Nachricht im Chat anzeigen
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        print("AutoChatLog wurde geladen und Nachrichten werden gespeichert.")

        -- Liste aller relevanten Chat-Ereignisse
        local chatEvents = {
            "CHAT_MSG_SAY",
            "CHAT_MSG_YELL",
            "CHAT_MSG_WHISPER",
            "CHAT_MSG_WHISPER_INFORM", -- Outgoing Whispers
            "CHAT_MSG_BN_WHISPER",
            "CHAT_MSG_PARTY",
            "CHAT_MSG_PARTY_LEADER",
            "CHAT_MSG_RAID",
            "CHAT_MSG_RAID_LEADER",
            "CHAT_MSG_GUILD",
            "CHAT_MSG_OFFICER",
            "CHAT_MSG_INSTANCE_CHAT",
            "CHAT_MSG_INSTANCE_CHAT_LEADER",
            "CHAT_MSG_CHANNEL"
        }

        -- Filter auf alle relevanten Ereignisse anwenden
        for _, event in pairs(chatEvents) do
            ChatFrame_AddMessageEventFilter(event, FilterPlayerMessages)
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Daten speichern beim Logout
        print("Speichere AutoChatLog-Daten...")
    end
end)
