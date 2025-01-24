----------------------------------------------------------------------
-- 	AutoChatLog 1.0.4 (24th January 2025)
----------------------------------------------------------------------

--  01:Variables,   02:Event-Registration,  03:Functions
--  04:Player,      05:Event-Handler,       06:Commands

----------------------------------------------------------------------
--  01: Variables
----------------------------------------------------------------------

    -- Create global tables
    _G.AutoChatLogSettings = _G.AutoChatLogSettings or {
        Say = true,
        Yell = true,
        Whisper = true,
        BattleNet = true,
        Party = true,
        Raid = true,
        Guild = true,
        Instance = true,
        Channel = false
    }

    _G.AutoChatLogData = _G.AutoChatLogData or {}

    -- Create locales
    local AclChatEvents = {
        CHAT_MSG_SAY = "Say",
        CHAT_MSG_YELL = "Yell",
        CHAT_MSG_WHISPER = "Whisper",
        CHAT_MSG_WHISPER_INFORM = "Whisper",
        CHAT_MSG_BN_WHISPER = "BattleNet",
        CHAT_MSG_PARTY = "Party",
        CHAT_MSG_PARTY_LEADER = "Party",
        CHAT_MSG_RAID = "Raid",
        CHAT_MSG_RAID_LEADER = "Raid",
        CHAT_MSG_GUILD = "Guild",
        CHAT_MSG_OFFICER = "Guild",
        CHAT_MSG_INSTANCE_CHAT = "Instance",
        CHAT_MSG_INSTANCE_CHAT_LEADER = "Instance",
        CHAT_MSG_CHANNEL = "Channel"
    }

    local AclLC = {}

    if not _G.AutoChatLogSettings.width then
        _G.AutoChatLogSettings.width = 500 -- Standardbreite
    end
    if not _G.AutoChatLogSettings.height then
        _G.AutoChatLogSettings.height = 400 -- Standardhöhe
    end

----------------------------------------------------------------------
--  02: Event-Registration
----------------------------------------------------------------------

    -- Create event frame
    local AutoChatLogEvt = CreateFrame("Frame")
    AutoChatLogEvt:RegisterEvent("ADDON_LOADED")
    AutoChatLogEvt:RegisterEvent("PLAYER_LOGIN")

    -- Register chat events
    for chatEvent, _ in pairs(AclChatEvents) do
        AutoChatLogEvt:RegisterEvent(chatEvent)
    end

----------------------------------------------------------------------
--  03: Functions
----------------------------------------------------------------------

    -- Gets the current date for logs
    function GetCurrentDate()
        return date("%Y/%m/%d")
    end

    -- Log chat message
    local function LogChatMessage(event, message, sender)
        local currentDate = GetCurrentDate()
        local timestamp = date("%H:%M:%S")

        if not _G.AutoChatLogData[currentDate] then
            _G.AutoChatLogData[currentDate] = {}
        end
        -- Translate event name in user friendly format
        local friendlyName = AclChatEvents[event] or event

        -- Save and format message
        local formattedMessage = "[" .. timestamp .. "] [" .. friendlyName .. "] " .. sender .. ": " .. message
        table.insert(AutoChatLogData[currentDate], formattedMessage)

        -- Update logs in UI
        if AutoChatLog_UpdateLogs then
            AutoChatLog_UpdateLogs()
        else
            print("[AutoChatLog Error] AutoChatLog_UpdateLogs function not available.")
        end
    end

    -- Set the state of the UI based on saved variables
    local function AutoChatLog_UpdateUIFromSavedVariables()
        -- Tab: Settings
        if AutoChatLogSettings and AutoChatLog_UpdateSettingsTab then
            AutoChatLog_UpdateSettingsTab()
        else
            print("[AutoChatLog Error] Couldn't update settings.")
        end

        -- Tab: Logs
        if AutoChatLog_UpdateLogs then
            AutoChatLog_UpdateLogs()
        else
            print("[AutoChatLog Error] Couldn't update logs.")
        end
    end

----------------------------------------------------------------------
--  04: Player
----------------------------------------------------------------------

    function AclLC:Player()

        do

            local minimapBuutton = LibStub("LibDataBroker-1.1"):NewDataObject("AutoChatLog", {
                type = "launcher",
                text = "AutoChatLog",
                icon = "Interface\\Icons\\INV_Misc_Note_01", -- Icon für das Minimap-Button
                OnClick = function(self, button)
                    if button == "LeftButton" then
                        AutoChatLog_UI_Toggle() -- Öffnet oder schließt das AddOn-Menü
                    elseif button == "RightButton" then
                        --print("Rechtsklick-Funktion noch nicht implementiert.") -- Platzhalter
                    end
                end,
                OnTooltipShow = function(tooltip)
                    tooltip:AddLine("AutoChatLog")
                    tooltip:AddLine("Leftclick: Opens the UI", 1, 1, 1)
                    tooltip:AddLine("Rightclick: Hasn't been implemented yet", 1, 1, 1)
                end,
            })

            local icon = LibStub("LibDBIcon-1.0", true)

            if not AutoChatLogSettings.minimap then
                AutoChatLogSettings.minimap = { hide = false }
            end

			icon:Register("AutoChatLog", minimapBuutton, AutoChatLogSettings.minimap)

        end
    end

----------------------------------------------------------------------
--  05: Event-Handler
----------------------------------------------------------------------

    -- Event-Callback
    local function eventHandler(self, event, ...)
        if event == "ADDON_LOADED" then
            local addonName = ...
            if addonName == "AutoChatLog" then
                -- Update UI
                AutoChatLog_UpdateUIFromSavedVariables()

                -- initialization of the UI
                AutoChatLog_UI_Initialize()

                -- Remove ADDON_LOADED event
                AutoChatLogEvt:UnregisterEvent("ADDON_LOADED")

                print("[AutoChatLog Info] Addon loaded.")
            end
        elseif event:match("^CHAT_MSG_") then
            local message, sender = ...
            -- Evaluate message type
            local messageType = AclChatEvents[event]

            if messageType and _G.AutoChatLogSettings[messageType] then
                LogChatMessage(event, message, sender)
            else
                -- print("[AutoChatLog Error] Unknown message type:", messageType)
            end
        elseif event == "PLAYER_LOGIN" then
			AclLC:Player()
			collectgarbage()
			return
		end
    end

    -- Register event handler
    AutoChatLogEvt:SetScript("OnEvent", eventHandler)

----------------------------------------------------------------------
--  06: Commands
----------------------------------------------------------------------

    -- Slash command to open the UI
    SLASH_AUTOCHATLOG1 = "/chatlogui"
    SlashCmdList["AUTOCHATLOG"] = function()
        AutoChatLog_UI_Toggle()
    end
