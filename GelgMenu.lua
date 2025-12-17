--[[
    GELG MENU 🔵
    Clean minimalist design
    RIGHT SHIFT to toggle
]]
local Menu = {
    open = false,
    selected = 1,
    alpha = 0,
    selectionY = 0,
    targetY = 0,
    toggleAnimations = {}, -- Store toggle animation progress for each feature
    unlocked = false, -- Menu locked until key is set
    openKey = nil, -- Will store the VK code
    currentMenu = "main", -- Track current menu
    cfg = {
        x = 0, -- Will be calculated to center
        y = 0, -- Will be calculated to center
        w = 320,
        headerH = 100,
        itemH = 45,
        rounding = 12,
        -- Blue theme
        accent = {0.2, 0.6, 1.0},
        accentBright = {0.3, 0.75, 1.0},
        bg = {0.05, 0.08, 0.12, 0.90},
        itemBg = {0.08, 0.12, 0.16, 0.4},
        selectedBorder = {0.2, 0.6, 1.0, 0.9},
        text = {1, 1, 1},
        textDim = {0.7, 0.7, 0.75},
        line = {0.2, 0.6, 1.0, 0.8}
        ,
        -- small horizontal tweak for Player ID text centering (negative moves left)
        idTextOffset = -2
    },
    features = {
        {name = "Players", key = "playersmenu", type = "submenu"},
        {name = "Combat", key = "combatmenu", type = "submenu"},
        {name = "Vehicle", key = "vehiclemenu", type = "submenu"},
        {name = "Miscellaneous", key = "miscmenu", type = "submenu"},
        {name = "Triggers", key = "triggersmenu", type = "submenu"},
        {name = "Settings", key = "settingsmenu", type = "submenu"}
    },
    combatMenu = {
        {name = "Silent Kill Ragebot", key = "silentkill", enabled = false, type = "toggle"},
        {name = "Car Ragebot", key = "ragebot", enabled = false, type = "toggle"}
    },
    playersMenu = {},
    miscMenu = {
        {name = "Player ID ESP", key = "idesp", enabled = false, type = "toggle"}
        ,{name = "Freecam", key = "freecam", enabled = false, type = "toggle"}
    },
    triggersMenu = {
        {name = "Find Triggers", key = "findtriggers", type = "action"},
        {name = "Show All Triggers", key = "showtriggers", type = "action"}
    },
    vehicleMenu = {
        {name = "Spawn Vehicle", key = "spawnvehiclemenu", type = "submenu"}
    },
    spawnVehicleMenu = {
        {name = "Replace Vehicle", key = "replacevehicle", enabled = true, type = "toggle"},
        {name = "Warp into Vehicle", key = "warpvehicle", enabled = true, type = "toggle"},
        {name = "Spawn Asea (JSY 284)", key = "spawnasea", type = "action"}
    },
    settingsMenu = {
        -- Player ID ESP moved to Miscellaneous menu
        {
            name = "Banner",
            key = "bannerselect",
            type = "action",
            options = {
                -- Use remote URL for Black so it doesn't depend on a local file path
                {name = "Black", value = "https://i.imgur.com/hxUAfOX.png"},
                {name = "Jaspek", value = "https://i.imgur.com/t6HxVfH.png"},
                {name = "Clouds", value = "https://i.imgur.com/kt988JM.png"}
            },
            selectedOption = 1
        },
        {
            name = "Color",
            key = "accentselect",
            type = "action",
            options = {
                {name = "Blue", color = {0.2, 0.6, 1.0}, bright = {0.3, 0.75, 1.0}},
                {name = "Red", color = {1.0, 0.2, 0.2}, bright = {1.0, 0.4, 0.4}},
                {name = "Green", color = {0.2, 1.0, 0.2}, bright = {0.4, 1.0, 0.4}},
                {name = "Purple", color = {0.6, 0.2, 1.0}, bright = {0.75, 0.3, 1.0}},
                {name = "Orange", color = {1.0, 0.55, 0.2}, bright = {1.0, 0.65, 0.3}},
                {name = "Cyan", color = {0.0, 0.8, 0.8}, bright = {0.2, 0.9, 0.9}},
                {name = "Yellow", color = {1.0, 0.9, 0.2}, bright = {1.0, 0.95, 0.35}},
                {name = "Black", color = {0.0, 0.0, 0.0}, bright = {0.12, 0.12, 0.12}},
                {name = "White", color = {1.0, 1.0, 1.0}, bright = {1.0, 1.0, 1.0}}
            },
            selectedOption = 1
        }
    }
}


local screenW, screenH = 1920, 1080
local customFont = nil
local bannerTexture = nil
local bannerWidth = 0
local bannerHeight = 0
-- Default banner: point to the remote Black image so it's used by default
local currentBannerPath = "https://i.imgur.com/hxUAfOX.png"

Citizen.CreateThread(
    function()
        local w, h = GetActiveScreenResolution()
        if w and h and w > 0 then
            screenW, screenH = w, h
        end
    end
)

-- Load custom font from URL
Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        print("^4[GELG]^7 Loading Monaspace Argon font...")

        local fontUrl =
            "https://github.com/matomo-org/travis-scripts/raw/refs/heads/master/fonts/Arial.ttf"
        local st, body = Susano.HttpGet(fontUrl)

        if st and body then
            local id, err = Susano.LoadFontFromBuffer(body, 15)

            if id then
                customFont = id
                print("^4[GELG]^7 Monaspace Argon font loaded!")
            else
                print("^4[GELG]^7 Failed to load font: " .. tostring(err))
            end
        else
            print("^4[GELG]^7 Failed to download font: " .. tostring(body))
        end
    end
)

-- Function to load banner image
local function loadBanner(bannerName)
    if bannerTexture then
        Susano.ReleaseTexture(bannerTexture)
        bannerTexture = nil
    end

    -- If bannerName looks like an HTTP(S) URL, download it first and load from buffer
    if type(bannerName) == "string" and bannerName:match("^https?://") then
        print(string.format("^4[GELG]^7 Loading banner from URL: %s", bannerName))
        local st, body = Susano.HttpGet(bannerName)

        if st and body then
            local id, w, h = Susano.LoadTextureFromBuffer(body)
            if id then
                bannerTexture = id
                bannerWidth = w
                bannerHeight = h
                currentBannerPath = bannerName
                print(string.format("^4[GELG]^7 Banner loaded from URL! Size: %dx%d", w, h))
                return true
            else
                print(string.format("^4[GELG]^7 Failed to create texture from downloaded data: %s", tostring(bannerName)))
                return false
            end
        else
            print(string.format("^4[GELG]^7 Failed to download banner: %s", tostring(bannerName)))
            return false
        end
    end
end

-- Initialize banner selection to match current banner
local function initializeBannerSelection()
    for _, item in ipairs(Menu.settingsMenu or {}) do
        if item and item.key == "bannerselect" and item.options then
            for i, option in ipairs(item.options) do
                if option.value == currentBannerPath then
                    item.selectedOption = i
                    break
                end
            end
            break
        end
    end
end

-- Initialize accent selection to match current cfg.accent
local function initializeAccentSelection()
    for _, item in ipairs(Menu.settingsMenu or {}) do
        if item.key == "accentselect" and item.options then
            for i, opt in ipairs(item.options) do
                if opt.color and Menu.cfg and Menu.cfg.accent then
                    if math.abs((opt.color[1] or 0) - (Menu.cfg.accent[1] or 0)) < 0.001 and
                       math.abs((opt.color[2] or 0) - (Menu.cfg.accent[2] or 0)) < 0.001 and
                       math.abs((opt.color[3] or 0) - (Menu.cfg.accent[3] or 0)) < 0.001 then
                        item.selectedOption = i
                        -- Also apply the matching accent so UI elements update immediately
                        applyAccentColor(opt.color, opt.bright)
                        break
                    end
                end
            end
        end
    end
end

-- Update players list: gather active players, compute distance, sort by distance
local function updatePlayersMenu()
    local myPed = PlayerPedId()
    local myPos = GetEntityCoords(myPed)
    local list = {}

    for _, pid in ipairs(GetActivePlayers()) do
        if pid ~= PlayerId() then
            local ped = GetPlayerPed(pid)
            if DoesEntityExist(ped) then
                local pos = GetEntityCoords(ped)
                local dist = 0
                if pos and myPos then
                    dist = #(myPos - pos)
                end
                local name = GetPlayerName(pid) or "Unknown"
                table.insert(list, {name = name, serverId = GetPlayerServerId(pid), playerId = pid, distance = dist})
            end
        end
    end

    table.sort(list, function(a, b)
        return a.distance < b.distance
    end)

    local menu = {}
    for _, p in ipairs(list) do
        local display = string.format("%s (ID:%d) - %.1fm", p.name, p.serverId, p.distance)
        table.insert(menu, {name = display, key = "player_" .. tostring(p.serverId), type = "action", playerId = p.playerId, serverId = p.serverId, distance = p.distance})
    end

    if #menu == 0 then
        menu = {{name = "No players found", key = "noplayers", type = "action"}}
    end

    Menu.playersMenu = menu

    -- adjust selection if out of bounds
    if Menu.currentMenu == "players" and Menu.selected > #Menu.playersMenu then
        Menu.selected = 1
    end
end

-- Apply accent colors across cfg (updates line and selectedBorder too)
local function applyAccentColor(color, bright)
    if not color then
        return
    end
    Menu.cfg.accent = color
    Menu.cfg.accentBright = bright or color
    -- Update derived UI colors that should follow accent
    Menu.cfg.line = {Menu.cfg.accent[1], Menu.cfg.accent[2], Menu.cfg.accent[3], 0.8}
    Menu.cfg.selectedBorder = {Menu.cfg.accentBright[1] or Menu.cfg.accent[1], Menu.cfg.accentBright[2] or Menu.cfg.accent[2], Menu.cfg.accentBright[3] or Menu.cfg.accent[3], 0.9}
end

-- Load banner image on startup
Citizen.CreateThread(
    function()
        Citizen.Wait(200)
        loadBanner(currentBannerPath)
        initializeBannerSelection()
        initializeAccentSelection()
    end
)

-- Periodically refresh players list so the Players submenu stays up-to-date
Citizen.CreateThread(function()
    while true do
        updatePlayersMenu()
        Citizen.Wait(1000)
    end
end)

-- ============================================
-- UTILITIES
-- ============================================
local function lerp(a, b, t)
    if not a or not b or not t then
        return a or 0
    end
    return a + (b - a) * t
end

local function drawRect(x, y, w, h, r, g, b, a, round)
    Susano.DrawRectFilled(x, y, w, h, r, g, b, a, round or 0)
end

local function drawText(x, y, txt, size, r, g, b, a)
    if customFont then
        Susano.PushFont(customFont)
    end
    Susano.DrawText(x, y, txt, size, r, g, b, a or 1)
    if customFont then
        Susano.PopFont()
    end
end

local function calcTextY(boxY, boxH, fontSize)
    return boxY + (boxH / 2) - (fontSize / 2)
end

-- Consume async key transitions for a short time so Susano's "pressed" flags are cleared
local function clearMenuInputBuffer()
    local keys = {0x0D, 0x08, 0x25, 0x26, 0x27, 0x28, 0x45} -- ENTER, BACKSPACE, LEFT, UP, RIGHT, DOWN, E
    -- call GetAsyncKeyState a few times across frames to reset transition flags
    for i = 1, 3 do
        for _, vk in ipairs(keys) do
            pcall(function() Susano.GetAsyncKeyState(vk) end)
        end
        Citizen.Wait(0)
    end
end

    -- ============================================
    -- MENU-INTEGRATED FREECAM (no changes to freecam.lua)
    -- ============================================
    -- Mirror of freecam.lua logic (menu-controlled, 1:1 behavior)
    local menuFreecamEnabled = false
    local cameraSpeed = 1.5
    -- Keys
    local FK_SHIFT = 0x10
    local FK_CTRL = 0x11
    local FK_SPACE = 0x20
    local FK_W = 0x57
    local FK_A = 0x41
    local FK_S = 0x53
    local FK_D = 0x44
    local FK_LBUTTON = 0x01

    -- Control IDs and constants (match freecam.lua)
    local INPUT_WEAPON_WHEEL_NEXT = 14
    local INPUT_WEAPON_WHEEL_PREV = 15
    local INPUT_ATTACK = 24
    local UNARMED_HASH = 0xA2719263

    local weaponWheelIgnored = false

    local camPos = {x = 0.0, y = 0.0, z = 0.0}
    local modes = {"Look Around", "Shoot Car", "Map Destroyer", "Teleport"}
    local currentModeIndex = 1

    local CAR_HASH = "asea"
    local CAR_VELOCITY = 120.0
    local DESTROYER_OBJECT = "ar_prop_ar_neon_gate8x_03a"
    local SPAWN_OFFSET = 3.0

    local function changeMode(direction)
        currentModeIndex = currentModeIndex + direction
        if currentModeIndex > #modes then
            currentModeIndex = 1
        elseif currentModeIndex < 1 then
            currentModeIndex = #modes
        end
    end

    local function MenuFreecam_SetEnabled(enabled)
        enabled = enabled and true or false
        if menuFreecamEnabled == enabled then
            return
        end
        menuFreecamEnabled = enabled

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local onFoot = (veh == 0)

        if enabled then
            local camCoords = GetGameplayCamCoord()
            camPos.x = camCoords.x
            camPos.y = camCoords.y
            camPos.z = camCoords.z

            if onFoot then
                -- Do not make the player invincible; only immobilize them
                SetPedMoveRateOverride(ped, 0.0)
                TaskStandStill(ped, -1)
                SetPedCanRagdoll(ped, false)
            else
                DisableControlAction(0, 75, true)
            end
            Susano.LockCameraPos(true)
            Citizen.InvokeNative(0xD22E810BD1784E07, true)
            weaponWheelIgnored = true
            -- Consume potential leftover mouse transitions (e.g., LMB pressed before enabling)
            for i = 1, 3 do
                pcall(function() Susano.GetAsyncKeyState(FK_LBUTTON) end)
                Citizen.Wait(0)
            end
        else
            SetCurrentPedWeapon(ped, UNARMED_HASH, true)

            if onFoot then
                SetPedMoveRateOverride(ped, 1.0)
                ClearPedTasks(ped)
                SetPedCanRagdoll(ped, true)
            end

            for i = 1, 5 do
                DisableControlAction(0, INPUT_WEAPON_WHEEL_NEXT, true)
                DisableControlAction(0, INPUT_WEAPON_WHEEL_PREV, true)
                Citizen.Wait(0)
            end

            Susano.LockCameraPos(false)
            Citizen.InvokeNative(0xD22E810BD1784E07, false)
            weaponWheelIgnored = false
        end
    end

    local function MenuFreecam_IsEnabled()
        return menuFreecamEnabled
    end

    -- Movement and mode thread (ports original freecam.lua behavior)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            if not menuFreecamEnabled then goto cont_freecam end

            -- mode switching
            local scrollUp = IsControlJustPressed(0, INPUT_WEAPON_WHEEL_PREV)
            local scrollDown = IsControlJustPressed(0, INPUT_WEAPON_WHEEL_NEXT)

            if scrollUp then changeMode(-1) end
            if scrollDown then changeMode(1) end

            -- movement
            local speedMultiplier = cameraSpeed
            if Susano.GetAsyncKeyState(FK_SHIFT) then speedMultiplier = cameraSpeed * 3 end

            local wDown = Susano.GetAsyncKeyState(FK_W)
            local aDown = Susano.GetAsyncKeyState(FK_A)
            local sDown = Susano.GetAsyncKeyState(FK_S)
            local dDown = Susano.GetAsyncKeyState(FK_D)
            local spaceDown = Susano.GetAsyncKeyState(FK_SPACE)
            local ctrlDown = Susano.GetAsyncKeyState(FK_CTRL)

            local lButtonHeld, lButtonPressed = Susano.GetAsyncKeyState(FK_LBUTTON)

            local rx, ry, rz = Susano.GetCameraAngles()
            local forwardX, forwardY, forwardZ = rx, ry, rz
            local len = math.sqrt(forwardX*forwardX + forwardY*forwardY + forwardZ*forwardZ)
            if len > 0.0 then
                forwardX = forwardX / len
                forwardY = forwardY / len
                forwardZ = forwardZ / len
            end

            local rightX = forwardY
            local rightY = -forwardX

            if wDown then
                camPos.x = camPos.x + forwardX * speedMultiplier
                camPos.y = camPos.y + forwardY * speedMultiplier
                camPos.z = camPos.z + forwardZ * speedMultiplier
            end
            if sDown then
                camPos.x = camPos.x - forwardX * speedMultiplier
                camPos.y = camPos.y - forwardY * speedMultiplier
                camPos.z = camPos.z - forwardZ * speedMultiplier
            end
            if aDown then
                camPos.x = camPos.x - rightX * speedMultiplier
                camPos.y = camPos.y - rightY * speedMultiplier
            end
            if dDown then
                camPos.x = camPos.x + rightX * speedMultiplier
                camPos.y = camPos.y + rightY * speedMultiplier
            end
            if spaceDown then camPos.z = camPos.z + speedMultiplier end
            if ctrlDown then camPos.z = camPos.z - speedMultiplier end

            Susano.SetCameraPos(camPos.x, camPos.y, camPos.z)
            SetFocusPosAndVel(camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0)

            -- mode actions
            if lButtonPressed then
                if currentModeIndex == 2 then -- Shoot Car
                    local carModel = CAR_HASH
                    local spawnDist = 3.0

                    local spX = camPos.x + (forwardX * spawnDist)
                    local spY = camPos.y + (forwardY * spawnDist)
                    local spZ = camPos.z + (forwardZ * spawnDist)
                    local heading = math.deg(math.atan2(-forwardX, forwardY))

                    local injectedCode = string.format([[ 
                        local forwardX = %f
                        local forwardY = %f
                        local forwardZ = %f
                        local CAR_VELOCITY = %f
                        local spX = %f
                        local spY = %f
                        local spZ = %f
                        local heading = %f
                        local carModel = "%s"
                        
                        ESX.Game.SpawnVehicle(carModel, {x = spX, y = spY, z = spZ}, heading, function(vehicle)
                            if vehicle ~= 0 then
                                SetEntityCoords(vehicle, spX, spY, spZ, true, false, false, true)
                                SetEntityVelocity(vehicle, forwardX * CAR_VELOCITY, forwardY * CAR_VELOCITY, forwardZ * CAR_VELOCITY)
                            end
                        end, true)
                    ]], forwardX, forwardY, forwardZ, CAR_VELOCITY, spX, spY, spZ, heading, carModel)

                    Susano.InjectResource("es_extended", injectedCode)
                elseif currentModeIndex == 3 then -- Map Destroyer
                    local spawnDist = SPAWN_OFFSET
                    local spX = camPos.x
                    local spY = camPos.y
                    local spZ = camPos.z

                    local injectedCode = string.format([[ 
                        local spX = %f
                        local spY = %f
                        local spZ = %f
                        local objectModel = "%s"
                        
                        local spawnCoords = vector3(spX, spY, spZ)
                        
                        ESX.Game.SpawnObject(objectModel, spawnCoords, function(obj)
                            
                        end, true)
                    ]], spX, spY, spZ, DESTROYER_OBJECT)

                    Susano.InjectResource("es_extended", injectedCode)
                elseif currentModeIndex == 4 then -- Teleport
                    local ped = PlayerPedId()
                    SetEntityCoords(ped, camPos.x, camPos.y, camPos.z, true, false, false, true)
                    -- After teleport, keep player immobilized (TaskStandStill) but NOT invincible
                    local veh = GetVehiclePedIsIn(ped, false)
                    local onFoot = (veh == 0)
                    if onFoot then
                        SetPedMoveRateOverride(ped, 0.0)
                        TaskStandStill(ped, -1)
                        SetPedCanRagdoll(ped, false)
                    end
                end
            end

            ::cont_freecam::
        end
    end)

    -- UI thread (mirror original)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            Susano.BeginFrame()
            if menuFreecamEnabled then
                local screenW, screenH = GetActiveScreenResolution()
                local fontSize = 24
                local spacing = 30

                -- Crosshair center
                local centerX, centerY = screenW / 2, screenH / 2
                Susano.DrawCircle(centerX, centerY, 4, true, 1, 1, 1, 1, 2, 32)

                local CENTER_Y_POSITION = screenH - 100

                local startIndex = currentModeIndex - 1
                local endIndex = currentModeIndex + 1

                if startIndex < 1 then startIndex = 1 end
                if endIndex > #modes then endIndex = #modes end

                for i = startIndex, endIndex do
                    local modeName = modes[i]
                    local r, g, b, a = 1, 1, 1, 1
                    if i == currentModeIndex then
                        r, g, b = 0, 0.5, 1
                    end

                    local relativeOffset = i - currentModeIndex
                    local textY = CENTER_Y_POSITION + (relativeOffset * spacing)

                    -- Use custom font if available for accurate sizing and rendering
                    if customFont then Susano.PushFont(customFont) end
                    local textWidth = Susano.GetTextWidth(modeName, fontSize) or 80
                    local textX = (screenW / 2) - (textWidth / 2)

                    Susano.DrawText(textX, textY, modeName, fontSize, r, g, b, a)
                    if customFont then Susano.PopFont() end
                end
            end
            Susano.SubmitFrame()
        end
    end)

-- ============================================
-- KEY SETUP SYSTEM
-- ============================================
local keyNames = {
    -- Function keys
    [0x70] = "F1",
    [0x71] = "F2",
    [0x72] = "F3",
    [0x73] = "F4",
    [0x74] = "F5",
    [0x75] = "F6",
    [0x76] = "F7",
    [0x77] = "F8",
    [0x78] = "F9",
    [0x79] = "F10",
    [0x7A] = "F11",
    [0x7B] = "F12",
    -- Navigation
    [0x2D] = "INSERT",
    [0x2E] = "DELETE",
    [0x24] = "HOME",
    [0x23] = "END",
    [0x21] = "PAGE UP",
    [0x22] = "PAGE DOWN",
    [0x08] = "BACKSPACE",
    [0x09] = "TAB",
    [0x14] = "CAPS LOCK",
    -- Numpad
    [0x60] = "NUMPAD 0",
    [0x61] = "NUMPAD 1",
    [0x62] = "NUMPAD 2",
    [0x63] = "NUMPAD 3",
    [0x64] = "NUMPAD 4",
    [0x65] = "NUMPAD 5",
    [0x66] = "NUMPAD 6",
    [0x67] = "NUMPAD 7",
    [0x68] = "NUMPAD 8",
    [0x69] = "NUMPAD 9",
    [0x6A] = "NUMPAD *",
    [0x6B] = "NUMPAD +",
    [0x6D] = "NUMPAD -",
    [0x6E] = "NUMPAD .",
    [0x6F] = "NUMPAD /",
    -- Arrows
    [0x25] = "LEFT ARROW",
    [0x26] = "UP ARROW",
    [0x27] = "RIGHT ARROW",
    [0x28] = "DOWN ARROW",
    -- Letters A-Z
    [0x41] = "A",
    [0x42] = "B",
    [0x43] = "C",
    [0x44] = "D",
    [0x45] = "E",
    [0x46] = "F",
    [0x47] = "G",
    [0x48] = "H",
    [0x49] = "I",
    [0x4A] = "J",
    [0x4B] = "K",
    [0x4C] = "L",
    [0x4D] = "M",
    [0x4E] = "N",
    [0x4F] = "O",
    [0x50] = "P",
    [0x51] = "Q",
    [0x52] = "R",
    [0x53] = "S",
    [0x54] = "T",
    [0x55] = "U",
    [0x56] = "V",
    [0x57] = "W",
    [0x58] = "X",
    [0x59] = "Y",
    [0x5A] = "Z",
    -- Numbers 0-9
    [0x30] = "0",
    [0x31] = "1",
    [0x32] = "2",
    [0x33] = "3",
    [0x34] = "4",
    [0x35] = "5",
    [0x36] = "6",
    [0x37] = "7",
    [0x38] = "8",
    [0x39] = "9",
    -- Modifiers
    [0x10] = "SHIFT",
    [0xA0] = "LEFT SHIFT",
    [0xA1] = "RIGHT SHIFT",
    [0x11] = "CTRL",
    [0xA2] = "LEFT CTRL",
    [0xA3] = "RIGHT CTRL",
    [0x12] = "ALT",
    [0xA4] = "LEFT ALT",
    [0xA5] = "RIGHT ALT",
    [0x5B] = "LEFT WIN",
    [0x5C] = "RIGHT WIN",
    -- Special
    [0x20] = "SPACE",
    [0x0D] = "ENTER",
    [0x1B] = "ESC",
    [0xBA] = ";",
    [0xBB] = "=",
    [0xBC] = ",",
    [0xBD] = "-",
    [0xBE] = ".",
    [0xBF] = "/",
    [0xC0] = "`",
    [0xDB] = "[",
    [0xDC] = "\\",
    [0xDD] = "]",
    [0xDE] = "'",
    [0x90] = "NUM LOCK",
    [0x91] = "SCROLL LOCK",
    [0x13] = "PAUSE"
}

local function renderKeySetup()
    local cx, cy = screenW / 2, screenH / 2
    local boxW, boxH = 500, 200
    local boxX, boxY = cx - boxW / 2, cy - boxH / 2

    -- Background
    drawRect(boxX, boxY, boxW, boxH, 0.05, 0.05, 0.05, 0.95, 12)

    -- Header
    local headerText = "GELG - KEY SETUP"
    local headerSize = 24
    if customFont then
        Susano.PushFont(customFont)
    end
    local headerW = Susano.GetTextWidth(headerText, headerSize) or 200
    if customFont then
        Susano.PopFont()
    end
    local headerX = cx - headerW / 2
    local headerY = boxY + 30
    drawText(headerX, headerY, headerText, headerSize, 0.2, 0.6, 1.0, 1)

    -- Instructions
    local instrText = "Press any key to bind menu open..."
    local instrSize = 16
    if customFont then
        Susano.PushFont(customFont)
    end
    local instrW = Susano.GetTextWidth(instrText, instrSize) or 250
    if customFont then
        Susano.PopFont()
    end
    local instrX = cx - instrW / 2
    local instrY = cy - 10
    drawText(instrX, instrY, instrText, instrSize, 0.7, 0.7, 0.75, 1)

    -- Confirm text
    local confirmText = "Then press ENTER to confirm"
    local confirmSize = 14
    if customFont then
        Susano.PushFont(customFont)
    end
    local confirmW = Susano.GetTextWidth(confirmText, confirmSize) or 200
    if customFont then
        Susano.PopFont()
    end
    local confirmX = cx - confirmW / 2
    local confirmY = cy + 20
    drawText(confirmX, confirmY, confirmText, confirmSize, 0.5, 0.5, 0.55, 1)
end

local function setupMenuKey()
    print("^4[GELG]^7 Key Setup - Press any key to bind menu open...")

    local selectedKey = nil
    local keyName = "..."

    -- Wait for key press and allow changing
    local waitingForConfirm = false

    while not waitingForConfirm do
        Susano.BeginFrame()

        local cx, cy = screenW / 2, screenH / 2
        local boxW, boxH = 500, 200
        local boxX, boxY = cx - boxW / 2, cy - boxH / 2

        drawRect(boxX, boxY, boxW, boxH, 0.05, 0.05, 0.05, 0.95, 12)

        local headerText = "GELG - KEY SETUP"
        local headerSize = 24
        if customFont then
            Susano.PushFont(customFont)
        end
        local headerW = Susano.GetTextWidth(headerText, headerSize) or 200
        if customFont then
            Susano.PopFont()
        end
        drawText(cx - headerW / 2, boxY + 30, headerText, headerSize, 0.2, 0.6, 1.0, 1)

        local keyText = selectedKey and ("Selected: " .. keyName) or "Press any key..."
        local keySize = 18
        if customFont then
            Susano.PushFont(customFont)
        end
        local keyW = Susano.GetTextWidth(keyText, keySize) or 150
        if customFont then
            Susano.PopFont()
        end
        local keyR, keyG, keyB = selectedKey and 0.3 or 0.7, selectedKey and 0.75 or 0.7, selectedKey and 1.0 or 0.75
        drawText(cx - keyW / 2, cy - 10, keyText, keySize, keyR, keyG, keyB, 1)

        local confirmText = "Press ENTER to confirm"
        local confirmSize = 14
        if customFont then
            Susano.PushFont(customFont)
        end
        local confirmW = Susano.GetTextWidth(confirmText, confirmSize) or 200
        if customFont then
            Susano.PopFont()
        end
        drawText(cx - confirmW / 2, cy + 20, confirmText, confirmSize, 0.5, 0.5, 0.55, 1)

        Susano.SubmitFrame()

        -- Check for ENTER to confirm
        local _, enterPressed = Susano.GetAsyncKeyState(0x0D)
        if enterPressed and selectedKey then
            waitingForConfirm = true
            Menu.openKey = selectedKey
            Menu.unlocked = true
            print(string.format("^4[GELG]^7 Menu key bound to: %s", keyName))
            Wait(200)
            break
        end

        -- Schneller Key Catch: nehme einfach den ersten erkannten Tastendruck (außer Enter)
        if not selectedKey then
        for vk = 0x01, 0xFE do
            if vk ~= 0x0D then -- Skip ENTER
                local _, pressed = Susano.GetAsyncKeyState(vk)
                if pressed then
                    selectedKey = vk
                    keyName = keyNames[vk] or "UNKNOWN KEY"
                    print(string.format("^4[GELG]^7 Key selected: %s (can change before ENTER)", keyName))
                    break
                    end
                end
            end
        else
            -- Optional: Key-Änderung zulassen, falls erneut Taste gedrückt wird
            for vk = 0x01, 0xFE do
                if vk ~= 0x0D then
                    local _, pressed = Susano.GetAsyncKeyState(vk)
                    if pressed and vk ~= selectedKey then
                        selectedKey = vk
                        keyName = keyNames[vk] or "UNKNOWN KEY"
                        print(string.format("^4[GELG]^7 Key gewechselt: %s", keyName))
                        break
                    end
                end
            end
        end

        Wait(0)
    end
end

-- ============================================
-- SILENT KILL RAGEBOT CODE 🔥
-- ============================================
local silentKillRadius = 100

local function getPlayerInCircleSilent()
    local centerX, centerY = screenW / 2, screenH / 2
    local closest, closestDist = nil, silentKillRadius + 1

    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() then
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                local headPos = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
                local onScreen, sx, sy = Susano.WorldToScreen(headPos.x, headPos.y, headPos.z)
                if onScreen then
                    local dist = math.sqrt((sx - centerX) ^ 2 + (sy - centerY) ^ 2)
                    if dist <= silentKillRadius and dist < closestDist then
                        closest = {
                            ped = ped,
                            playerId = playerId,
                            serverId = GetPlayerServerId(playerId),
                            name = GetPlayerName(playerId) or "Unknown"
                        }
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local function silentKill(target)
    if not target or not DoesEntityExist(target.ped) then
        return
    end

    CreateThread(
        function()
            local model = GetHashKey("polmav")
            RequestModel(model)
            local timeout = 0
            while not HasModelLoaded(model) and timeout < 100 do
                Wait(10)
                timeout = timeout + 1
            end

            if not HasModelLoaded(model) then
                print("[Silent Kill] Failed to load polmav model")
                return
            end

            local coords = GetEntityCoords(target.ped)
            local heading = GetEntityHeading(target.ped)
            local radians = math.rad(heading)
            local behindX = coords.x - math.sin(radians) * 1.0
            local behindY = coords.y + math.cos(radians) * 1.0

            local heli = Susano.CreateSpoofedVehicle(model, behindX, behindY, coords.z + 2.5, 0.0, true, true, false)

            if heli == 0 then
                print("[Silent Kill] Failed to create spoofed vehicle")
                SetModelAsNoLongerNeeded(model)
                return
            end

            SetEntityVisible(heli, false, false)
            SetEntityRotation(heli, 180.0, 0.0, 0.0, 2, true)
            SetVehicleEngineOn(heli, true, true, false)
            SetEntityProofs(heli, false, false, false, true, false, false, false, false)

            local startTime = GetGameTimer()
            local duration = 5000

            while (GetGameTimer() - startTime) < duration do
                if not DoesEntityExist(target.ped) or IsPedDeadOrDying(target.ped, true) then
                    break
                end

                coords = GetEntityCoords(target.ped)
                heading = GetEntityHeading(target.ped)
                radians = math.rad(heading)
                behindX = coords.x - math.sin(radians) * 1.0
                behindY = coords.y + math.cos(radians) * 1.0

                SetEntityCoordsNoOffset(heli, behindX, behindY, coords.z + 2.5, true, true, true)

                if GetGameTimer() - startTime < 1000 then
                    SetHeliBladesSpeed(heli, 1.0)
                else
                    SetHeliBladesSpeed(heli, 0.0)
                end

                Wait(0)
            end

            if DoesEntityExist(heli) then
                DeleteEntity(heli)
            end
            SetModelAsNoLongerNeeded(model)
        end
    )
end

local function renderSilentKill()
    local cx, cy = screenW / 2, screenH / 2
    local target = getPlayerInCircleSilent()
    local r, g, b = 1.0, 1.0, 1.0

    if target then
        r, g, b = 1.0, 0.0, 0.0
    end

    Susano.DrawCircle(cx, cy, silentKillRadius, false, r, g, b, 0.8, 2, 64)
    Susano.DrawCircle(cx, cy, 3, true, r, g, b, 1, 1, 16)

    if target then
        local text = target.name
        local tw = Susano.GetTextWidth(text, 14) or 50
        drawText(cx - (tw / 2), cy - silentKillRadius - 20, text, 14, r, g, b, 1)
    end

    local _, pressed = Susano.GetAsyncKeyState(0x45) -- E key
    if pressed and target then
        silentKill(target)
    end
end

-- ============================================
-- AUTO RAGEBOT CODE
-- ============================================
local circleRadius = 100

local function getPlayerInCircle()
    local centerX, centerY = screenW / 2, screenH / 2
    local closest, closestDist = nil, circleRadius + 1

    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() then
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                local headPos = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
                local onScreen, sx, sy = Susano.WorldToScreen(headPos.x, headPos.y, headPos.z)
                if onScreen then
                    local dist = math.sqrt((sx - centerX) ^ 2 + (sy - centerY) ^ 2)
                    if dist <= circleRadius and dist < closestDist then
                        closest = {
                            ped = ped,
                            playerId = playerId,
                            serverId = GetPlayerServerId(playerId),
                            name = GetPlayerName(playerId) or "Unknown"
                        }
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local function carCrush(target)
    if not target or not DoesEntityExist(target.ped) then
        return
    end

    Citizen.CreateThread(
        function()
            local ped = target.ped
            local pos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local radians = math.rad(heading)
            local backwardX = -math.sin(radians)
            local backwardY = math.cos(radians)
            local spawnDistance = 50.0
            local spawnPos = vector3(pos.x + backwardX * spawnDistance, pos.y + backwardY * spawnDistance, pos.z + 2.0)

            local hash = GetHashKey("asea")
            RequestModel(hash)
            local timeout = 0
            while not HasModelLoaded(hash) and timeout < 100 do
                Citizen.Wait(10)
                timeout = timeout + 1
            end

            local car =
                Susano.CreateSpoofedVehicle(hash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, true, false)
            if car == 0 then
                SetModelAsNoLongerNeeded(hash)
                return
            end

            SetEntityProofs(car, false, false, false, true, false, false, false, false)
            SetEntityInvincible(car, true)
            SetEntityVisible(car, false, false)
            SetEntityAlpha(car, 0, false)

            local startTime = GetGameTimer()
            local duration = 500

            while (GetGameTimer() - startTime) < duration and DoesEntityExist(car) and DoesEntityExist(ped) do
                pos = GetEntityCoords(ped)
                local carPos = GetEntityCoords(car)
                local dirX = pos.x - carPos.x
                local dirY = pos.y - carPos.y
                local dirZ = pos.z - carPos.z
                local length = math.sqrt(dirX * dirX + dirY * dirY + dirZ * dirZ)
                if length > 0 then
                    dirX, dirY, dirZ = dirX / length, dirY / length, dirZ / length
                end
                SetEntityVelocity(car, dirX * 150.0, dirY * 150.0, dirZ * 150.0)
                Citizen.Wait(0)
            end

            Citizen.Wait(1000)
            if DoesEntityExist(car) then
                DeleteEntity(car)
            end
            SetModelAsNoLongerNeeded(hash)
        end
    )
end

local function renderRagebot()
    local cx, cy = screenW / 2, screenH / 2
    local target = getPlayerInCircle()
    local cfg = Menu.cfg
    local r, g, b = 1.0, 0.0, 0.0

    if not target then
        r, g, b = 1.0, 1.0, 1.0
    end

    Susano.DrawCircle(cx, cy, circleRadius, false, r, g, b, 0.8, 2, 64)
    Susano.DrawCircle(cx, cy, 3, true, r, g, b, 1, 1, 16)

    if target then
        local text = target.name
        local tw = Susano.GetTextWidth(text, 14) or 50
        drawText(cx - (tw / 2), cy - circleRadius - 18, text, 14, r, g, b, 1)
    end

    local _, pressed = Susano.GetAsyncKeyState(0x45)
    if pressed then
        local t = getPlayerInCircle()
        if t then
            carCrush(t)
        end
    end
end

-- ============================================
-- PLAYER ID ESP
-- ============================================
local function renderIDESP()
    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() then
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                local pos = GetEntityCoords(ped)
                local onScreen, sx, sy = Susano.WorldToScreen(pos.x, pos.y, pos.z - 1.0)
                if onScreen then
                    local serverId = GetPlayerServerId(playerId)
                    local idText = "ID: " .. tostring(serverId)
                    local textWidth = Susano.GetTextWidth(idText, 12) or 35
                    -- Center text under player by subtracting half the measured width
                    -- Apply small configurable tweak for perfect centering
                    local xOffset = Menu.cfg.idTextOffset or 0
                    drawText(sx - (textWidth / 2) + xOffset, sy + 3, idText, 12, 1, 1, 1, 1)
                end
            end
        end
    end
end

-- NOTE: Ausweis and Mute exploit features removed per request

-- ============================================
-- VEHICLE SPAWNER WITH MULTI-BYPASS
-- ============================================
local function spawnVehicleObfuscated(model, plate, deletePrevious, teleportInto)
    if not model or model == "" then
        return
    end

    local function stringToBytes(str)
        local t = {}
        for i = 1, #str do
            t[i] = string.byte(str, i)
        end
        return "{" .. table.concat(t, ",") .. "}"
    end

    local modelBytes = stringToBytes(model)
    local plateBytes = stringToBytes(plate or "")
    local deletePrev = tostring(deletePrevious)
    local warpIn = tostring(teleportInto)

    local payload =
        string.format(
        [[
        local h = function(n, f)
            local o = _G[n]
            if o and type(o) == "function" then
                _G[n] = function(...) return f(o, ...) end
            end
        end
        local d = function(t)
            local s = ""
            for i = 1, #t do s = s .. string.char(t[i]) end
            return s
        end
        local g = function(e) return _G[d(e)] end
        local w = function(ms) Citizen.Wait(ms) end

        h(d({82,101,113,117,101,115,116,77,111,100,101,108}), function(o, m) return o(m) end)
        h(d({72,97,115,77,111,100,101,108,76,111,97,100,101,100}), function(o, m) return o(m) end)
        h(d({67,114,101,97,116,101,86,101,104,105,99,108,101}), function(o, m, x, y, z, h, n, p) return o(m, x, y, z, h, n, p) end)

        local function f()
            local p = g({80,108,97,121,101,114,80,101,100,73,100})()
            local c = g({71,101,116,69,110,116,105,116,121,67,111,111,114,100,115})(p)
            local mn = d(%s)
            local pl = d(%s)
            local mh = g({71,101,116,72,97,115,104,75,101,121})(mn)

            g({82,101,113,117,101,115,116,77,111,100,101,108})(mh)
            while not g({72,97,115,77,111,100,101,108,76,111,97,100,101,100})(mh) do w(0) end

            if %s then
                local cv = g({71,101,116,86,101,104,105,99,108,101,80,101,100,73,115,73,110})(p, false)
                if cv and g({68,111,101,115,69,110,116,105,116,121,69,120,105,115,116})(cv) then
                    g({68,101,108,101,116,101,69,110,116,105,116,121})(cv)
                end
            end

            local z = c.z + 1.0
            local v = g({67,114,101,97,116,101,86,101,104,105,99,108,101})(mh, c.x, c.y, z, 0.0, true, false)

            if v and g({68,111,101,115,69,110,116,105,116,121,69,120,105,115,116})(v) then
                if pl ~= "" then
                    g({83,101,116,86,101,104,105,99,108,101,78,117,109,98,101,114,80,108,97,116,101,84,101,120,116})(v, pl)
                end
                
                if %s then
                    g({84,97,115,107,87,97,114,112,80,101,100,73,110,116,111,86,101,104,105,99,108,101})(p, v, -1)
                    w(100)
                end
            end
        end

        local co = coroutine.create(f)
        while coroutine.status(co) ~= "dead" do
            local ok = coroutine.resume(co)
            if not ok then break end
            w(0)
        end
    ]],
        modelBytes,
        plateBytes,
        deletePrev,
        warpIn
    )

    local targetResource = nil
    if GetResourceState("monitor") == "started" then
        targetResource = "monitor"
    elseif GetResourceState("ox_lib") == "started" then
        targetResource = "ox_lib"
    end

    if targetResource then
        Susano.InjectResource(targetResource, payload)
        return true
    end
    return false
end

local function spawnAseaMultiBypass()
    print("^4[GELG]^7 ═══════════════════════════════════")
    print("^4[GELG]^7 Starting multi-bypass vehicle spawn...")
    print("^4[GELG]^7 ═══════════════════════════════════")

    -- Get settings from menu
    local replaceVehicle = false
    local warpIntoVehicle = false

    for _, item in ipairs(Menu.spawnVehicleMenu) do
        if item.key == "replacevehicle" then
            replaceVehicle = item.enabled
        elseif item.key == "warpvehicle" then
            warpIntoVehicle = item.enabled
        end
    end

    -- If replace is enabled, always warp
    if replaceVehicle then
        warpIntoVehicle = true
    end

    print(
        string.format("^4[GELG]^7 Settings: Replace=%s, Warp=%s", tostring(replaceVehicle), tostring(warpIntoVehicle))
    )

    local model = "asea"
    local plate = "JSY 284"
    local playerPed = PlayerPedId()
    local initialVehicle = GetVehiclePedIsIn(playerPed, false)

    -- Method 1: lation_laundering Bypass
    print("^3[Method 1]^7 Trying lation_laundering bypass...")
    if GetResourceState("lation_laundering") == "started" then
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)

        if replaceVehicle and initialVehicle ~= 0 then
            DeleteEntity(initialVehicle)
            Wait(100)
        end

        Susano.InjectResource(
            "lation_laundering",
            string.format(
                [[
            local coords = vector3(%f, %f, %f)
            local heading = %f
            SpawnVehicle("%s", vec4(coords.x, coords.y, coords.z, heading))
            
            Wait(500)
            if %s then
                local veh = GetVehiclePedIsIn(PlayerPedId(), true)
                if veh and DoesEntityExist(veh) then
                    SetVehicleNumberPlateText(veh, "%s")
                    SetPedIntoVehicle(PlayerPedId(), veh, -1)
                end
            else
                local vehicles = GetGamePool('CVehicle')
                for _, v in ipairs(vehicles) do
                    local vCoords = GetEntityCoords(v)
                    if #(vector3(%f, %f, %f) - vCoords) < 5.0 then
                        SetVehicleNumberPlateText(v, "%s")
                        break
                    end
                end
            end
        ]],
                coords.x,
                coords.y,
                coords.z,
                heading,
                model:lower(),
                tostring(warpIntoVehicle),
                plate,
                coords.x,
                coords.y,
                coords.z,
                plate
            )
        )

        Wait(2000)
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        if currentVehicle ~= 0 and currentVehicle ~= initialVehicle then
            print("^2[Success]^7 lation_laundering bypass worked!")
            return
        end
        print("^1[Failed]^7 lation_laundering bypass failed, trying fallback...")
    else
        print("^1[Failed]^7 lation_laundering not found, trying fallback...")
    end

    -- Method 2: lc_utils Bypass
    print("^3[Method 2]^7 Trying lc_utils bypass...")
    if GetResourceState("lc_utils") == "started" then
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)

        if replaceVehicle and initialVehicle ~= 0 then
            DeleteEntity(initialVehicle)
            Wait(100)
        end

        Susano.InjectResource(
            "lc_utils",
            string.format(
                [[
            local originalIsPlayerNear = Utils.Entity.isPlayerNearCoords
            Utils.Entity.isPlayerNearCoords = function(coords, distance)
                return true
            end

            local coords = vector3(%f, %f, %f)
            local heading = %f
            local properties = { plate = "%s" }
            Utils.Vehicles.spawnVehicle("%s", coords.x, coords.y, coords.z, heading, nil, properties)

            Wait(500)
            if %s then
                local veh = GetVehiclePedIsIn(PlayerPedId(), true)
                if veh and DoesEntityExist(veh) then
                    SetPedIntoVehicle(PlayerPedId(), veh, -1)
                end
            end
            
            Utils.Entity.isPlayerNearCoords = originalIsPlayerNear
        ]],
                coords.x,
                coords.y,
                coords.z,
                heading,
                plate,
                model:lower(),
                tostring(warpIntoVehicle)
            )
        )

        Wait(2000)
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        if currentVehicle ~= 0 and currentVehicle ~= initialVehicle then
            print("^2[Success]^7 lc_utils bypass worked!")
            return
        end
        print("^1[Failed]^7 lc_utils bypass failed, trying fallback...")
    else
        print("^1[Failed]^7 lc_utils not found, trying fallback...")
    end

    -- Method 3: ESX Bypass
    print("^3[Method 3]^7 Trying ESX bypass...")
    if GetResourceState("es_extended") == "started" then
        Susano.InjectResource(
            "es_extended",
            string.format(
                [[
            CreateThread(function()
                while not ESX or not ESX.PlayerLoaded do Wait(100) end
                
                local ped = PlayerPedId()
                
                if %s then
                    local oldVeh = GetVehiclePedIsIn(ped, false)
                    if oldVeh ~= 0 then
                        DeleteEntity(oldVeh)
                        Wait(100)
                    end
                end
                
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                
                ESX.Game.SpawnVehicle("%s", coords, heading, function(vehicle)
                    if vehicle and DoesEntityExist(vehicle) then
                        SetVehicleNumberPlateText(vehicle, "%s")
                        if %s then
                            SetPedIntoVehicle(ped, vehicle, -1)
                            SetVehicleEngineOn(vehicle, true, true, false)
                        end
                    end
                end, true)
            end)
        ]],
                tostring(replaceVehicle),
                model,
                plate,
                tostring(warpIntoVehicle)
            )
        )

        Wait(2000)
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        if currentVehicle ~= 0 and currentVehicle ~= initialVehicle then
            print("^2[Success]^7 ESX bypass worked!")
            return
        end
        print("^1[Failed]^7 ESX bypass failed, trying fallback...")
    else
        print("^1[Failed]^7 ESX not found, trying fallback...")
    end

    -- Method 4: LB-Phone Bypass
    print("^3[Method 4]^7 Trying LB-Phone bypass...")
    if GetResourceState("lb-phone") == "started" then
        Susano.InjectResource(
            "lb-phone",
            string.format(
                [[
            CreateThread(function()
                local ped = PlayerPedId()
                
                if %s then
                    local oldVeh = GetVehiclePedIsIn(ped, false)
                    if oldVeh ~= 0 then
                        DeleteEntity(oldVeh)
                        Wait(100)
                    end
                end
                
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                
                local vehicleData = {
                    vehicle = json.encode({
                        model = "%s",
                        plate = "%s",
                        fuel = 100.0,
                        color1 = 0,
                        color2 = 0,
                        pearlescentColor = 0,
                        wheelColor = 0,
                        wheels = 0,
                        windowTint = 0,
                        neonEnabled = { false, false, false, false },
                        extras = {},
                        tyreBurst = { false, false, false, false, false, false },
                        tyreSmokeColor = { 255, 255, 255 }
                    }),
                    damages = json.encode({
                        engineHealth = 1000.0,
                        bodyHealth = 1000.0
                    })
                }
                
                local vehicle = CreateFrameworkVehicle(vehicleData, coords)
                
                if vehicle and %s then
                    SetPedIntoVehicle(ped, vehicle, -1)
                    SetVehicleEngineOn(vehicle, true, true, false)
                end
            end)
        ]],
                tostring(replaceVehicle),
                model,
                plate,
                tostring(warpIntoVehicle)
            )
        )

        Wait(2000)
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        if currentVehicle ~= 0 and currentVehicle ~= initialVehicle then
            print("^2[Success]^7 LB-Phone bypass worked!")
            return
        end
        print("^1[Failed]^7 LB-Phone bypass failed, trying fallback...")
    else
        print("^1[Failed]^7 LB-Phone not found, trying fallback...")
    end

    -- Method 5: Standard Susano.CreateSpoofedVehicle
    print("^3[Method 5]^7 Trying standard Susano.CreateSpoofedVehicle...")
    CreateThread(
        function()
            if replaceVehicle and initialVehicle ~= 0 then
                DeleteEntity(initialVehicle)
                Wait(100)
            end

            local hash = GetHashKey(model)
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(0)
            end

            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)

            local vehicle = Susano.CreateSpoofedVehicle(hash, coords.x, coords.y, coords.z, heading, true, true, false)

            if vehicle ~= 0 then
                SetVehicleNumberPlateText(vehicle, plate)
                if warpIntoVehicle then
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                end
                SetVehicleEngineOn(vehicle, true, true, false)
                print("^2[Success]^7 Standard Susano method worked!")
                return
            else
                print("^1[Failed]^7 Susano method failed, trying fallback...")
            end
        end
    )

    Wait(2000)
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    if currentVehicle ~= 0 and currentVehicle ~= initialVehicle then
        print("^2[Success]^7 Standard Susano method worked!")
        return
    end

    -- Method 6: Obfuscated Spawner (Last Resort)
    print("^3[Method 6]^7 Trying obfuscated spawner (last resort)...")
    if spawnVehicleObfuscated(model, plate, replaceVehicle, warpIntoVehicle) then
        Wait(3000)

        local coords = GetEntityCoords(playerPed)
        local vehicles = GetGamePool("CVehicle")
        local spawnedVehicle = nil

        for _, veh in ipairs(vehicles) do
            local vehPlate = GetVehicleNumberPlateText(veh)
            local vehCoords = GetEntityCoords(veh)
            local distance = #(coords - vehCoords)

            if distance < 10.0 and vehPlate and string.find(vehPlate, "JSY") then
                spawnedVehicle = veh
                break
            end
        end

        if spawnedVehicle then
            print("^2[Success]^7 Obfuscated spawner worked!")
            return
        end
        print("^1[Failed]^7 Obfuscated spawner failed!")
    else
        print("^1[Failed]^7 No suitable resource for obfuscation!")
    end

    print("^1[GELG]^7 All methods failed to spawn vehicle!")
end

-- ============================================
-- TRIGGER SCANNER
-- ============================================
local triggersList = {
    -- Removed Ausweis and Mute exploit entries
    {
        name = "Give Vehicle Keys",
        key = "vehiclekeys",
        type = "action",
        resource = "vehicles_keys",
        trigger = "vehicles_keys:selfGiveCurrentVehicleKeys"
    },
    {
        name = "Revive",
        key = "revive",
        type = "action",
        selectedOption = 1,
        options = {
            {name = "visn_are", event = "visn_are:resetHealthBuffer", resource = "visn_are"},
            {name = "esx_ambulance", event = "esx_ambulancejob:revive", resource = "esx_ambulancejob"},
            {name = "wasabi_ambulance", event = "wasabi_ambulance:revive", resource = "wasabi_ambulance"}
        }
    }
}

local function rebuildTriggersMenu()
    -- Reset to base menu
    Menu.triggersMenu = {
        {name = "Find Triggers", key = "findtriggers", type = "action"},
        {name = "Show All Triggers", key = "showtriggers", type = "action"}
    }
end

local function findTriggers()
    print("^4[GELG]^7 ═══════════════════════════════════")
    print("^4[GELG]^7 Scanning for trigger resources...")
    print("^4[GELG]^7 ═══════════════════════════════════")

    rebuildTriggersMenu()

    for _, t in ipairs(triggersList) do
        local available = false

        if t.resource then
            available = GetResourceState(t.resource) == "started"
        elseif t.options then
            for idx, opt in ipairs(t.options) do
                if opt.resource and GetResourceState(opt.resource) == "started" then
                    available = true
                    -- If this trigger has multiple options (like Revive), preselect the one whose resource is available
                    t.selectedOption = idx
                    break
                end
            end
        end

        if available then
            print(string.format("^2[✓]^7 %s - ^2AVAILABLE^7", t.name))
            table.insert(Menu.triggersMenu, t)
        else
            local resName = t.resource or "multiple resources"
            print(string.format("^1[✗]^7 %s - ^1NOT FOUND^7 (looking for: %s)", t.name, resName))
        end
    end

    print("^4[GELG]^7 ═══════════════════════════════════")

    -- Reset selection if needed
    if Menu.currentMenu == "triggers" and Menu.selected > #Menu.triggersMenu then
        Menu.selected = 1
    end
end

local function showAllTriggers()
    -- Reset menu first
    rebuildTriggersMenu()

    -- Load triggers one-by-one on a separate thread so Wait() yields properly
    Citizen.CreateThread(function()
        print("^4[GELG]^7 ═══════════════════════════════════")
        print("^4[GELG]^7 Loading all triggers...")
        print("^4[GELG]^7 ═══════════════════════════════════")

        for _, t in ipairs(triggersList) do
            table.insert(Menu.triggersMenu, t)
            -- Optional console log to show progress
            print(string.format("^4[GELG]^7 Added trigger: %s", t.name))
            -- Pace additions so they appear sequentially in the UI
            Wait(250)
        end

        -- Finished loading
        print("^4[GELG]^7 Done loading triggers.")

        -- Reset selection if needed
        if Menu.currentMenu == "triggers" and Menu.selected > #Menu.triggersMenu then
            Menu.selected = 1
        end
    end)
end

-- ============================================
-- MENU RENDERING
-- ============================================
local function getCurrentItems()
    if Menu.currentMenu == "main" then
        return Menu.features
    elseif Menu.currentMenu == "triggers" then
        return Menu.triggersMenu
    elseif Menu.currentMenu == "vehicle" then
        return Menu.vehicleMenu
    elseif Menu.currentMenu == "spawnvehicle" then
        return Menu.spawnVehicleMenu
    elseif Menu.currentMenu == "combat" then
        return Menu.combatMenu
    elseif Menu.currentMenu == "settings" then
        return Menu.settingsMenu
    elseif Menu.currentMenu == "misc" then
        return Menu.miscMenu
    elseif Menu.currentMenu == "players" then
        return Menu.playersMenu
    end

end

local function renderMenu()
    if Menu.alpha < 0.01 then
        return
    end

    local cfg = Menu.cfg
    local items = getCurrentItems()
    local paddingBottom = 13
    local breadcrumbH = 30 -- Height for breadcrumb area
    local totalH = cfg.headerH + breadcrumbH + (#items * cfg.itemH) + 10 + paddingBottom

    local x = 60
    local y = (screenH - totalH) / 2
    local w = cfg.w
    local alpha = Menu.alpha

    Menu.selectionY = lerp(Menu.selectionY, Menu.targetY, 0.25)

    drawRect(x, y, w, totalH, 0.05, 0.05, 0.05, 0.75 * alpha, cfg.rounding)

    -- Draw banner image instead of black background and GELG text
    if bannerTexture then
        Susano.DrawImage(bannerTexture, x, y, w, cfg.headerH, 1, 1, 1, alpha, 0)
    else
        -- Fallback to old style if banner not loaded
        drawRect(x, y, w, cfg.headerH, 0.03, 0.03, 0.03, 0.95 * alpha, cfg.rounding)
        drawRect(x, y + cfg.headerH - 10, w, 10, 0.03, 0.03, 0.03, 0.95 * alpha, 0)

        local titleY = calcTextY(y, cfg.headerH, 30)
        local titleText = "GELG"

        local titleW = 90
        if customFont then
            Susano.PushFont(customFont)
            titleW = Susano.GetTextWidth(titleText, 30) or 90
            Susano.PopFont()
        else
            titleW = Susano.GetTextWidth(titleText, 30) or 90
        end
        local titleX = x + (w - titleW) / 2
        drawText(titleX, titleY, titleText, 30, cfg.accent[1], cfg.accent[2], cfg.accent[3], alpha)
    end

    drawRect(x, y + cfg.headerH, w, 2, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 0)

    -- Breadcrumb area
    local breadcrumbY = y + cfg.headerH
    local breadcrumbText = "Main"
    if Menu.currentMenu == "players" then
        breadcrumbText = "Main > Players"
    elseif Menu.currentMenu == "combat" then
        breadcrumbText = "Main > Combat"
    elseif Menu.currentMenu == "misc" then
        breadcrumbText = "Main > Miscellaneous"
    elseif Menu.currentMenu == "triggers" then
        breadcrumbText = "Main > Triggers"
    elseif Menu.currentMenu == "vehicle" then
        breadcrumbText = "Main > Vehicle"
    elseif Menu.currentMenu == "spawnvehicle" then
        breadcrumbText = "Main > Vehicle > Spawn Vehicle"
    elseif Menu.currentMenu == "settings" then
        breadcrumbText = "Main > Settings"
    end

    local breadcrumbTextSize = 15
    local breadcrumbTextW = 50
    if customFont then
        Susano.PushFont(customFont)
        breadcrumbTextW = Susano.GetTextWidth(breadcrumbText, breadcrumbTextSize) or 50
        Susano.PopFont()
    else
        breadcrumbTextW = Susano.GetTextWidth(breadcrumbText, breadcrumbTextSize) or 50
    end

    local breadcrumbTextX = x + (w - breadcrumbTextW) / 2
    local breadcrumbTextY = calcTextY(breadcrumbY, breadcrumbH, breadcrumbTextSize)
    drawText(
        breadcrumbTextX,
        breadcrumbTextY,
        breadcrumbText,
        breadcrumbTextSize,
        cfg.textDim[1],
        cfg.textDim[2],
        cfg.textDim[3],
        alpha
    )

    -- Line under breadcrumb
    drawRect(x, breadcrumbY + breadcrumbH - 2, w, 2, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 0)

    -- Items start after breadcrumb
    local itemsY = y + cfg.headerH + breadcrumbH + 5
    for i, item in ipairs(items) do
        local iy = itemsY + (i - 1) * cfg.itemH
        local sel = Menu.selected == i

        local nameY = calcTextY(iy, cfg.itemH, 15)
        local nameCol = sel and cfg.text or cfg.textDim

        -- Draw item name (without arrow for submenus)
        drawText(x + 28, nameY, item.name, 15, nameCol[1], nameCol[2], nameCol[3], alpha)

        if not Menu.toggleAnimations[i] then
            Menu.toggleAnimations[i] = item.enabled and 1 or 0
        end

        local targetPos = item.enabled and 1 or 0
        Menu.toggleAnimations[i] = lerp(Menu.toggleAnimations[i], targetPos, 0.2)

        if item.type == "toggle" then
            local tw, th = 50, 24
            local tx = x + w - tw - 28
            local ty = iy + (cfg.itemH - th) / 2

            local bgR = lerp(0.2, cfg.accent[1], Menu.toggleAnimations[i])
            local bgG = lerp(0.2, cfg.accent[2], Menu.toggleAnimations[i])
            local bgB = lerp(0.25, cfg.accent[3], Menu.toggleAnimations[i])

            drawRect(tx, ty, tw, th, bgR, bgG, bgB, alpha, 12)

            local circleX = tx + 12 + (Menu.toggleAnimations[i] * (tw - 24))
            Susano.DrawCircle(circleX, ty + th / 2, 10, true, 1, 1, 1, alpha, 1, 20)
        elseif item.type == "submenu" then
            -- Draw arrow on the right side, similar to toggles
            local arrowText = ">"
            local arrowSize = 15
            if customFont then
                Susano.PushFont(customFont)
            end
            local arrowW = Susano.GetTextWidth(arrowText, arrowSize) or 10
            if customFont then
                Susano.PopFont()
            end
            local arrowX = x + w - arrowW - 48
            drawText(arrowX, nameY, arrowText, arrowSize, nameCol[1], nameCol[2], nameCol[3], alpha)
        elseif item.type == "action" and item.options and item.selectedOption then
            local optName = item.options[item.selectedOption].name
            local optText = "<" .. optName .. ">"
            local optSize = 13
            if customFont then
                Susano.PushFont(customFont)
            end
            local optTextWidth = Susano.GetTextWidth(optText, optSize) or 50
            if customFont then
                Susano.PopFont()
            end
            local optX = x + w - optTextWidth - 28
            local optY = calcTextY(iy, cfg.itemH, optSize)
            drawText(optX, optY, optText, optSize, cfg.accent[1], cfg.accent[2], cfg.accent[3], alpha)
        end
    end

    local borderX = x
    local borderY = Menu.selectionY
    local borderW = w
    local borderH = cfg.itemH
    Susano.DrawRect(
        borderX,
        borderY,
        borderW,
        borderH,
        cfg.selectedBorder[1],
        cfg.selectedBorder[2],
        cfg.selectedBorder[3],
        cfg.selectedBorder[4] * alpha,
        2.5
    )

    if Menu.open then
        Menu.targetY = itemsY + (Menu.selected - 1) * cfg.itemH
    end
end

-- ============================================
-- INPUT HANDLING
-- ============================================
local keyDelay = 0

local function handleInput()
    if not Menu.open then
        return
    end

    local now = GetGameTimer()
    local cfg = Menu.cfg

    local backDown, backPressed = Susano.GetAsyncKeyState(0x08)
    local _, up = Susano.GetAsyncKeyState(0x26)
    local _, down = Susano.GetAsyncKeyState(0x28)
    local _, enter = Susano.GetAsyncKeyState(0x0D)
    local _, left = Susano.GetAsyncKeyState(0x25)
    local _, right = Susano.GetAsyncKeyState(0x27)

    -- Handle backspace separately (check both down and pressed)
    if (backDown or backPressed) and Menu.currentMenu ~= "main" then
        if now >= keyDelay then
            keyDelay = now + 250
            print("^4[GELG]^7 BACKSPACE detected, going back")

            local breadcrumbH = 35

            -- Navigate back based on current menu
            if Menu.currentMenu == "spawnvehicle" then
                Menu.currentMenu = "vehicle"
                Menu.selected = 1
                local totalH = cfg.headerH + breadcrumbH + (#Menu.vehicleMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
                Menu.selectionY = itemsY
            elseif Menu.currentMenu == "triggers" or Menu.currentMenu == "vehicle" or Menu.currentMenu == "settings" or Menu.currentMenu == "combat" or Menu.currentMenu == "players" or Menu.currentMenu == "misc" then
                Menu.currentMenu = "main"
                Menu.selected = 1
                local totalH = cfg.headerH + breadcrumbH + (#Menu.features * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
                Menu.selectionY = itemsY
            end
            Wait(100)
        end
        return
    end

    if not (up or down or enter or left or right) then
        return
    end

    if now < keyDelay then
        return
    end
    keyDelay = now + 120

    local items = getCurrentItems()
    local cfg = Menu.cfg

    if up then
        Menu.selected = Menu.selected - 1
        if Menu.selected < 1 then
            Menu.selected = #items
        end
        local breadcrumbH = 35
        local totalH = cfg.headerH + breadcrumbH + (#items * cfg.itemH) + 10
        local centerY = (screenH - totalH) / 2
        local itemsY = centerY + cfg.headerH + breadcrumbH + 5
        Menu.targetY = itemsY + (Menu.selected - 1) * cfg.itemH
    elseif down then
        Menu.selected = Menu.selected + 1
        if Menu.selected > #items then
            Menu.selected = 1
        end
        local breadcrumbH = 35
        local totalH = cfg.headerH + breadcrumbH + (#items * cfg.itemH) + 10
        local centerY = (screenH - totalH) / 2
        local itemsY = centerY + cfg.headerH + breadcrumbH + 5
        Menu.targetY = itemsY + (Menu.selected - 1) * cfg.itemH
    elseif left or right then
        local feature = items[Menu.selected]
        if feature.type == "action" and feature.options then
            if left then
                feature.selectedOption = feature.selectedOption - 1
                if feature.selectedOption < 1 then
                    feature.selectedOption = #feature.options
                end
            else
                feature.selectedOption = feature.selectedOption + 1
                if feature.selectedOption > #feature.options then
                    feature.selectedOption = 1
                end
            end
            
            -- Load banner if banner selection changed
            if feature.key == "bannerselect" and feature.selectedOption then
                local option = feature.options[feature.selectedOption]
                if option and option.value then
                    loadBanner(option.value)
                end
            elseif feature.key == "accentselect" and feature.selectedOption then
                local option = feature.options[feature.selectedOption]
                if option and option.color then
                    applyAccentColor(option.color, option.bright)
                    print(string.format("^4[GELG]^7 Accent set to: %s", option.name))
                end
            end
        end
    elseif enter then
        local feature = items[Menu.selected]

        if feature.type == "submenu" then
            if feature.key == "playersmenu" then
                Menu.currentMenu = "players"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.playersMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
                -- Ensure list is fresh when entering
                updatePlayersMenu()
            elseif feature.key == "triggersmenu" then
                Menu.currentMenu = "triggers"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.triggersMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
            elseif feature.key == "combatmenu" then
                Menu.currentMenu = "combat"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.combatMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
            elseif feature.key == "vehiclemenu" then
                Menu.currentMenu = "vehicle"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.vehicleMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
            elseif feature.key == "spawnvehiclemenu" then
                Menu.currentMenu = "spawnvehicle"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.spawnVehicleMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
            elseif feature.key == "settingsmenu" then
                Menu.currentMenu = "settings"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.settingsMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
            elseif feature.key == "miscmenu" then
                Menu.currentMenu = "misc"
                Menu.selected = 1
                local breadcrumbH = 35
                local totalH = cfg.headerH + breadcrumbH + (#Menu.miscMenu * cfg.itemH) + 10
                local centerY = (screenH - totalH) / 2
                local itemsY = centerY + cfg.headerH + breadcrumbH + 5
                Menu.targetY = itemsY
            end
        elseif feature.type == "toggle" then
            feature.enabled = not feature.enabled
            -- Special-case toggles that need external hooks
            if feature.key == "freecam" then
                if type(MenuFreecam_SetEnabled) == "function" then
                    pcall(MenuFreecam_SetEnabled, feature.enabled)
                elseif _G and type(_G.Freecam_SetEnabled) == "function" then
                    pcall(_G.Freecam_SetEnabled, feature.enabled)
                end
            end
        elseif feature.type == "action" then
            if feature.key == "findtriggers" then
                findTriggers()
            elseif feature.key == "showtriggers" then
                showAllTriggers()
            elseif feature.key == "spawnasea" then
                spawnAseaMultiBypass()
            elseif feature.key == "vehiclekeys" then
                -- Give vehicle keys via injection
                Susano.InjectResource(
                    "any",
                    [[
                    TriggerServerEvent("vehicles_keys:selfGiveCurrentVehicleKeys")
                ]]
                )
                print("^4[GELG]^7 Vehicle keys triggered!")
            elseif feature.options and feature.selectedOption then
                local option = feature.options[feature.selectedOption]
                if feature.key == "bannerselect" then
                    -- Banner selection - already loaded when changed with left/right
                    print(string.format("^4[GELG]^7 Banner selected: %s", option.name))
                else
                    print(string.format("^4[GELG]^7 Executing: %s", option.name))
                    if option.event then
                        TriggerEvent(option.event)
                    end
                end
            end
        end
    end
end

-- ============================================
-- MAIN LOOP
-- ============================================
Citizen.CreateThread(
    function()
        -- Setup key first
        setupMenuKey()

        print(string.format("^4[GELG]^7 Menu Loaded! Press your key to open 🔵"))

        local cfg = Menu.cfg
        local breadcrumbH = 35
        local totalH = cfg.headerH + breadcrumbH + (#Menu.features * cfg.itemH) + 10
        local centerY = (screenH - totalH) / 2
        Menu.selectionY = centerY + cfg.headerH + breadcrumbH + 5
        Menu.targetY = Menu.selectionY

        -- Initialize Freecam toggle state: prefer menu-local implementation, fall back to global
        if type(MenuFreecam_IsEnabled) == "function" then
            local ok, val = pcall(MenuFreecam_IsEnabled)
            if ok and val then
                for _, f in ipairs(Menu.miscMenu) do
                    if f.key == "freecam" then
                        f.enabled = true
                        break
                    end
                end
            end
        elseif _G and type(_G.Freecam_IsEnabled) == "function" then
            local ok, val = pcall(_G.Freecam_IsEnabled)
            if ok and val then
                for _, f in ipairs(Menu.miscMenu) do
                    if f.key == "freecam" then
                        f.enabled = true
                        break
                    end
                end
            end
        end

        local keyOpenPressed = false

        while true do
            if Menu.unlocked then
                local _, keyPressed = Susano.GetAsyncKeyState(Menu.openKey)
                local _, backspacePressed = Susano.GetAsyncKeyState(0x08)

                if keyPressed and not Menu.open and not keyOpenPressed then
                    Menu.open = true
                    keyOpenPressed = true
                    -- Clear any pending async key transitions so actions aren't triggered immediately
                    clearMenuInputBuffer()
                    Citizen.Wait(200)
                end

                if not keyPressed then
                    keyOpenPressed = false
                end

                -- Close menu with backspace ONLY if in main menu
                if Menu.open and Menu.currentMenu == "main" and backspacePressed then
                    Menu.open = false
                    -- consume any transitions caused while menu was open/closing
                    clearMenuInputBuffer()
                    Citizen.Wait(200)
                end

                -- Close menu with open key (but DON'T reset menu state)
                if Menu.open and (keyPressed and not keyOpenPressed) then
                    Menu.open = false
                    clearMenuInputBuffer()
                    -- Menu.currentMenu stays as it was (test or main)
                    Citizen.Wait(200)
                end

                Menu.alpha = lerp(Menu.alpha, Menu.open and 1 or 0, 0.2)

                handleInput()

                Susano.BeginFrame()

                -- Process enabled toggles across multiple menus (features, combat, settings, triggers)
                local menusToCheck = {Menu.features, Menu.combatMenu, Menu.miscMenu, Menu.settingsMenu, Menu.triggersMenu}
                for _, menuTbl in ipairs(menusToCheck) do
                    if menuTbl then
                        for _, feature in ipairs(menuTbl) do
                            if feature and feature.enabled then
                                if feature.key == "silentkill" then
                                    renderSilentKill()
                                elseif feature.key == "ragebot" then
                                    renderRagebot()
                                elseif feature.key == "idesp" then
                                    renderIDESP()
                                end
                            else
                                -- no stop handlers needed for removed exploits
                            end
                        end
                    end
                end

                renderMenu()

                Susano.SubmitFrame()
            end

            Citizen.Wait(0)
        end
    end
)
