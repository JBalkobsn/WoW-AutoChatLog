-- Tab 2: Logs
local logsContent = CreateFrame("Frame", nil, UIParent)
logsContent:SetAllPoints()

-- Scrollbarer Bereich
local scrollFrame = CreateFrame("ScrollFrame", nil, logsContent, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(460, 340)
scrollFrame:SetPoint("CENTER")

local logBox = CreateFrame("EditBox", nil, scrollFrame)
logBox:SetMultiLine(true)
logBox:SetFontObject(ChatFontNormal)
logBox:SetSize(460, 340)
logBox:SetAutoFocus(false)
logBox:SetText("Keine Logs verfügbar.")
scrollFrame:SetScrollChild(logBox)

AutoChatLogData = AutoChatLogData or {}

-- Funktion, um Logs anzuzeigen
function AutoChatLog_UpdateLogs()
    -- print("AutoChatLog_UpdateLogs aufgerufen.") -- Debug-Ausgabe
    if AutoChatLogData == nil or #AutoChatLogData == 0 then
        -- print("Keine Logs verfügbar.") -- Debug-Ausgabe
        logBox:SetText("Keine Logs verfügbar.")
    else
        local logText = table.concat(AutoChatLogData, "\n")
        -- print("Logs aktualisiert:", logText) -- Debug-Ausgabe
        logBox:SetText(logText)
    end
end

function AutoChatLog_UpdateLogs()
    -- print("Aktualisiere Logs.") -- Debug-Ausgabe

    if not AutoChatLogData or #AutoChatLogData == 0 then
        logBox:SetText("Keine Logs verfügbar.")
    else
        local logText = table.concat(AutoChatLogData, "\n")
        logBox:SetText(logText)
    end
end

-- Tab registrieren
AutoChatLog_UI_AddTab(2, "Logs", logsContent)
