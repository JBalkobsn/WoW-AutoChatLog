-- Debug-Ausgabe, um zu prüfen, ob die Datei geladen wird
-- print("AutoChatLog_UI.lua wurde geladen.")

-- Hauptfenster für das UI
local AutoChatLogUI = CreateFrame("Frame", "AutoChatLogUIFrame", UIParent, "BasicFrameTemplateWithInset")
AutoChatLogUI:SetSize(500, 400) -- Breite, Höhe
AutoChatLogUI:SetPoint("CENTER") -- Position
AutoChatLogUI:SetMovable(true)
AutoChatLogUI:EnableMouse(true)
AutoChatLogUI:RegisterForDrag("LeftButton")
AutoChatLogUI:SetScript("OnDragStart", AutoChatLogUI.StartMoving)
AutoChatLogUI:SetScript("OnDragStop", AutoChatLogUI.StopMovingOrSizing)
AutoChatLogUI:Hide() -- Startet versteckt

-- Titel des Fensters
AutoChatLogUI.title = AutoChatLogUI:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
AutoChatLogUI.title:SetPoint("CENTER", AutoChatLogUI.TitleBg, "CENTER", 0, 0)
AutoChatLogUI.title:SetText("AutoChatLog")

-- Tabs erstellen
local tabs = {}
local activeTabIndex = 1 -- Standardmäßig erstes Tab aktiv

local function CreateTab(index, text)
    -- print("Erstelle Tab:", index, text) -- Debug-Ausgabe

    -- Einfache Buttons für Tabs
    local tab = CreateFrame("Button", "AutoChatLogUITab" .. index, AutoChatLogUI, "UIPanelButtonTemplate")
    tab:SetID(index)
    tab:SetText(text)
    tab:SetSize(100, 25)
    tab:SetPoint("TOPLEFT", AutoChatLogUI, "BOTTOMLEFT", (index - 1) * 100, 0)

    tab:SetScript("OnClick", function(self)
        activeTabIndex = self:GetID()
        for i, t in pairs(tabs) do
            t.content:SetShown(i == activeTabIndex)
        end
    end)

    tabs[index] = tab
    return tab
end

-- Funktion zum Hinzufügen eines Tabs
function AutoChatLog_UI_AddTab(index, name, content)
    -- print("Registriere Tab:", index, name) -- Debug-Ausgabe
    local tab = CreateTab(index, name)
    tab.content = content
    tab.content:SetParent(AutoChatLogUI)
    tab.content:SetAllPoints()
    tab.content:Hide()
end

-- Funktion zur Initialisierung des UI
function AutoChatLog_UI_Initialize()
    -- print("AutoChatLog_UI_Initialize wurde aufgerufen.") -- Debug-Ausgabe

    -- Sicherheitsprüfung: Gibt es Tabs?
    -- print("Anzahl registrierter Tabs:", #tabs) -- Debug-Ausgabe
    for index, tab in ipairs(tabs) do
        -- print("Tab", index, "existiert:", tab ~= nil)
        if tab then
            -- print("Tab-ID:", tab:GetID(), "Text:", tab:GetText())
        end
    end

    if #tabs == 0 then
        -- print("Keine Tabs registriert. Abbruch.")
        return
    end

    -- Zeige den Inhalt des ersten Tabs standardmäßig
    if tabs[1] and tabs[1].content then
        tabs[1].content:Show()
    end
end

-- Funktion zum Anzeigen/Ausblenden des UI
function AutoChatLog_UI_Toggle()
    if AutoChatLogUI:IsShown() then
        AutoChatLogUI:Hide()
    else
        AutoChatLogUI:Show()
    end
end
