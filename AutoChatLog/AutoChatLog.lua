----------------------------------------------------------------------
-- 	AutoChatLog 1.0.2 (12th January 2025)
----------------------------------------------------------------------

--	01:Functions 02:Locks,  03:Restart 40:Player
--	60:Events    62:Profile 70:Logout  80:Commands, 90:Panel

----------------------------------------------------------------------
-- 	AutoChatLog
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
        Channel = true
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

----------------------------------------------------------------------
--	A00: AutoChatLog
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
--	A01: Functions
----------------------------------------------------------------------

    -- Log chat message
    local function LogChatMessage(event, message, sender)
        -- Translate event name in user friendly format
        local friendlyName = AclChatEvents[event] or event

        -- Save and format message
        local formattedMessage = "[" .. friendlyName .. "] " .. sender .. ": " .. message
        table.insert(AutoChatLogData, formattedMessage)

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
            print("[AutoChatLog Error] Could'nt update settings.")
        end

        -- Tab: Logs
        if AutoChatLog_UpdateLogs then
            AutoChatLog_UpdateLogs()
        else
            print("[AutoChatLog Error] Could'nt update logs.")
        end
    end

----------------------------------------------------------------------
--	L40: Player
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
--	A01: Events
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

            if messageType then --and AutoChatLogSettings[messageType] then
                LogChatMessage(event, message, sender)
            else
                print("[AutoChatLog Error] Unknown message type:", messageType)
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
-- 	Commands
----------------------------------------------------------------------

    -- Slash command to open the UI
    SLASH_AUTOCHATLOG1 = "/chatlogui"
    SlashCmdList["AUTOCHATLOG"] = function()
        AutoChatLog_UI_Toggle()
    end
