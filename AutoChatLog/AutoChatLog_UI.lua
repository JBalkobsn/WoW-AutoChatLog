----------------------------------------------------------------------
-- 	AutoChatLog 1.0.4 (24th January 2025)
----------------------------------------------------------------------

--  01:Main-Window,     02:Resize-Handle,
--  03:Variables,       04:Functions

----------------------------------------------------------------------
--  01: Main-Window
----------------------------------------------------------------------

    -- Main window for the UI
    _G.AutoChatLogUI = CreateFrame("Frame", "AutoChatLogUIFrame", UIParent, "BasicFrameTemplateWithInset")
    AutoChatLogUI:SetSize(_G.AutoChatLogSettings.width, _G.AutoChatLogSettings.height)
    AutoChatLogUI:SetPoint("CENTER", UIParent, "CENTER")
    AutoChatLogUI:SetResizable(true)
    AutoChatLogUI:SetClampedToScreen(true)
    AutoChatLogUI:SetMovable(true)
    AutoChatLogUI:EnableMouse(true)
    AutoChatLogUI:RegisterForDrag("LeftButton")
    AutoChatLogUI:SetScript("OnDragStart", AutoChatLogUI.StartMoving)
    AutoChatLogUI:SetScript("OnDragStop", AutoChatLogUI.StopMovingOrSizing)
    AutoChatLogUI:Hide()


    AutoChatLogUI.title = AutoChatLogUI:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    AutoChatLogUI.title:SetPoint("CENTER", AutoChatLogUI.TitleBg, "CENTER", 0, 0)
    AutoChatLogUI.title:SetText("AutoChatLog")

    AutoChatLogUI:SetScript("OnSizeChanged", function(self)
        AutoChatLog_UpdateFrameSize()
    end)

----------------------------------------------------------------------
--  02: Resize-Handle
----------------------------------------------------------------------

    -- Create Resize-Handle
    local resizeHandle = CreateFrame("Frame", nil, AutoChatLogUI)
    resizeHandle:SetSize(16, 16)
    resizeHandle:SetPoint("BOTTOMRIGHT", AutoChatLogUI, "BOTTOMRIGHT", -4, 4)

    -- Background texture
    resizeHandle.texture = resizeHandle:CreateTexture(nil, "BACKGROUND")
    resizeHandle.texture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeHandle.texture:SetAllPoints(resizeHandle)

    -- Mouse-Scripts
    resizeHandle:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            AutoChatLogUI:StartSizing("BOTTOMRIGHT")
        end
    end)

    resizeHandle:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            AutoChatLogUI:StopMovingOrSizing()

            -- Größenbegrenzung manuell anwenden
            local width = AutoChatLogUI:GetWidth()
            local height = AutoChatLogUI:GetHeight()

            -- Begrenzungen setzen
            if width < 500 then width = 500 end
            if width > 1500 then width = 1500 end
            if height < 400 then height = 400 end
            if height > 1200 then height = 1200 end

            AutoChatLogUI:SetSize(width, height)

            -- Speichere neue Größe
            _G.AutoChatLogSettings.width = width
            _G.AutoChatLogSettings.height = height

            -- Aktualisiere Inhalte
            AutoChatLog_UpdateFrameSize()
        end
    end)

    resizeHandle:SetScript("OnEnter", function(self)
        self.texture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    end)

    resizeHandle:SetScript("OnLeave", function(self)
        self.texture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    end)

----------------------------------------------------------------------
--  03: Variables
----------------------------------------------------------------------

    -- Create Tabs
    local tabs = {}
    local activeTabIndex = 1 -- Standardmäßig erstes Tab aktiv

----------------------------------------------------------------------
--  04: Functions
----------------------------------------------------------------------

    local function CreateTab(index, text)
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

    function AutoChatLog_UI_AddTab(index, name, content)
        local tab = CreateTab(index, name)
        tab.content = content
        tab.content:SetParent(AutoChatLogUI)
        tab.content:SetAllPoints()
        tab.content:Hide()
    end

    function AutoChatLog_UI_Initialize()
        if #tabs == 0 then
            print("[AutoChatLog Error] No tabs for the UI found.")
            return
        end

        -- Show first tab
        if tabs[1] and tabs[1].content then
            tabs[1].content:Show()
        end
    end

    function AutoChatLog_UI_Toggle()
        if AutoChatLogUI:IsShown() then
            AutoChatLogUI:Hide()
        else
            AutoChatLogUI:Show()
        end
    end
