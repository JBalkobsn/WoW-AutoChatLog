----------------------------------------------------------------------
-- 	AutoChatLog 1.0.4 (24th January 2025)
----------------------------------------------------------------------

--  01:Variables,       02:Functions

----------------------------------------------------------------------
--  01: Variables
----------------------------------------------------------------------

    local logsContent = CreateFrame("Frame", nil, UIParent)
    logsContent:SetAllPoints()

    -- Scrollbarer Bereich
    local scrollFrame = CreateFrame("ScrollFrame", nil, logsContent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", logsContent, "TOPLEFT", 20, -40)

    local logBox = CreateFrame("EditBox", nil, scrollFrame)
    logBox:SetMultiLine(true)
    logBox:SetFontObject(GameFontNormal)
    logBox:SetPoint("TOPLEFT")
    logBox:SetWidth(scrollFrame:GetWidth() - 20)
    logBox:SetHeight(scrollFrame:GetHeight())
    logBox:SetAutoFocus(false)
    logBox:SetText("No logs available.")
    scrollFrame:SetScrollChild(logBox)

    -- Aktuelles Datum für die Anzeige
    local currentDate = GetCurrentDate()

    -- Navigation erstellen
    local navigationFrame = CreateFrame("Frame", nil, logsContent)
    navigationFrame:SetSize(_G.AutoChatLogSettings.width - 40, 30)
    navigationFrame:SetPoint("BOTTOM", logsContent, "BOTTOM", 0, 10)

    scrollFrame:SetPoint("BOTTOMRIGHT", logsContent, "BOTTOMRIGHT", -20, navigationFrame:GetHeight() + 10)

    -- Linker Pfeil
    local leftArrow = CreateFrame("Button", nil, navigationFrame, "UIPanelButtonTemplate")
    leftArrow:SetSize(30, 30)
    leftArrow:SetPoint("LEFT", navigationFrame, "LEFT", 0, 0)
    leftArrow:SetText("<")
    leftArrow:SetScript("OnClick", function()
        currentDate = date("%Y/%m/%d", time({year = tonumber(currentDate:sub(1, 4)), month = tonumber(currentDate:sub(6, 7)), day = tonumber(currentDate:sub(9, 10))}) - 86400)
        AutoChatLog_UpdateLogs()
    end)

    -- Rechter Pfeil
    local rightArrow = CreateFrame("Button", nil, navigationFrame, "UIPanelButtonTemplate")
    rightArrow:SetSize(30, 30)
    rightArrow:SetPoint("RIGHT", navigationFrame, "RIGHT", 0, 0)
    rightArrow:SetText(">")
    rightArrow:SetScript("OnClick", function()
        currentDate = date("%Y/%m/%d", time({year = tonumber(currentDate:sub(1, 4)), month = tonumber(currentDate:sub(6, 7)), day = tonumber(currentDate:sub(9, 10))}) + 86400)
        AutoChatLog_UpdateLogs()
    end)

    -- Datum-Anzeige
    local dateLabel = navigationFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dateLabel:SetPoint("CENTER", navigationFrame, "CENTER", 0, 0)
    dateLabel:SetText(currentDate)

    _G.AutoChatLogData = _G.AutoChatLogData or {}

----------------------------------------------------------------------
--  01: Functions
----------------------------------------------------------------------

    function AutoChatLog_UpdateFrameSize()
        -- Aktuelle Breite und Höhe des Fensters abrufen
        local width = AutoChatLogUI:GetWidth()
        local height = AutoChatLogUI:GetHeight()

        -- Mindestabstand vom Rand
        local paddingX = 20
        local paddingY = 60
        local navigationFrameHeight = 40

        -- Berechnung des sichtbaren Bereichs
        local scrollFrameWidth = width - paddingX * 2
        local scrollFrameHeight = height - paddingY - navigationFrameHeight

        -- ScrollFrame-Größe anpassen
        scrollFrame:SetWidth(scrollFrameWidth)
        scrollFrame:SetHeight(scrollFrameHeight)

        -- TextBox-Größe dynamisch anpassen
        logBox:SetWidth(scrollFrameWidth - 20) -- Platz für die Scrollbar
        logBox:SetHeight(scrollFrameHeight) -- Maximalhöhe innerhalb des ScrollFrame
    end

    -- Funktion, um Logs anzuzeigen
    function AutoChatLog_UpdateLogs()
        if not _G.AutoChatLogData[currentDate] or #_G.AutoChatLogData[currentDate] == 0 then
            logBox:SetText("No logs available for " .. currentDate .. ".")
        else
            local logText = table.concat(_G.AutoChatLogData[currentDate], "\n")
            logBox:SetText(logText)
        end

        -- Datum aktualisieren
        dateLabel:SetText(currentDate)
    end

    -- Tab registrieren
    AutoChatLog_UI_AddTab(2, "Logs", logsContent)
