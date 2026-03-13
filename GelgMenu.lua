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
    lastSubmenuIndex = 1, -- Remember which submenu was last selected
    disableAnimations = false, -- Global flag to disable menu animations
    startIndex = 1, -- Start index for viewport scrolling
    cfg = {
        x = 0, -- Will be calculated to center
        y = 0, -- Will be calculated to center
        w = 320,
        headerH = 100,
        itemH = 35,
        rounding = 6,
        maxVisibleItems = 8, -- Maximum items visible at once
        -- White theme
        accent = {1.0, 1.0, 1.0},
        bg = {0.05, 0.08, 0.12, 0.90},
        itemBg = {0.08, 0.12, 0.16, 0.4},
        selectedBorder = {1.0, 1.0, 1.0, 0.9},
        text = {1, 1, 1},
        textDim = {0.7, 0.7, 0.75},
        line = {1.0, 1.0, 1.0, 0.8},
        -- small horizontal tweak for Player ID text centering (negative moves left)
        idTextOffset = -2
    },
    features = {
        {name = "Self", key = "selfmenu", type = "submenu"},
        {name = "Players", key = "playersmenu", type = "submenu"},
        {name = "Combat", key = "combatmenu", type = "submenu"},
        {name = "Vehicle", key = "vehiclemenu", type = "submenu"},
        {name = "Visual", key = "visualmenu", type = "submenu"},
        {name = "Miscellaneous", key = "miscmenu", type = "submenu"},
        {name = "Triggers", key = "triggersmenu", type = "submenu"},
        {name = "Settings", key = "settingsmenu", type = "submenu"}
    },
    combatMenu = {
        {name = "Silent Kill Ragebot", key = "silentkill", enabled = false, type = "toggle"},
        {name = "Car Ragebot", key = "ragebot", enabled = false, type = "toggle"},
        {name = "One Punch", key = "onepunch", enabled = false, type = "toggle"}
    },
    playersMenu = {},
    miscMenu = {
        {name = "Freecam", key = "freecam", enabled = false, type = "toggle"},
        {name = "Physics Gun", key = "physicsgun", enabled = false, type = "toggle"},
        {name = "Scan Anticheats", key = "scananticheats", type = "action"}
    },
    triggersMenu = {
        {name = "Find Triggers", key = "findtriggers", type = "action"},
        {name = "Show All Triggers", key = "showtriggers", type = "action"},
    },
    vehicleMenu = {
        {name = "Spawn Vehicle", key = "spawnvehicle", type = "action"}
    },
    settingsMenu = {
        -- Player ID ESP moved to Miscellaneous menu
        {
            name = "Banner",
            key = "bannerselect",
            type = "action",
            options = {
                {name = "Black", value = "https://i.imgur.com/PEU8ZyO.png"},
                {name = "Blue", value = "https://i.imgur.com/h0P61sx.png"},
                {name = "Red", value = "https://i.imgur.com/X0DXDmE.png"},
                {name = "Green", value = "https://i.imgur.com/RBFXSMD.png"},
                {name = "Purple", value = "https://i.imgur.com/mS78X3y.png"},
                {name = "Orange", value = "https://i.imgur.com/JjwNNbM.png"},
                {name = "Cyan", value = "https://i.imgur.com/dalXLuY.png"},
                {name = "Yellow", value = "https://i.imgur.com/96taWVN.png"},
            },
            selectedOption = 1
        },
        {
            name = "Color",
            key = "accentselect",
            type = "action",
            options = {
                {name = "Blue", color = {0.2, 0.6, 1.0}},
                {name = "Red", color = {1.0, 0.2, 0.2}},
                {name = "Green", color = {0.2, 1.0, 0.2}},
                {name = "Purple", color = {0.6, 0.2, 1.0}},
                {name = "Orange", color = {1.0, 0.55, 0.2}},
                {name = "Cyan", color = {0.0, 0.8, 0.8}},
                {name = "Yellow", color = {1.0, 0.9, 0.2}},
                {name = "Black", color = {0.0, 0.0, 0.0}},
                {name = "White", color = {1.0, 1.0, 1.0}}
            },
            selectedOption = 9
        },
        {
            name = "Toggle Animations",
            key = "toggleanimations",
            enabled = true,
            type = "toggle"
        },
        {
            name = "Test Notification",
            key = "testnotification",
            type = "action"
        }

    },
    visualMenu = {
        {name = "Player ESP", key = "playeresp", enabled = false, type = "toggle"},
        {name = "Include Self", key = "includeself", enabled = false, type = "toggle"},
        {name = "Text", type = "divider"},
        {name = "Show ID", key = "showid", enabled = false, type = "toggle"},
        {name = "Show Group (ESX)", key = "showgroup", enabled = false, type = "toggle"},
        {name = "Show Job (ESX)", key = "showjob", enabled = false, type = "toggle"},
        {name = "Skeleton", type = "divider"},
        {name = "Show Skeleton", key = "showskeleton", enabled = false, type = "toggle"},
        {
            name = "Skeleton Color",
            key = "skeletoncolor",
            type = "action",
            options = {
                {name = "White", color = {1.0, 1.0, 1.0}},
                {name = "Red", color = {1.0, 0.0, 0.0}},
                {name = "Green", color = {0.0, 1.0, 0.0}},
                {name = "Blue", color = {0.0, 0.0, 1.0}},
                {name = "Yellow", color = {1.0, 1.0, 0.0}},
                {name = "Pink", color = {1.0, 0.5, 1.0}},
                {name = "Cyan", color = {0.0, 1.0, 1.0}},
                {name = "Orange", color = {1.0, 0.55, 0.0}},
                {name = "Black", color = {0.0, 0.0, 0.0}}
            },
            selectedOption = 1
        },
        {name = "Highlight Invisible", key = "highlightinvisible", enabled = false, type = "toggle"},
        {
            name = "Invisible Color",
            key = "invisiblecolor",
            type = "action",
            options = {
                {name = "Magenta", color = {1.0, 0.0, 1.0}},
                {name = "Red", color = {1.0, 0.0, 0.0}},
                {name = "Green", color = {0.0, 1.0, 0.0}},
                {name = "Blue", color = {0.0, 0.0, 1.0}},
                {name = "Yellow", color = {1.0, 1.0, 0.0}},
                {name = "Cyan", color = {0.0, 1.0, 1.0}},
                {name = "Orange", color = {1.0, 0.55, 0.0}},
                {name = "White", color = {1.0, 1.0, 1.0}},
                {name = "Black", color = {0.0, 0.0, 0.0}}
            },
            selectedOption = 1
        }
    },
    selfMenu = {
        {name = "Revive", key = "reviveplayer", type = "action"},
        {name = "Teleport", key = "teleportmenu", type = "submenu"}
    },
    teleportMenu = {
        {name = "Teleport to Waypoint", key = "teleportwaypoint", type = "action"},
        {name = "Teleport to Car Dealership", key = "teleportcardealership", type = "action"},
        {name = "Teleport to Maze Bank", key = "teleportmazebank", type = "action"},
        {name = "Teleport to Airport", key = "teleportairport", type = "action"},
        {name = "Teleport to Casino", key = "teleportcasino", type = "action"}
    }

}


local screenW, screenH = 1920, 1080
local customFont = nil
local bannerTexture = nil
local bannerWidth = 0
local bannerHeight = 0
-- Default banner: point to the remote Black image so it's used by default
local currentBannerPath = "https://i.imgur.com/PEU8ZyO.png"
local onePunchEnabled = false
local physicsGunEnabled = false
local includeSelf = false
local showId = false
local showGroup = false
local showJob = false
local showSkeleton = false
local skeletonColor = {1.0, 1.0, 1.0} -- Default white skeleton color
local highlightInvisible = false
local invisibleColor = {1.0, 0.0, 1.0} -- Default magenta for invisible players


local notifications = {} -- List of active notifications

-- PHYSICS GUN CONFIG
local holdDistance = 10.0 -- Wie weit weg das Auto schwebt (in Metern)
local grabRange = 5000.0 -- Maximale Range um Autos zu greifen (in Metern)
local heldVehicle = nil
local isHolding = false

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
    -- Don't release old texture until new one is successfully loaded
    local oldTexture = bannerTexture

    -- If bannerName looks like an HTTP(S) URL, download it first and load from buffer
    if type(bannerName) == "string" and bannerName:match("^https?://") then
        print(string.format("^4[GELG]^7 Loading banner from URL: %s", bannerName))
        local st, body = Susano.HttpGet(bannerName)

        if st and body then
            -- Use pcall to prevent crashes from invalid texture data
            local success, id, w, h = pcall(Susano.LoadTextureFromBuffer, body)
            if success and id then
                -- Only release old texture after new one is loaded
                if oldTexture then
                    Susano.ReleaseTexture(oldTexture)
                end
                bannerTexture = id
                bannerWidth = w
                bannerHeight = h
                currentBannerPath = bannerName
                print(string.format("^4[GELG]^7 Banner loaded from URL! Size: %dx%d", w, h))
                return true
            else
                print(string.format("^4[GELG]^7 Failed to load texture from data: %s (error: %s)", tostring(bannerName), tostring(id or "unknown")))
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
                        applyAccentColor(opt.color)
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
        --if pid ~= PlayerId() then
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
        --end
    end

    table.sort(list, function(a, b)
        return a.distance < b.distance
    end)

    local menu = {}
    for _, p in ipairs(list) do
        local display = string.format("%s (ID:%d) - %.1fm", p.name, p.serverId, p.distance)
        table.insert(menu, {name = display, key = "player_" .. tostring(p.serverId), type = "submenu", playerId = p.playerId, serverId = p.serverId, distance = p.distance})
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
local function applyAccentColor(color)
    if not color then
        return
    end
    Menu.cfg.accent = color
    -- Update derived UI colors that should follow accent
    Menu.cfg.line = {Menu.cfg.accent[1], Menu.cfg.accent[2], Menu.cfg.accent[3], 0.8}
    Menu.cfg.selectedBorder = {Menu.cfg.accent[1], Menu.cfg.accent[2], Menu.cfg.accent[3], 0.9}
end

-- Apply skeleton color
local function applySkeletonColor(color)
    if not color then
        return
    end
    skeletonColor = {color[1], color[2], color[3]} -- Ensure it's a proper table
    print(string.format("^4[GELG]^7 Skeleton color set to: %.2f, %.2f, %.2f", color[1], color[2], color[3]))
end

-- Apply invisible color
local function applyInvisibleColor(color)
    if not color then
        return
    end
    invisibleColor = {color[1], color[2], color[3]} -- Ensure it's a proper table
    print(string.format("^4[GELG]^7 Invisible color set to: %.2f, %.2f, %.2f", color[1], color[2], color[3]))
end

function GelgNotification(text, duration)
    table.insert(notifications, {
        text = text,
        startTime = GetGameTimer(),
        duration = duration
    })
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

-- Scan for known anticheat resources
local anticheatResources = {
    electronacResource = nil,
    fiveguardResource = nil,
    waveshieldResource = nil,
    pegasusacResource = nil,
    anvilacResource = nil,
    reaperv4Resource = nil
}

local anticheatDefinitions = {
    {name = "FiveGuard", key = "fiveguardResource", patterns = {"ac 'fg'", "shared_fg-obfuscated.lua", "sv-resource-obfuscated.lua"}},
    {name = "ElectronAC", key = "electronacResource", patterns = {"https://electron-services.com", "Electron Services", "The most advanced fiveM anticheat"}},
    {name = "WaveShield", key = "waveshieldResource", patterns = {"author 'WaveShield'", "https://waveshield.xyz", "WaveShield, The Best FiveM Anti-Cheat"}},
    {name = "PegasusAC", key = "pegasusacResource", patterns = {"Pegasus Team", "discord.gg/pegasusac", "description 'PegasusAC'"}},
    {name = "ReaperV4", key = "reaperv4Resource", patterns = {"https://reaperac.com", "scripts/detections/pro_detections/*.lua", "your a nerd | "}},
    {name = "AnvilAC", key = "anvilacResource", patterns = {"Jeromebro"}}
}

function ScanAllAnticheats()
    local foundAnticheats = {}

    for _, def in ipairs(anticheatDefinitions) do
        for i = 0, GetNumResources() - 1 do
            local resource = GetResourceByFindIndex(i)
            local manifest = LoadResourceFile(resource, "fxmanifest.lua")
            if manifest then
                for _, pattern in ipairs(def.patterns) do
                    if string.find(manifest, pattern) then
                        anticheatResources[def.key] = resource
                        table.insert(foundAnticheats, {name = def.name, resource = resource})
                        goto nextDef
                    end
                end
            end
        end
        ::nextDef::
    end

    return foundAnticheats
end

--End of Anticheat Scan

function RequestControl(entity, timeoutMs)
    timeoutMs = timeoutMs or 2000
    local start = GetGameTimer()
    while (GetGameTimer() - start) < timeoutMs do
        if NetworkHasControlOfEntity(entity) then return true end
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end
    return NetworkHasControlOfEntity(entity)
end

function SafeTeleportPlayer(x, y, z)
    local ped = PlayerPedId()
    local currentCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    CreateThread(function()
        SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
        GetGroundZFor_3dCoord(x, y, z + 50000.0, function(groundZ)
            SetEntityCoordsNoOffset(ped, x, y, groundZ + 4.0, false, false, false)
        end)
    end)
end

function RevivePlayer()
    if GetResourceState('esx_ambulancejob') == 'started' then
        TriggerEvent("esx_ambulancejob:revive")
    elseif GetResourceState('qb-core') == 'started' then
        TriggerEvent("hospital:client:Revive")
    elseif GetResourceState('wasabi_ambulance') == 'started' then
        TriggerEvent("wasabi_ambulance:revive")
    elseif GetResourceState('visn_are') == 'started' then
        TriggerEvent("visn_are:resetHealthBuffer")
    else
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, false, false)
        ResurrectPed(ped)
        ClearPedBloodDamage(ped)
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
    end
end

function GelgGlitchPlayer(targetServerId)
    local function HookNative(nativeName, newFunction)
        local originalNative = _G[nativeName]
        if not originalNative or type(originalNative) ~= "function" then
            return
        end
        _G[nativeName] = function(...)
            return newFunction(originalNative, ...)
        end
    end
    HookNative("IsEntityVisible", function(originalFn, ...) return true end)
    HookNative("IsEntityVisibleToScript", function(originalFn, ...) return true end)
    if not targetServerId then
        print("^1[GELG]^7 No target server ID provided!")
        return
    end
    targetServerId = tonumber(targetServerId)
    if not targetServerId then
        print("^1[GELG]^7 Invalid server ID!")
        return
    end
    CreateThread(function()
        local clientId = GetPlayerFromServerId(targetServerId)
        if not clientId or clientId == -1 then
            print("^1[GELG]^7 Player not found!")
            return
        end
        local targetPed = GetPlayerPed(clientId)
        if not targetPed or not DoesEntityExist(targetPed) then
            print("^1[GELG]^7 Target ped does not exist!")
            return
        end
        local myPed = PlayerPedId()
        if not myPed then
            print("^1[GELG]^7 Could not get player ped!")
            return
        end
        local myCoords = GetEntityCoords(myPed)
        local targetCoords = GetEntityCoords(targetPed)
        if not myCoords or not targetCoords then
            print("^1[GELG]^7 Could not get coordinates!")
            return
        end
        local distance = #(myCoords - targetCoords)
        local teleported = false
        local originalCoords = nil
        if distance > 10.0 then
            originalCoords = myCoords
            local angle = math.random() * 2 * math.pi
            local radiusOffset = math.random(5, 9)
            local xOffset = math.cos(angle) * radiusOffset
            local yOffset = math.sin(angle) * radiusOffset
            local newCoords = vector3(targetCoords.x + xOffset, targetCoords.y + yOffset, targetCoords.z)
            SetEntityCoordsNoOffset(myPed, newCoords.x, newCoords.y, newCoords.z, false, false, false)
            SetEntityVisible(myPed, false, 0)
            teleported = true
            Wait(100)
        end
        ClearPedTasksImmediately(myPed)
        for i = 1, 15 do
            if not DoesEntityExist(targetPed) then
                break
            end
            local curTargetCoords = GetEntityCoords(targetPed)
            if not curTargetCoords then
                break
            end
            SetEntityCoordsNoOffset(myPed, curTargetCoords.x, curTargetCoords.y, curTargetCoords.z + 0.5, false, false, false)
            Wait(50)
            AttachEntityToEntityPhysically(myPed, targetPed, 0, 0.0, 0.0, 0.0, 150.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, false, false, 1, 2)
            Wait(50)
            DetachEntity(myPed, true, true)
            Wait(100)
        end
        Wait(500)
        ClearPedTasksImmediately(myPed)
        if originalCoords then
            SetEntityCoordsNoOffset(myPed, originalCoords.x, originalCoords.y, originalCoords.z, false, false, false)
        end
        if teleported then
            SetEntityVisible(myPed, true, 0)
        end
    end)
end



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

local function drawTextWithOutline(x, y, txt, size, r, g, b, a, outline_pixels)
    if customFont then
        Susano.PushFont(customFont)
    end

    -- Draw outline in black
    local outline_r, outline_g, outline_b = 0.1, 0.1, 0.1
    for dx = -outline_pixels, outline_pixels do
        for dy = -outline_pixels, outline_pixels do
            if dx ~= 0 or dy ~= 0 then
                Susano.DrawText(x + dx, y + dy, txt, size, outline_r, outline_g, outline_b, a or 1)
            end
        end
    end

    -- Draw main text on top
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

local function clearFreecamInputBuffer()
    local keys = {0x01, 0x10, 0x11, 0x20, 0x41, 0x44, 0x53, 0x57} -- ENTER, BACKSPACE, LEFT, UP, RIGHT, DOWN, E
    -- call GetAsyncKeyState a few times across frames to reset transition flags
    for i = 1, 3 do
        for _, vk in ipairs(keys) do
            pcall(function() Susano.GetAsyncKeyState(vk) end)
        end
        Citizen.Wait(0)
    end
end

-- ============================================
-- FREECAM (MIT SUSANO COMMUNICATION)
-- ============================================
load([====[
Susano.Freecam = {}
Susano.Freecam.handlers = {}
Susano.Freecam.data = {
    position = {x = 0, y = 0, z = 0},
    rotation = {x = 0, y = 0, z = 0},
    active = false
}
Susano.Freecam.injected = false

local function GenerateRandomKey(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = {}
    for i = 1, length do
        local rand = math.random(1, #chars)
        result[i] = chars:sub(rand, rand)
    end
    return table.concat(result)
end

Susano.Freecam.Key = GenerateRandomKey(16)

-- Hook GetConvar für Kommunikation
-- Hook GetConvar für Kommunikation
-- Zentraler GetConvar Dispatcher
Susano.ConvarBridge = {}
Susano.ConvarBridge.handlers = {}

Susano.UnhookNative(0x6CCD2564)
Susano.HookNative(0x6CCD2564, function(key, data)
    local handler = Susano.ConvarBridge.handlers[key]
    if handler then
        handler(data)
    end
    return true
end)

function Susano.ConvarBridge.Register(key, fn)
    Susano.ConvarBridge.handlers[key] = fn
end

-- Freecam Handler registrieren
Susano.ConvarBridge.Register(Susano.Freecam.Key, function(data)
    local decoded = json.decode(data)
    local eventName = decoded.event
    
    if eventName == "freecamUpdate" then
        Susano.Freecam.data.position = decoded.position
        Susano.Freecam.data.rotation = decoded.rotation
        Susano.Freecam.data.active = decoded.active
    end
    
    if Susano.Freecam.handlers[eventName] then
        for _, handler in pairs(Susano.Freecam.handlers[eventName]) do
            handler(table.unpack(decoded.args or {}))
        end
    end
end)

-- Event Handler registrieren
function Susano.Freecam.On(eventName, callback)
    if not Susano.Freecam.handlers[eventName] then 
        Susano.Freecam.handlers[eventName] = {} 
    end
    table.insert(Susano.Freecam.handlers[eventName], callback)
end

-- Freecam Code in Resource injecten
function Susano.Freecam.Inject(resourceName)
    local freecamCode = ([[
        local FreecamSystem = {}
        FreecamSystem.active = false
        FreecamSystem.camera = nil
        FreecamSystem.speed = 1.5
        FreecamSystem.fov = 90.0
        
        local position = vector3(0, 0, 0)
        local rotation = vector3(0, 0, 0)
        
        function FreecamSystem.Send(event, ...)
            local payload = {
                event = event,
                args = {...}
            }
            GetConvar('%s', json.encode(payload))
        end
        
        function FreecamSystem.SendUpdate()
            local payload = {
                event = "freecamUpdate",
                position = {x = position.x, y = position.y, z = position.z},
                rotation = {x = rotation.x, y = rotation.y, z = rotation.z},
                active = FreecamSystem.active
            }
            GetConvar('%s', json.encode(payload))
        end
        
        function FreecamSystem.Toggle()
            FreecamSystem.active = not FreecamSystem.active
            
            if FreecamSystem.active then
                position = GetGameplayCamCoord()
                rotation = GetGameplayCamRot(2)
                FreecamSystem.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                SetCamCoord(FreecamSystem.camera, position.x, position.y, position.z)
                SetCamRot(FreecamSystem.camera, rotation.x, rotation.y, rotation.z, 2)
                SetCamFov(FreecamSystem.camera, FreecamSystem.fov)
                SetCamActive(FreecamSystem.camera, true)
                RenderScriptCams(true, true, 500, true, false)

                FreecamSystem.Send("freecamEnabled")
            else
                if FreecamSystem.camera then
                    RenderScriptCams(false, true, 500, true, false)
                    SetCamActive(FreecamSystem.camera, false)
                    DestroyCam(FreecamSystem.camera, false)
                    FreecamSystem.camera = nil
                end
                
                ClearFocus()
                FreecamSystem.Send("freecamDisabled")
            end
            
            FreecamSystem.SendUpdate()
        end
        
        -- Input Handling Thread
        Citizen.CreateThread(function()
            while true do
                Wait(0)
                
                if FreecamSystem.active and FreecamSystem.camera then
                    -- Disable ALL player controls
                    DisableControlAction(0, 14, true)
                    DisableControlAction(0, 15, true)
                    DisableControlAction(0, 16, true)
                    DisableControlAction(0, 17, true)
                    DisableControlAction(0, 21, true)
                    DisableControlAction(0, 22, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 30, true)
                    DisableControlAction(0, 31, true)
                    DisableControlAction(0, 32, true)
                    DisableControlAction(0, 33, true)
                    DisableControlAction(0, 34, true)
                    DisableControlAction(0, 35, true)
                    DisableControlAction(0, 36, true)
                    DisableControlAction(0, 44, true)
                    DisableControlAction(0, 59, true)
                    DisableControlAction(0, 71, true)
                    DisableControlAction(0, 72, true)
                    DisableControlAction(0, 76, true)
                    DisableControlAction(0, 174, true)
                    DisableControlAction(0, 175, true)
                    DisableControlAction(0, 91, true)
                    DisableControlAction(0, 92, true)
                    DisableControlAction(0, 106, true)
                    DisableControlAction(0, 114, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 257, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 264, true)
                    
                    -- Movement Speed
                    local speed = FreecamSystem.speed
                    if IsDisabledControlPressed(0, 21) then
                        speed = speed * 3.0
                    end
                    if IsDisabledControlPressed(0, 19) then
                        speed = speed * 0.3
                    end
                    
                    -- 3D Movement
                    local radX = math.rad(rotation.x)
                    local radZ = math.rad(rotation.z)
                    
                    local forward = vector3(
                        -math.sin(radZ) * math.cos(radX),
                        math.cos(radZ) * math.cos(radX),
                        math.sin(radX)
                    )
                    
                    local right = vector3(
                        math.cos(radZ),
                        math.sin(radZ),
                        0
                    )
                    
                    if IsDisabledControlPressed(0, 32) then
                        position = position + forward * speed
                    end
                    if IsDisabledControlPressed(0, 33) then
                        position = position - forward * speed
                    end
                    if IsDisabledControlPressed(0, 34) then
                        position = position - right * speed
                    end
                    if IsDisabledControlPressed(0, 35) then
                        position = position + right * speed
                    end
                    
                    if IsDisabledControlPressed(0, 22) then
                        position = vector3(position.x, position.y, position.z + speed)
                    end
                    if IsDisabledControlPressed(0, 36) then
                        position = vector3(position.x, position.y, position.z - speed)
                    end
                    
                    -- Mouse Rotation
                    local mouseX = GetDisabledControlNormal(0, 1) * 8.0
                    local mouseY = GetDisabledControlNormal(0, 2) * 8.0
                    
                    rotation = vector3(
                        math.max(-89.0, math.min(89.0, rotation.x - mouseY)),
                        rotation.y,
                        rotation.z - mouseX
                    )
                    
                    -- Update Camera
                    SetCamCoord(FreecamSystem.camera, position.x, position.y, position.z)
                    SetCamRot(FreecamSystem.camera, rotation.x, rotation.y, rotation.z, 2)
                    SetFocusPosAndVel(position.x, position.y, position.z, 0.0, 0.0, 0.0)
                end
            end
        end)
        
        -- Update Thread
        Citizen.CreateThread(function()
            while true do
                Wait(0)
                if FreecamSystem.active then
                    FreecamSystem.SendUpdate()
                end
            end
        end)
        
        _G.FreecamSystem = FreecamSystem
    ]]):format(Susano.Freecam.Key, Susano.Freecam.Key)
    
    Susano.InjectResource(resourceName, freecamCode, Susano.InjectionType.WHOOK_NOTHREAD)
    Susano.Freecam.injected = true
end

-- Getter Functions
function Susano.Freecam.GetPosition()
    return Susano.Freecam.data.position
end

function Susano.Freecam.GetRotation()
    return Susano.Freecam.data.rotation
end

function Susano.Freecam.IsActive()
    return Susano.Freecam.data.active
end

-- Event Listeners
Susano.Freecam.On("freecamEnabled", function()
    GelgNotification("Freecam enabled", 5000)
end)

Susano.Freecam.On("freecamDisabled", function()
    GelgNotification("Freecam disabled", 5000)
end)

]====])()

-- Auto-Inject beim Start
Citizen.CreateThread(function()
    Wait(500)
    Susano.Freecam.Inject("monitor")
end)

-- Freecam Native Hooks
local function enableFreecamHooks()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    -- GetCamCoord (0xBAC038F7459AE5AE) -> x, y, z
    Susano.HookNative(0xBAC038F7459AE5AE, function(cam)
        if Susano.Freecam.IsActive() then
            local p = GetEntityCoords(PlayerPedId())
            return false, p.x, p.y, p.z
        end
    end)

    -- GetFinalRenderedCamCoord (0xA200EB1EE790F448) -> x, y, z
    Susano.HookNative(0xA200EB1EE790F448, function()
        if Susano.Freecam.IsActive() then
            local p = GetEntityCoords(PlayerPedId())
            return false, p.x, p.y, p.z
        end
    end)

    -- GetGameplayCamCoord (0x14D6F5678D8F1B37) -> x, y, z
    Susano.HookNative(0x14D6F5678D8F1B37, function()
        if Susano.Freecam.IsActive() then
            local p = GetEntityCoords(PlayerPedId())
            return false, p.x, p.y, p.z
        end
    end)

    -- IsControlEnabled (0x1CEA6BFDF248E5D9) -> bool
    Susano.HookNative(0x1CEA6BFDF248E5D9, function()
        if Susano.Freecam.IsActive() then
            return false, true
        end
    end)

    -- GetDistanceBetweenCoords (0xF1B760881820C952) -> float
    --Susano.HookNative(0xF1B760881820C952, function()
    --    return false, 0.0
    --end)
end

enableFreecamHooks()

-- Globale Toggle-Funktion für das Menü
function MenuFreecam_SetEnabled(enabled)
    if not Susano.Freecam.injected then
        Susano.Freecam.Inject("monitor")
        Wait(500)
    end

    if enabled then
        Citizen.CreateThread(function()
            clearFreecamInputBuffer()
        end)
    end

    Susano.InjectResource("monitor", string.format([[
        if FreecamSystem then
            if %s ~= FreecamSystem.active then
                FreecamSystem.Toggle()
            end
        end
    ]], enabled and "true" or "false"), Susano.InjectionType.WHOOK_NOTHREAD)
end

function MenuFreecam_IsEnabled()
    return Susano.Freecam.IsActive()
end

-- ============================================
-- FREECAM OPTIONS
-- ============================================
local freecamOptions = {
    modes = {"Look Around", "Shoot Vehicle", "Spawn Vehicle", "Falling Vehicle", "Spawn Object", "Map Destroyer", "Physics Gun", "Teleport", "Delete Entity"},
    currentModeIndex = 1,
    CAR_VELOCITY = 120.0,

    -- Shoot Vehicle / Spawn Vehicle / Falling Vehicle Fahrzeuge
    vehicles = {
        {name = "Asea",     hash = "asea"},
        {name = "Adder",    hash = "adder"},
        {name = "Lazer",    hash = "lazer"},
        {name = "BMX",hash = "bmx"},
        {name = "Boat",   hash = "speeder"},
        {name = "Helicopter",    hash = "polmav"},
        {name = "Kosatka",    hash = "kosatka"},
    },
    currentVehicleIndex = 1,

    -- Spawn Object Objekte
    spawnObjects = {
        {name = "Stop Sign",   hash = "stt_prop_track_stop_sign"},
        {name = "Barrel",      hash = "prop_barrel_02a"},
        {name = "Bowling Pin",        hash = "stt_prop_stunt_bowling_pin"},
        {name = "Ball",        hash = "stt_prop_stunt_soccer_lball"},
        {name = "Container",   hash = "prop_container_01a"},
        {name = "Tube Speed",   hash = "stt_prop_stunt_tube_speedb"},
        {name = "Speed",   hash = "stt_prop_track_speedup_t1"},
    },
    currentSpawnObjectIndex = 1,

    -- Map Destroyer Objekte
    destroyerObjects = {
        {name = "Big Square",  hash = "ar_prop_ar_neon_gate8x_03a"},
        {name = "Big Tube",     hash = "ar_prop_ar_tube_4x_l"},
        {name = "FIB Building",     hash = -1404869155},
        {name = "Windmill",     hash = "prop_windmill_01"},
        {name = "Yellow Rings",   hash = "ar_prop_ar_checkpoint_m"},
        {name = "Scifi Arena",   hash = "xs_propint2_set_scifi_09"},
        {name = "Big Wall",   hash = "stt_prop_stunt_track_st_01"},
        {name = "test",   hash = -187289322},
    },
    currentDestroyerIndex = 1,
}

local function freecamChangeMode(direction)
    freecamOptions.currentModeIndex = freecamOptions.currentModeIndex + direction
    if freecamOptions.currentModeIndex > #freecamOptions.modes then
        freecamOptions.currentModeIndex = 1
    elseif freecamOptions.currentModeIndex < 1 then
        freecamOptions.currentModeIndex = #freecamOptions.modes
    end
end

function Susano.Freecam.GetLookAtPos(distance)
    distance = distance or 50000.0
    local pos = Susano.Freecam.GetPosition()
    local rot = Susano.Freecam.GetRotation()

    local radX = math.rad(rot.x)
    local radZ = math.rad(rot.z)
    local fwdX = -math.sin(radZ) * math.cos(radX)
    local fwdY =  math.cos(radZ) * math.cos(radX)
    local fwdZ =  math.sin(radX)

    local endX = pos.x + fwdX * distance
    local endY = pos.y + fwdY * distance
    local endZ = pos.z + fwdZ * distance

    local rayHandle = StartShapeTestRay(
        pos.x, pos.y, pos.z,
        endX,  endY,  endZ,
        -1,    -- alle Entity-Typen (Map + Vehicles + Peds + Objects)
        -1,    -- kein Entity ignorieren
        0
    )

    local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 then
        return {
            hit      = true,
            x        = hitCoords.x,
            y        = hitCoords.y,
            z        = hitCoords.z,
            normal   = surfaceNormal,
            entity   = entityHit
        }
    else
        -- Kein Treffer: Endpunkt des Strahls zurückgeben
        return {
            hit    = false,
            x      = endX,
            y      = endY,
            z      = endZ,
            normal = nil,
            entity = 0
        }
    end
end

-- Input Thread für Freecam Options
local freecamArrowDelay = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not Susano.Freecam.IsActive() then goto continue end

        local mode = freecamOptions.currentModeIndex

        -- Mausrad für Moduswechsel
        local scrollUp   = IsDisabledControlJustPressed(0, 15)
        local scrollDown = IsDisabledControlJustPressed(0, 14)
        if scrollUp   then freecamChangeMode(-1) end
        if scrollDown then freecamChangeMode(1)  end

        -- Pfeiltasten für Fahrzeug/Objekt Auswahl (mit Cooldown, kein GetAsyncKeyState)
        local now = GetGameTimer()
        if now >= freecamArrowDelay then
            local _, leftHeld = Susano.GetAsyncKeyState(0x25) -- Left Arrow
            local _, rightHeld = Susano.GetAsyncKeyState(0x27)

            if leftHeld or rightHeld then
                freecamArrowDelay = now + 200
                local dir = rightHeld and 1 or -1

                if mode == 2 or mode == 3 or mode == 4 then --Vehicles
                    freecamOptions.currentVehicleIndex = freecamOptions.currentVehicleIndex + dir
                    if freecamOptions.currentVehicleIndex < 1 then
                        freecamOptions.currentVehicleIndex = #freecamOptions.vehicles
                    elseif freecamOptions.currentVehicleIndex > #freecamOptions.vehicles then
                        freecamOptions.currentVehicleIndex = 1
                    end
                elseif mode == 5 then -- Spawn Objects
                    freecamOptions.currentSpawnObjectIndex = freecamOptions.currentSpawnObjectIndex + dir
                    if freecamOptions.currentSpawnObjectIndex < 1 then
                        freecamOptions.currentSpawnObjectIndex = #freecamOptions.spawnObjects
                    elseif freecamOptions.currentSpawnObjectIndex > #freecamOptions.spawnObjects then
                        freecamOptions.currentSpawnObjectIndex = 1
                    end
                elseif mode == 6 then -- Map Destroyer
                    freecamOptions.currentDestroyerIndex = freecamOptions.currentDestroyerIndex + dir
                    if freecamOptions.currentDestroyerIndex < 1 then
                        freecamOptions.currentDestroyerIndex = #freecamOptions.destroyerObjects
                    elseif freecamOptions.currentDestroyerIndex > #freecamOptions.destroyerObjects then
                        freecamOptions.currentDestroyerIndex = 1
                    end
                end
            end
        end

        -- Linksklick für Aktion
        local _, lPressed = Susano.GetAsyncKeyState(0x01)
        if lPressed then
            local pos = Susano.Freecam.GetPosition()
            local rot = Susano.Freecam.GetRotation()

            local radX = math.rad(rot.x)
            local radZ = math.rad(rot.z)
            local fwdX = -math.sin(radZ) * math.cos(radX)
            local fwdY =  math.cos(radZ) * math.cos(radX)
            local fwdZ =  math.sin(radX)

            local selectedVehicle  = freecamOptions.vehicles[freecamOptions.currentVehicleIndex]
            local selectedSpawnObj = freecamOptions.spawnObjects[freecamOptions.currentSpawnObjectIndex]
            local selectedDestroy  = freecamOptions.destroyerObjects[freecamOptions.currentDestroyerIndex]

            if mode == 2 then -- Shoot Vehicle
                local playercoords = GetEntityCoords(PlayerPedId())
                local spX = pos.x + fwdX * 3.0
                local spY = pos.y + fwdY * 3.0
                local spZ = pos.z + fwdZ * 3.0
                local heading = math.deg(math.atan2(-fwdX, fwdY))
                local rotation = Susano.Freecam.GetRotation()
                GelgSpawnVehicle(selectedVehicle.hash, playercoords.x, playercoords.y, playercoords.z - 10, heading, true, function(vehicle)
                    if vehicle ~= 0 then
                        if RequestControl(vehicle, 1000) then
                            SetEntityRotation(vehicle, rotation.x, rotation.y, rotation.z, 2, true)
                            SetEntityCoordsNoOffset(vehicle, spX, spY, spZ, false, false, false)
                            SetEntityVelocity(vehicle, fwdX * freecamOptions.CAR_VELOCITY, fwdY * freecamOptions.CAR_VELOCITY, fwdZ * freecamOptions.CAR_VELOCITY)
                        end
                    end
                end)
            elseif mode == 3 then -- Spawn Vehicle
                local playercoords = GetEntityCoords(PlayerPedId())
                local lookAt = Susano.Freecam.GetLookAtPos()
                local heading = math.deg(math.atan2(-fwdX, fwdY))
                GelgSpawnVehicle(selectedVehicle.hash, playercoords.x, playercoords.y, playercoords.z - 10, heading, true, function(vehicle)
                    if vehicle ~= 0 then
                        if RequestControl(vehicle, 1000) then
                            SetEntityCoords(vehicle, lookAt.x, lookAt.y, lookAt.z, false, false, false)
                        end
                    end
                end)
            
            elseif mode == 4 then -- Falling Vehicle
                local playercoords = GetEntityCoords(PlayerPedId())
                local lookAt = Susano.Freecam.GetLookAtPos()
                local heading = math.deg(math.atan2(-fwdX, fwdY))
                GelgSpawnVehicle(selectedVehicle.hash, playercoords.x, playercoords.y, playercoords.z - 10, heading, true, function(vehicle)
                    if vehicle ~= 0 then
                        if RequestControl(vehicle, 1000) then
                            SetEntityCoordsNoOffset(vehicle, lookAt.x, lookAt.y, lookAt.z + 20.0, false, false, false)
                            SetEntityVelocity(vehicle, 0.0, 0.0, -50.0)
                        end
                    end
                end)
            elseif mode == 5 then -- Spawn Object
                local lookAt = Susano.Freecam.GetLookAtPos()
                local heading = math.deg(math.atan2(-fwdX, fwdY))
                heading = (heading + 90) % 360
                GelgSpawnObject(selectedSpawnObj.hash, lookAt.x, lookAt.y, lookAt.z, true, function(object)
                    if object ~= 0 then
                        SetEntityHeading(object, heading)
                        if selectedSpawnObj.hash ~= "stt_prop_track_stop_sign" then
                            SetEntityDynamic(object, true)
                        end
                    end
                end)
            elseif mode == 6 then -- Map Destroyer
                local lookAt = Susano.Freecam.GetLookAtPos()
                local heading = math.deg(math.atan2(-fwdX, fwdY))
                GelgSpawnObject(selectedDestroy.hash, lookAt.x, lookAt.y, lookAt.z, true, function(object)
                    if object ~= 0 then
                        SetEntityDynamic(object, true)
                        SetEntityHeading(object, heading)
                    end
                end)
            elseif mode == 7 then -- Physics Gun - LMB = Grab/Drop
                if not isHolding then
                    -- Raycast von Freecam-Position (wie GetVehicleLookingAt aber für Freecam)
                    local fcPos = Susano.Freecam.GetPosition()
                    local endX = fcPos.x + fwdX * grabRange
                    local endY = fcPos.y + fwdY * grabRange
                    local endZ = fcPos.z + fwdZ * grabRange

                    local rayHandle = StartShapeTestRay(
                        fcPos.x, fcPos.y, fcPos.z,
                        endX, endY, endZ,
                        10, -1, 0
                    )
                    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)

                    if hit == 1 and entityHit ~= 0 and IsEntityAVehicle(entityHit) then
                        -- Exakt gleicher Grab-Trick wie GrabVehicle()
                        local ped = PlayerPedId()
                        local originalCoords = GetEntityCoords(ped)
                        local originalHeading = GetEntityHeading(ped)

                        ClearPedTasksImmediately(ped)
                        TaskWarpPedIntoVehicle(ped, entityHit, -1)
                        Wait(100)

                        if IsPedInVehicle(ped, entityHit, false) then
                            ClearPedTasksImmediately(ped)
                            TaskLeaveVehicle(ped, entityHit, 0)
                            Wait(50)
                        end

                        SetEntityCoordsNoOffset(ped, originalCoords.x, originalCoords.y, originalCoords.z, true, true, true)
                        SetEntityHeading(ped, originalHeading)
                        Wait(50)

                        if RequestControl(entityHit, 1000) then
                            SetEntityCollision(entityHit, false, false)
                            SetEntityVelocity(entityHit, 0.0, 0.0, 0.0)
                            heldVehicle = entityHit
                            isHolding = true
                        end
                    end
                else
                    -- Inline drop statt DropVehicle()
                    if heldVehicle and DoesEntityExist(heldVehicle) then
                        SetEntityCollision(heldVehicle, true, true)
                        SetEntityVelocity(heldVehicle, 0.0, 0.0, -2.0)
                    end
                    heldVehicle = nil
                    isHolding = false
                end
            elseif mode == 8 then -- Teleport
                local lookAt = Susano.Freecam.GetLookAtPos()
                SetPedCoordsKeepVehicle(PlayerPedId(), lookAt.x, lookAt.y, lookAt.z)
            elseif mode == 9 then -- Entity Deleter - LMB = Delete Entity
                local fcPos = Susano.Freecam.GetPosition()
                local endX = fcPos.x + fwdX * grabRange
                local endY = fcPos.y + fwdY * grabRange
                local endZ = fcPos.z + fwdZ * grabRange

                local rayHandle = StartShapeTestRay(
                    fcPos.x, fcPos.y, fcPos.z,
                    endX, endY, endZ,
                    -1, -1, 0
                )
                local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)

                if hit == 1 and entityHit ~= 0 then
                    if IsEntityAVehicle(entityHit) then
                        local ped = PlayerPedId()
                        local originalCoords = GetEntityCoords(ped)
                        local originalHeading = GetEntityHeading(ped)
                        ClearPedTasksImmediately(ped)
                        TaskWarpPedIntoVehicle(ped, entityHit, -1)
                        Wait(100)

                        if IsPedInVehicle(ped, entityHit, false) then
                            ClearPedTasksImmediately(ped)
                            TaskLeaveVehicle(ped, entityHit, 0)
                            Wait(50)
                        end
                        SetEntityCoordsNoOffset(ped, originalCoords.x, originalCoords.y, originalCoords.z, true, true, true)
                        SetEntityHeading(ped, originalHeading)
                        if RequestControl(entityHit, 1000) then
                            DeleteVehicle(entityHit)
                            GelgNotification("Vehicle deleted!", 2000)
                        else
                            GelgNotification("Failed to get control of vehicle!", 2000)
                        end
                        
                    elseif IsEntityAPed(entityHit) then
                        if RequestControl(entityHit, 1000) then
                            DeletePed(entityHit)
                            GelgNotification("Ped deleted!", 2000)
                        else
                            GelgNotification("Failed to get control of ped!", 2000)
                        end
                    elseif IsEntityAnObject(entityHit) then
                        if RequestControl(entityHit, 1000) then
                            DeleteObject(entityHit)
                            GelgNotification("Object deleted!", 2000)
                        else
                            GelgNotification("Failed to get control of object!", 2000)
                        end
                    end
                end
            end
        end
        -- Physics Gun Modus: Rechtsklick = Launch, Vehicle folgt Freecam-Kamera
        -- Physics Gun Modus: Vehicle folgt Freecam-Kamera (wie bestehender Main Loop aber mit Freecam-Pos)
        if mode == 7 and isHolding and heldVehicle and DoesEntityExist(heldVehicle) then
            local fcPos = Susano.Freecam.GetPosition()
            local rot = Susano.Freecam.GetRotation()
            local radX = math.rad(rot.x)
            local radZ = math.rad(rot.z)
            local fwdX2 = -math.sin(radZ) * math.cos(radX)
            local fwdY2 =  math.cos(radZ) * math.cos(radX)
            local fwdZ2 =  math.sin(radX)

            SetEntityCoordsNoOffset(heldVehicle,
                fcPos.x + fwdX2 * holdDistance,
                fcPos.y + fwdY2 * holdDistance,
                fcPos.z + fwdZ2 * holdDistance,
                true, true, true)
            SetEntityRotation(heldVehicle, rot.x, rot.y, rot.z, 2, true)
            SetEntityVelocity(heldVehicle, 0.0, 0.0, 0.0)

            -- Rechtsklick = Launch (wie LaunchVehicle())
            local _, rPressed = Susano.GetAsyncKeyState(0x02)
            if rPressed then
                if RequestControl(heldVehicle, 500) then
                    SetEntityCollision(heldVehicle, true, true)
                    SetEntityVelocity(heldVehicle, fwdX2 * 150.0, fwdY2 * 150.0, fwdZ2 * 150.0)
                end
                heldVehicle = nil
                isHolding = false
            end
        end
        -- Modus verlassen = droppen
        if mode ~= 7 and isHolding and heldVehicle and DoesEntityExist(heldVehicle) then
            SetEntityCollision(heldVehicle, true, true)
            SetEntityVelocity(heldVehicle, 0.0, 0.0, -2.0)
            heldVehicle = nil
            isHolding = false
        end
        ::continue::
    end
end)

-- UI Thread für Freecam Options
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        Susano.BeginFrame()

        if Susano.Freecam.IsActive() then
            local sw, sh = GetActiveScreenResolution()
            if not sw or sw == 0 then sw, sh = screenW, screenH end

            local fontSize = 20
            local spacing  = 28
            local centerY  = sh - 100
            local cx       = sw / 2

            -- Crosshair
            Susano.DrawCircle(cx, sh / 2, 2, true, 1, 1, 1, 1, 1, 32)
            

            -- Alpha pro Abstand: 0=100%, 1=67%, 2=33%, 3+=nicht anzeigen
            local alphaByDist = {[0] = 1.0, [1] = 0.67, [2] = 0.33}
            local mode = freecamOptions.currentModeIndex
            for i = 1, #freecamOptions.modes do
                local dist = math.abs(i - freecamOptions.currentModeIndex)

                -- Mehr als 2 Schritte weg = nicht anzeigen
                if dist > 2 then goto nextMode end

                local alpha = alphaByDist[dist]
                local name  = freecamOptions.modes[i]
                local size  = fontSize
                local r, g, b

                local relOffset = i - freecamOptions.currentModeIndex
                local ty = centerY + relOffset * spacing

                if dist == 0 then
                    r, g, b = 1.0, 1.0, 1.0
                    size = fontSize + 2

                    -- Sub-Label (Fahrzeug/Objekt Name) nur bei aktiver Option
                    local subLabel = nil
                    if mode == 2 or mode == 3 or mode == 4 then --Vehicles
                        subLabel = freecamOptions.vehicles[freecamOptions.currentVehicleIndex].name
                    elseif mode == 5 then -- Spawn Objects
                        subLabel = freecamOptions.spawnObjects[freecamOptions.currentSpawnObjectIndex].name
                    elseif mode == 6 then -- Map Destroyer
                        subLabel = freecamOptions.destroyerObjects[freecamOptions.currentDestroyerIndex].name
                    end

                    local displayName = subLabel and (name .. " | " .. subLabel) or name
                    local fullText = ">> " .. displayName .. " <<"

                    if customFont then Susano.PushFont(customFont) end
                    local tw = Susano.GetTextWidth(fullText, size) or 80
                    if customFont then Susano.PopFont() end

                    drawTextWithOutline(cx - tw / 2, ty, fullText, size, r, g, b, alpha, 1)
                else
                    r, g, b = 0.7, 0.7, 0.75

                    if customFont then Susano.PushFont(customFont) end
                    local tw = Susano.GetTextWidth(name, size) or 80
                    if customFont then Susano.PopFont() end

                    drawText(cx - tw / 2, ty, name, size, r, g, b, alpha)
                end

                ::nextMode::
            end

            -- Pos/Rot Anzeige
            local pos = Susano.Freecam.GetPosition()
            local rot = Susano.Freecam.GetRotation()
            drawText(10, 10, string.format("Pos: %.1f / %.1f / %.1f", pos.x, pos.y, pos.z), 14, 0.7, 0.7, 0.75, 1)
            drawText(10, 28, string.format("Rot: %.1f / %.1f / %.1f", rot.x, rot.y, rot.z), 14, 0.7, 0.7, 0.75, 1)
        end

        Susano.SubmitFrame()
    end
end)


-- ============================================
-- SPAWN VEHICLE COMMUNICATION SYSTEM
-- ============================================
Susano.SpawnBridge = {}
Susano.SpawnBridge.callbacks = {}
Susano.SpawnBridge.Key = (function()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = {}
    for i = 1, 16 do
        local r = math.random(1, #chars)
        result[i] = chars:sub(r, r)
    end
    return table.concat(result)
end)()

-- SpawnBridge Handler über den zentralen Dispatcher registrieren
-- WICHTIG: muss nach dem load([====[ ]====])() Block stehen da ConvarBridge dort definiert wird
Citizen.CreateThread(function()
    -- kurz warten bis load() Block ausgeführt wurde
    Citizen.Wait(0)
    Susano.ConvarBridge.Register(Susano.SpawnBridge.Key, function(data)
        local ok, decoded = pcall(json.decode, data)
        if not ok or type(decoded) ~= "table" then return end

        if decoded.event == "vehicleSpawned" then
            local cb = Susano.SpawnBridge.callbacks[decoded.requestId]
            if cb then
                Susano.SpawnBridge.callbacks[decoded.requestId] = nil
                cb(decoded.vehicle or 0)
            end
        elseif decoded.event == "objectSpawned" then
            local cb = Susano.SpawnBridge.callbacks[decoded.requestId]
            if cb then
                Susano.SpawnBridge.callbacks[decoded.requestId] = nil
                cb(decoded.object or 0)
            end
        end
    end)
end)

function GelgSpawnVehicle(modelHash, x, y, z, heading, isNetwork, callback)
    local model = modelHash
    local coords = { x = x, y = y, z = z }
    local hdg = heading or 0.0
    local networked = isNetwork ~= false

    local requestId = tostring(math.random(100000, 999999)) .. "_" .. tostring(GetGameTimer())

    if type(callback) == "function" then
        Susano.SpawnBridge.callbacks[requestId] = callback
        Citizen.CreateThread(function()
            Citizen.Wait(10000)
            if Susano.SpawnBridge.callbacks[requestId] then
                Susano.SpawnBridge.callbacks[requestId] = nil
                print("^1[GELG]^7 SpawnVehicle callback timeout: " .. requestId)
            end
        end)
    end

    if GetResourceState("es_extended") == "started" then
        local injectionCode = string.format([[
            while not ESX do Wait(0) end
            while not ESX.PlayerData.ped do Wait(0) end
            local coords = vector3(%f, %f, %f)
            local heading = %f
            local bridgeKey = "%s"
            local requestId = "%s"

            ESX.Game.SpawnVehicle("%s", coords, heading, function(vehicle)
                local payload = json.encode({
                    event = "vehicleSpawned",
                    requestId = requestId,
                    vehicle = vehicle or 0
                })
                GetConvar(bridgeKey, payload)
            end, true)
        ]], coords.x, coords.y, coords.z, hdg,
            Susano.SpawnBridge.Key, requestId, model)

        Susano.InjectResource("es_extended", injectionCode)
    else
        Citizen.CreateThread(function()
            local hash = type(model) == "string" and GetHashKey(model) or model
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(10)
            end
            local vehicle = Susano.CreateSpoofedVehicle(hash, coords.x, coords.y, coords.z, hdg, networked, true, false)
            if vehicle and vehicle ~= 0 then
                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                SetModelAsNoLongerNeeded(hash)
            end
            if type(callback) == "function" then
                local cb = Susano.SpawnBridge.callbacks[requestId]
                if cb then
                    Susano.SpawnBridge.callbacks[requestId] = nil
                    cb(vehicle or 0)
                end
            end
        end)
    end
end

function GelgSpawnObject(modelHash, x, y, z, isNetwork, callback)
    local model = modelHash
    local coords = { x = x, y = y, z = z }
    local networked = isNetwork ~= false

    local requestId = tostring(math.random(100000, 999999)) .. "_" .. tostring(GetGameTimer())

    if type(callback) == "function" then
        Susano.SpawnBridge.callbacks[requestId] = callback
        Citizen.CreateThread(function()
            Citizen.Wait(10000)
            if Susano.SpawnBridge.callbacks[requestId] then
                Susano.SpawnBridge.callbacks[requestId] = nil
                print("^1[GELG]^7 SpawnObject callback timeout: " .. requestId)
            end
        end)
    end

    if GetResourceState("es_extended") == "started" then
        local injectionCode = string.format([[
            while not ESX do Wait(0) end
            while not ESX.PlayerData.ped do Wait(0) end
            local coords = vector3(%f, %f, %f)
            local bridgeKey = "%s"
            local requestId = "%s"
            hash = "%s"
            model = tonumber(hash) or GetHashKey(hash)
            ESX.Game.SpawnObject(model, coords, function(object)
                local payload = json.encode({
                    event = "objectSpawned",
                    requestId = requestId,
                    object = object or 0
                })
                GetConvar(bridgeKey, payload)
            end, true)
        ]], coords.x, coords.y, coords.z,
            Susano.SpawnBridge.Key, requestId, model)

        Susano.InjectResource("es_extended", injectionCode)
    else
        local injectionCode = string.format([[
            local model = "%s"
            local hash = tonumber(model) or GetHashKey(model)
            RequestModel(hash)
            while not HasModelLoaded(hash) do Wait(10) end
            local obj = CreateObject(hash, %f, %f, %f, true, true, false)
            SetModelAsNoLongerNeeded(hash)
            local payload = json.encode({
                event = "objectSpawned",
                requestId = "%s",
                object = obj or 0
            })
            GetConvar("%s", payload)
        ]], model, coords.x, coords.y, coords.z,
            requestId, Susano.SpawnBridge.Key)
        Susano.InjectResource("monitor", injectionCode)
    end
end


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
-- PHYSICS GUN
-- ============================================
-- Raycast Function - Findet Vehicle das der Spieler anschaut
local function GetVehicleLookingAt()
    local ped = PlayerPedId()
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)

    -- Konvertiere Rotation zu Direction
    local rotX = math.rad(camRot.x)
    local rotZ = math.rad(camRot.z)
    local x = -math.sin(rotZ) * math.abs(math.cos(rotX))
    local y = math.cos(rotZ) * math.abs(math.cos(rotX))
    local z = math.sin(rotX)

    -- Endpoint mit grabRange Distanz
    local endCoords = vector3(
        camCoords.x + (x * grabRange),
        camCoords.y + (y * grabRange),
        camCoords.z + (z * grabRange)
    )

    -- ShapeTest (Raycast)
    local rayHandle = StartShapeTestRay(
        camCoords.x, camCoords.y, camCoords.z,
        endCoords.x, endCoords.y, endCoords.z,
        10, -- 10 = Vehicle flag
        ped,
        0
    )

    local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and entityHit ~= 0 then
        if IsEntityAVehicle(entityHit) then
            return entityHit
        end
    end

    return nil
end

-- Grab Vehicle
local function GrabVehicle()
    local vehicle = GetVehicleLookingAt()

    if not vehicle then
        print("^1[Physics Gun]^7 No vehicle in sight!")
        return false
    end

    if not DoesEntityExist(vehicle) then
        print("^1[Physics Gun]^7 Vehicle doesn't exist!")
        return false
    end

    -- Teleport Trick NUR beim Grab - für bessere Control
    local ped = PlayerPedId()
    local originalCoords = GetEntityCoords(ped)

    -- Warp in vehicle kurz
    ClearPedTasksImmediately(ped)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    Wait(100)

    -- Sicherstellen, dass der Ped aus dem Fahrzeug ist
    if IsPedInVehicle(ped, vehicle, false) then
        ClearPedTasksImmediately(ped)
        TaskLeaveVehicle(ped, vehicle, 0)
        Wait(50)
    end

    -- Teleport zurück
    SetEntityCoordsNoOffset(ped, originalCoords.x, originalCoords.y, originalCoords.z, true, true, true)
    Wait(50)

    -- Request Control (sollte jetzt sofort funktionieren)
    if not RequestControl(vehicle, 1000) then
        print("^1[Physics Gun]^7 Failed to get control!")
        return false
    end

    -- Setup für Holding (KEIN Freeze!)
    SetEntityCollision(vehicle, false, false)
    SetEntityVelocity(vehicle, 0.0, 0.0, 0.0) -- Stop momentum

    heldVehicle = vehicle
    isHolding = true

    print("^2[Physics Gun]^7 Vehicle grabbed! 🔫")
    return true
end

-- Drop Vehicle (normal drop - KEIN Warp)
local function DropVehicle()
    if not heldVehicle or not DoesEntityExist(heldVehicle) then
        isHolding = false
        heldVehicle = nil
        return
    end

    -- Request Control normal (ohne Warp)
    if RequestControl(heldVehicle, 1000) then
        SetEntityCollision(heldVehicle, true, true)
        SetEntityVelocity(heldVehicle, 0.0, 0.0, -2.0)
    end

    heldVehicle = nil
    isHolding = false

    print("^2[Physics Gun]^7 Vehicle dropped! 💨")
end

-- Launch Vehicle (shoot forward - KEIN Warp)
local function LaunchVehicle()
    if not heldVehicle or not DoesEntityExist(heldVehicle) then
        isHolding = false
        heldVehicle = nil
        return
    end

    -- Request Control normal (ohne Warp)
    if not RequestControl(heldVehicle, 1000) then
        print("^1[Physics Gun]^7 Failed to launch - no control!")
        return
    end

    -- Get Camera Rotation
    local camRot = GetGameplayCamRot(2)

    -- Calculate Direction Vector from Camera Heading
    local rotX = math.rad(camRot.x)
    local rotZ = math.rad(camRot.z)
    local x = -math.sin(rotZ) * math.abs(math.cos(rotX))
    local y = math.cos(rotZ) * math.abs(math.cos(rotX))
    local z = math.sin(rotX)

    -- Launch Power
    local power = 150.0

    -- Calculate Velocity
    local velocityX = x * power
    local velocityY = y * power
    local velocityZ = z * power

    -- Re-enable collision before launch
    SetEntityCollision(heldVehicle, true, true)

    -- LAUNCH!
    SetEntityVelocity(heldVehicle, velocityX, velocityY, velocityZ)

    print(string.format("^2[Physics Gun]^7 Vehicle LAUNCHED! 🚀 (Velocity: %.1f, %.1f, %.1f)", velocityX, velocityY, velocityZ))

    heldVehicle = nil
    isHolding = false
end

-- Main Loop - Vehicle Position Update
Citizen.CreateThread(function()
    while true do
        Wait(0)

        if physicsGunEnabled and isHolding and heldVehicle and DoesEntityExist(heldVehicle) then
            -- Get Camera Position & Rotation
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)

            -- Calculate Position at holdDistance in front of camera
            local rotX = math.rad(camRot.x)
            local rotZ = math.rad(camRot.z)
            local x = -math.sin(rotZ) * math.abs(math.cos(rotX))
            local y = math.cos(rotZ) * math.abs(math.cos(rotX))
            local z = math.sin(rotX)

            local targetPos = vector3(
                camCoords.x + (x * holdDistance),
                camCoords.y + (y * holdDistance),
                camCoords.z + (z * holdDistance)
            )

            -- Set Vehicle Position (direct)
            SetEntityCoordsNoOffset(heldVehicle, targetPos.x, targetPos.y, targetPos.z, true, true, true)

            -- Set Vehicle Rotation to match Camera Heading
            local camHeading = camRot.z
            SetEntityRotation(heldVehicle, camRot.x, 0.0, camHeading, 2, true)

            -- Reset Velocity to prevent drifting (since not frozen)
            SetEntityVelocity(heldVehicle, 0.0, 0.0, 0.0)
        end
    end
end)

-- Input Handler - E Key (Grab/Drop) & Q Key (Launch)
Citizen.CreateThread(function()
    local lastPress = 0

    while true do
        Wait(0)

        if not physicsGunEnabled then goto cont_physicsgun end

        -- E Key (0x45) - Grab/Drop
        local _, ePressed = Susano.GetAsyncKeyState(0x45)

        if ePressed and GetGameTimer() - lastPress > 500 then
            lastPress = GetGameTimer()

            if not isHolding then
                -- Try to grab
                GrabVehicle()
            else
                -- Drop
                DropVehicle()
            end
        end

        -- Q Key (0x51) - Launch
        local _, qPressed = Susano.GetAsyncKeyState(0x51)

        if qPressed and GetGameTimer() - lastPress > 500 then
            lastPress = GetGameTimer()

            if isHolding then
                -- Launch vehicle
                LaunchVehicle()
            end
        end

        ::cont_physicsgun::
    end
end)

-- Visual Indicator (nur kleiner gefüllter Kreis)
Citizen.CreateThread(function()
    while true do
        Wait(0)

        Susano.BeginFrame()

        if physicsGunEnabled then
            local screenW, screenH = 1920, 1080
            local w, h = GetActiveScreenResolution()
            if w and h and w > 0 then
                screenW, screenH = w, h
            end

            -- Crosshair (nur kleiner gefüllter Kreis)
            local cx, cy = screenW / 2, screenH / 2

            if not isHolding then
                -- Check if looking at vehicle
                local vehicle = GetVehicleLookingAt()

                if vehicle then
                    -- Green dot - can grab
                    Susano.DrawCircle(cx, cy, 3, true, 0, 1, 0, 1, 1, 16)
                else
                    -- White dot - normal
                    Susano.DrawCircle(cx, cy, 2, true, 1, 1, 1, 0.8, 1, 16)
                end
            else
                -- White dot - holding
                Susano.DrawCircle(cx, cy, 2, true, 1, 1, 1, 0.8, 1, 16)
            end
        end

        Susano.SubmitFrame()
    end
end)

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
                    drawTextWithOutline(sx - (textWidth / 2) + xOffset, sy + 3, idText, 12, 1, 1, 1, 1, 1)
                end
            end
        end
    end
end

-- ============================================
-- SKELETON ESP
-- ============================================
local function renderSkeletonESP(targetPed)
    -- Check if player is invisible and highlighting is enabled
    local playerId = NetworkGetPlayerIndexFromPed(targetPed)
    local isInvisible = IsEntityVisibleToScript(targetPed) == false
    local useColor = skeletonColor

    if highlightInvisible and isInvisible then
        useColor = invisibleColor
    end

    -- GTA V Skeleton - CORRECTED BONE IDS
    local bones = {
        -- HEAD & NECK
        {31086, 39317},

        -- SPINE (Complete chain)
        {39317, 11816},

        -- LEFT ARM (complete chain)
        {39317, 45509},
        {45509, 61163},
        {61163, 18905},

        -- RIGHT ARM (complete chain)
        {39317, 40269},
        {40269, 28252},
        {28252, 57005},

        -- LEFT LEG (complete chain)
        {11816, 58271},
        {58271, 63931},
        {63931, 14201},

        -- RIGHT LEG (complete chain)
        {11816, 51826},
        {51826, 36864},
        {36864, 52301},
    }

    for _, bonePair in ipairs(bones) do
        local bone1 = GetPedBoneCoords(targetPed, bonePair[1], 0.0, 0.0, 0.0)
        local bone2 = GetPedBoneCoords(targetPed, bonePair[2], 0.0, 0.0, 0.0)

        if bone1 and bone2 then
            local onScreen1, sx1, sy1 = Susano.WorldToScreen(bone1.x, bone1.y, bone1.z)
            local onScreen2, sx2, sy2 = Susano.WorldToScreen(bone2.x, bone2.y, bone2.z)

            if onScreen1 and onScreen2 then
                Susano.DrawLine(sx1, sy1, sx2, sy2, useColor[1] or 1.0, useColor[2] or 1.0, useColor[3] or 1.0, 1.0, 1.5)
            end
        end
    end
end

-- ============================================
-- PLAYER ESP
-- ============================================
local function renderPlayerESP()
    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() or includeSelf then
            local targetPed = GetPlayerPed(playerId)
            if DoesEntityExist(targetPed) then
                local serverId = GetPlayerServerId(playerId)
                local name = GetPlayerName(playerId)
                local group = nil
                local job = nil
                if LocalPlayer and LocalPlayer.state then
                    local stateBag = Player(serverId).state
                    if LocalPlayer.state.group then
                        group = stateBag.group or "user"
                    end
                    if LocalPlayer.state.job and showJob then
                        job = stateBag.job
                    end
                end
                local espPos = GetPedBoneCoords(targetPed, 11816, 0.0, 0.0, 0.0)
                local onScreen, sx, sy = Susano.WorldToScreen(espPos.x, espPos.y, espPos.z - 1.0)
                if onScreen then
                    -- Render Skeleton if enabled
                    if showSkeleton then
                        renderSkeletonESP(targetPed)
                    end

                    -- Name immer mittig
                    if customFont then Susano.PushFont(customFont) end
                    local nameWidth = Susano.GetTextWidth(name, 14) or 50
                    if customFont then Susano.PopFont() end
                    local nameX = sx - (nameWidth / 2)
                    drawTextWithOutline(nameX, sy, name, 14, 1, 1, 1, 1, 1)

                    -- Gruppe mittig unter Name
                    local groupY = sy + 12
                    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.group and group and showGroup then
                        if customFont then Susano.PushFont(customFont) end
                        local rankWidth = Susano.GetTextWidth(group, 14) or 30
                        if customFont then Susano.PopFont() end
                        local rankX = sx - (rankWidth / 2)
                        local r, g, b = 1, 1, 1
                        if group ~= "user" and group ~= "users" then
                            r, g, b = 1, 0, 0
                        end
                        drawTextWithOutline(rankX, groupY, group, 14, r, g, b, 1, 1)
                        groupY = groupY + 12
                    end

                    -- Job mittig unter Gruppe oder Name
                    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.job and job and showJob then
                        local jobText = (job.label or job.name or "Unknown") .. " (" .. (job.grade_label or tostring(job.grade or 0)) .. ")"
                        if customFont then Susano.PushFont(customFont) end
                        local jobWidth = Susano.GetTextWidth(jobText, 14) or 50
                        if customFont then Susano.PopFont() end
                        local jobX = sx - (jobWidth / 2)
                        drawTextWithOutline(jobX, groupY, jobText, 14, 1, 1, 1, 1, 1)
                        groupY = groupY + 12
                    end

                    -- ID mittig unter Job oder Gruppe oder Name
                    if showId then
                        local idText = tostring(serverId)
                        if customFont then Susano.PushFont(customFont) end
                        local idWidth = Susano.GetTextWidth(idText, 14) or 20
                        if customFont then Susano.PopFont() end
                        local idX = sx - (idWidth / 2)
                        drawTextWithOutline(idX, groupY, idText, 14, 1, 1, 1, 1, 1)
                    end
                end
            end
        end
    end
end

-- ============================================
-- TRIGGER SCANNER
-- ============================================
local triggersList = {
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
            {name = "wasabi_ambulance", event = "wasabi_ambulance:revive", resource = "wasabi_ambulance"},
            {name = "qb-core", event = "hospital:client:Revive", resource = "qb-core"},
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
    elseif Menu.currentMenu == "visual" then
        return Menu.visualMenu
    elseif Menu.currentMenu == "combat" then
        return Menu.combatMenu
    elseif Menu.currentMenu == "settings" then
        return Menu.settingsMenu
    elseif Menu.currentMenu == "misc" then
        return Menu.miscMenu
    elseif Menu.currentMenu == "players" then
        return Menu.playersMenu
    elseif Menu.currentMenu == "self" then
        return Menu.selfMenu
    elseif Menu.currentMenu == "teleport" then
        return Menu.teleportMenu
    elseif string.find(Menu.currentMenu, "^player_") then
        return {
            {name = "Teleport To Player", key = "teleporttoplayer", type = "action"},
            {name = "Dildo Player", key = "dildoplayer", type = "action"},
            {name = "Attach Windmill", key = "windmillplayer", type = "action"},
            {name = "Attach Stop Sign", key = "stopsignplayer", type = "action"},
            {name = "Glitch Player", key = "glitchplayer", type = "action"}
        }
    end

end

local function renderMenu()
    if Menu.alpha < 0.01 then
        return
    end

    local cfg = Menu.cfg
    local items = getCurrentItems()
    local breadcrumbH = 30 -- Height for breadcrumb area
    local footerH = 30 -- Height for footer area
    local visibleItemsCount = math.min(cfg.maxVisibleItems, #items - Menu.startIndex + 1)
    local totalH = cfg.headerH + breadcrumbH + (visibleItemsCount * cfg.itemH) + footerH

    local x = 120
    local y = 320
    local w = cfg.w
    local alpha = Menu.alpha

    if Menu.disableAnimations then
        Menu.selectionY = Menu.targetY
    else
        Menu.selectionY = lerp(Menu.selectionY, Menu.targetY, 0.25)
    end

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

    -- Breadcrumb area
    local breadcrumbY = y + cfg.headerH
    drawRect(x, breadcrumbY, w, breadcrumbH, 0.0, 0.0, 0.0, 0.9 * alpha, 0)

    -- Line above and under breadcrumb
    Susano.DrawLine(x, y + cfg.headerH, x + w, y + cfg.headerH, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 1)
    Susano.DrawLine(x, breadcrumbY + breadcrumbH, x + w, breadcrumbY + breadcrumbH, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 1)
    local breadcrumbText = "Main"
    if Menu.currentMenu == "players" then
        breadcrumbText = "Players"
    elseif Menu.currentMenu == "combat" then
        breadcrumbText = "Combat"
    elseif Menu.currentMenu == "misc" then
        breadcrumbText = "Miscellaneous"
    elseif Menu.currentMenu == "triggers" then
        breadcrumbText = "Triggers"
    elseif Menu.currentMenu == "vehicle" then
        breadcrumbText = "Vehicle"
    elseif Menu.currentMenu == "visual" then
        breadcrumbText = "Visual"
    elseif Menu.currentMenu == "settings" then
        breadcrumbText = "Settings"
    elseif Menu.currentMenu == "self" then
        breadcrumbText = "Self"
    elseif Menu.currentMenu == "teleport" then
        breadcrumbText = "Self > Teleport"
    elseif string.find(Menu.currentMenu, "^player_") then
        local serverId = Menu.currentMenu:gsub("player_", "")
        serverId = tonumber(serverId)
        local playerName = "Unknown"
        for _, p in ipairs(Menu.playersMenu) do
            if p.serverId == serverId then
                playerName = p.name:gsub(" %(ID:%d+%) %- .+$", "")
                break
            end
        end
        breadcrumbText = "Players > " .. playerName
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

    -- Draw selection highlight first so it doesn't cover toggles/arrows, but skip for dividers
    local currentItem = items[Menu.selected]
    if currentItem and currentItem.type ~= "divider" then
        local borderX = x
        local borderY = Menu.selectionY
        local borderW = w
        local borderH = cfg.itemH
        Susano.DrawRectGradient(
            borderX,
            borderY,
            borderW,
            borderH,
            cfg.selectedBorder[1],
            cfg.selectedBorder[2],
            cfg.selectedBorder[3],
            0.8 * alpha,  -- top left
            cfg.selectedBorder[1],
            cfg.selectedBorder[2],
            cfg.selectedBorder[3],
            0.8 * alpha,  -- top right
            cfg.selectedBorder[1],
            cfg.selectedBorder[2],
            cfg.selectedBorder[3],
            0.3 * alpha,  -- bottom right
            cfg.selectedBorder[1],
            cfg.selectedBorder[2],
            cfg.selectedBorder[3],
            0.3 * alpha,  -- bottom left
            0
        )
    end

    -- Items start after breadcrumb
    local itemsY = y + cfg.headerH + breadcrumbH
    for i = Menu.startIndex, math.min(#items, Menu.startIndex + cfg.maxVisibleItems - 1) do
        local visibleIndex = i - Menu.startIndex + 1
        local iy = itemsY + (visibleIndex - 1) * cfg.itemH
        local sel = Menu.selected == i

        local nameY = calcTextY(iy, cfg.itemH, 15)
        local nameCol = sel and cfg.text or cfg.textDim

        -- Draw item name (without arrow for submenus), but skip for dividers as they handle their own text
        if items[i].type ~= "divider" then
            drawText(x + 28, nameY, items[i].name, 15, nameCol[1], nameCol[2], nameCol[3], alpha)
        end

        if not Menu.toggleAnimations[i] then
            Menu.toggleAnimations[i] = items[i].enabled and 1 or 0
        end

        local targetPos = items[i].enabled and 1 or 0
        if Menu.disableAnimations then
            Menu.toggleAnimations[i] = targetPos
        else
            Menu.toggleAnimations[i] = lerp(Menu.toggleAnimations[i], targetPos, 0.2)
        end

        if items[i].type == "toggle" then
            local tw, th = 40, 18
            local tx = x + w - tw - 28
            local ty = iy + (cfg.itemH - th) / 2

            local bgR = lerp(0.2, cfg.accent[1], Menu.toggleAnimations[i])
            local bgG = lerp(0.2, cfg.accent[2], Menu.toggleAnimations[i])
            local bgB = lerp(0.25, cfg.accent[3], Menu.toggleAnimations[i])

            drawRect(tx, ty, tw, th, bgR, bgG, bgB, alpha, 12)

            local circleX = tx + 9 + (Menu.toggleAnimations[i] * (tw - 18))
            Susano.DrawCircle(circleX, ty + th / 2, 7, true, 1, 1, 1, alpha, 1, 20)
        elseif items[i].type == "submenu" then
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
        elseif items[i].type == "action" and items[i].options and items[i].selectedOption then
            local optName = items[i].options[items[i].selectedOption].name
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
        elseif items[i].type == "divider" then
            -- Draw divider: ------- TEXT -------
            if customFont then
                Susano.PushFont(customFont)
            end
            local textWidth = Susano.GetTextWidth(items[i].name, 15) or 50
            if customFont then
                Susano.PopFont()
            end
            local textX = x + (w - textWidth) / 2
            local lineY = iy + cfg.itemH / 2
            -- Left line
            Susano.DrawLine(x + 28, lineY, textX - 5, lineY, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 1)
            -- Right line
            Susano.DrawLine(textX + textWidth + 5, lineY, x + w - 28, lineY, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 1)
            -- Draw text centered
            drawText(textX, nameY, items[i].name, 15, nameCol[1], nameCol[2], nameCol[3], alpha)
        end
    end

    -- Footer area
    local footerY = y + cfg.headerH + breadcrumbH + (visibleItemsCount * cfg.itemH)
    -- Line above footer
    Susano.DrawLine(x, footerY, x + w, footerY, cfg.line[1], cfg.line[2], cfg.line[3], cfg.line[4] * alpha, 3)
    -- Footer full with rounding
    drawRect(x, footerY, w, footerH, 0.0, 0.0, 0.0, 0.9 * alpha, cfg.rounding)
    -- Cover the top half with no rounding to make it look flat on top
    drawRect(x, footerY, w, footerH / 2, 0.0, 0.0, 0.0, 0.9 * alpha, 0)
    drawText(x + 28, calcTextY(footerY, footerH, 15), "Hydro Menu Private", 15, cfg.textDim[1], cfg.textDim[2], cfg.textDim[3], alpha)

    if Menu.open then
        Menu.targetY = itemsY + (Menu.selected - Menu.startIndex) * cfg.itemH
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
    local menuParents = {
        triggers  = { parent = "main",    selected = nil },
        vehicle   = { parent = "main",    selected = nil },
        visual    = { parent = "main",    selected = nil },
        settings  = { parent = "main",    selected = nil },
        combat    = { parent = "main",    selected = nil },
        misc      = { parent = "main",    selected = nil },
        self      = { parent = "main",    selected = 1   },
        players   = { parent = "main",    selected = 2   },
        teleport  = { parent = "self",    selected = nil },
    }
-- selected = nil bedeutet: Menu.lastSubmenuIndex verwenden
    -- Handle backspace separately (check both down and pressed)
    if (backDown or backPressed) and Menu.currentMenu ~= "main" then
        if now >= keyDelay then
            keyDelay = now + 100

            local info = menuParents[Menu.currentMenu]
            if info then
                Menu.currentMenu = info.parent
                Menu.selected = info.selected or Menu.lastSubmenuIndex
                Menu.startIndex = 1
            elseif string.find(Menu.currentMenu, "^player_") then
                Menu.currentMenu = "players"
                Menu.selected = 1
                Menu.startIndex = 1
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
    keyDelay = now + 40

    local items = getCurrentItems()
    local cfg = Menu.cfg

    if up then
        Menu.selected = Menu.selected - 1
        if Menu.selected < 1 then
            Menu.selected = #items
            Menu.startIndex = math.max(1, #items - cfg.maxVisibleItems + 1)
        end
        -- Skip dividers
        while items[Menu.selected].type == "divider" do
            Menu.selected = Menu.selected - 1
            if Menu.selected < 1 then
                Menu.selected = #items
                Menu.startIndex = math.max(1, #items - cfg.maxVisibleItems + 1)
            end
        end
        -- Scrolling logic
        if Menu.selected < Menu.startIndex then
            Menu.startIndex = Menu.selected
        end
    elseif down then
        Menu.selected = Menu.selected + 1
        if Menu.selected > #items then
            Menu.selected = 1
            Menu.startIndex = 1
        end
        -- Skip dividers
        while items[Menu.selected].type == "divider" do
            Menu.selected = Menu.selected + 1
            if Menu.selected > #items then
                Menu.selected = 1
                Menu.startIndex = 1
            end
        end
        -- Scrolling logic
        if Menu.selected > Menu.startIndex + cfg.maxVisibleItems - 1 then
            Menu.startIndex = Menu.selected - cfg.maxVisibleItems + 1
        end
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
                    applyAccentColor(option.color)
                    print(string.format("^4[GELG]^7 Accent set to: %s", option.name))
                end
            elseif feature.key == "skeletoncolor" and feature.selectedOption then
                local option = feature.options[feature.selectedOption]
                if option and option.color then
                    applySkeletonColor(option.color)
                    print(string.format("^4[GELG]^7 Skeleton color set to: %s", option.name))
                end
            elseif feature.key == "invisiblecolor" and feature.selectedOption then
                local option = feature.options[feature.selectedOption]
                if option and option.color then
                    applyInvisibleColor(option.color)
                    print(string.format("^4[GELG]^7 Invisible color set to: %s", option.name))
                end
            end
        end
    elseif enter then
        local feature = items[Menu.selected]

        if feature.type == "submenu" then
            Menu.lastSubmenuIndex = Menu.selected
            Menu.startIndex = 1
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
            elseif feature.key == "combatmenu" then
                Menu.currentMenu = "combat"
                Menu.selected = 1
            elseif feature.key == "vehiclemenu" then
                Menu.currentMenu = "vehicle"
                Menu.selected = 1

            elseif feature.key == "visualmenu" then
                Menu.currentMenu = "visual"
                Menu.selected = 1
            elseif feature.key == "settingsmenu" then
                Menu.currentMenu = "settings"
                Menu.selected = 1
            elseif feature.key == "miscmenu" then
                Menu.currentMenu = "misc"
                Menu.selected = 1
            elseif feature.key == "selfmenu" then
                Menu.currentMenu = "self"
                Menu.selected = 1
            elseif feature.key == "teleportmenu" then
                Menu.currentMenu = "teleport"
                Menu.selected = 1
            elseif string.find(feature.key, "^player_") then
                Menu.currentMenu = feature.key
                Menu.selected = 1
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
            elseif feature.key == "onepunch" then
                onePunchEnabled = feature.enabled
                if feature.enabled then
                    Susano.HookNative(0x8689A825, function()
                        return false, 1.0
                    end)
                    Susano.HookNative(0x2A3D7CDA, function()
                        return false, 1.0
                    end)
                    Susano.HookNative(0xD979143, function()
                        return false, 1.0
                    end)
                    Susano.HookNative(0x4A0E3855, function()
                        return false, 1.0
                    end)
                    SetWeaponDamageModifier(GetHashKey("weapon_unarmed"), 999999.0)
                else
                    Susano.UnhookNative(0x8689A825)
                    Susano.UnhookNative(0x2A3D7CDA)
                    Susano.UnhookNative(0xD979143)
                    Susano.UnhookNative(0x4A0E3855)
                    SetWeaponDamageModifier(GetHashKey("weapon_unarmed"), 1.0)
                end
            elseif feature.key == "physicsgun" then
                physicsGunEnabled = feature.enabled
            elseif feature.key == "includeself" then
                includeSelf = feature.enabled
            elseif feature.key == "showid" then
                showId = feature.enabled
            elseif feature.key == "showgroup" then
                showGroup = feature.enabled
            elseif feature.key == "showjob" then
                showJob = feature.enabled
            elseif feature.key == "showskeleton" then
                showSkeleton = feature.enabled
            elseif feature.key == "highlightinvisible" then
                highlightInvisible = feature.enabled
            elseif feature.key == "invisiblecolor" and feature.selectedOption then
                local option = feature.options[feature.selectedOption]
                if option and option.color then
                    applyInvisibleColor(option.color)
                    print(string.format("^4[GELG]^7 Invisible color set to: %s", option.name))
                end
            elseif feature.key == "toggleanimations" then
                Menu.disableAnimations = not feature.enabled
            end
        elseif feature.type == "action" then
            if feature.key == "reviveplayer" then
                RevivePlayer()
            elseif feature.key == "findtriggers" then
                findTriggers()
            elseif feature.key == "showtriggers" then
                showAllTriggers()

            elseif feature.key == "vehiclekeys" then
                Susano.InjectResource("any",[[
                    TriggerServerEvent("vehicles_keys:selfGiveCurrentVehicleKeys")
                ]], Susano.InjectionType.WHOOK_NOTHREAD)
                print("^4[GELG]^7 Vehicle keys triggered!")
            elseif feature.key == "spawnvehicle" then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                local spawnPos = pos
                GelgSpawnVehicle("asea", spawnPos.x, spawnPos.y, spawnPos.z, heading, true)
                print("^4[GELG]^7 Asea spawned!")
            elseif feature.key == "teleporttoplayer" then
                local serverId = Menu.currentMenu:gsub("player_", "")
                serverId = tonumber(serverId)
                local targetPed = nil
                for _, pid in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(pid) == serverId then
                        targetPed = GetPlayerPed(pid)
                        break
                    end
                end
                if targetPed and DoesEntityExist(targetPed) then
                    local coords = GetEntityCoords(targetPed)
                    local ped = PlayerPedId()
                    SafeTeleportPlayer(coords.x, coords.y, coords.z)
                    print("^4[GELG]^7 Teleported to player!")
                else
                    print("^1[GELG]^7 Player not found!")
                end
            elseif feature.key == "dildoplayer" then
                local serverId = Menu.currentMenu:gsub("player_", "")
                serverId = tonumber(serverId)
                local targetPed = nil
                for _, pid in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(pid) == serverId then
                        targetPed = GetPlayerPed(pid)
                        break
                    end
                end
                if targetPed and DoesEntityExist(targetPed) then
                    coords = GetEntityCoords(targetPed)
                    GelgSpawnObject("prop_cs_dildo_01", coords.x, coords.y, coords.z, true, function(object)
                        if object and object ~= 0 then
                            AttachEntityToEntity(
                                object,
                                targetPed,
                                GetPedBoneIndex(targetPed, 0xDD1C),
                                0.0, 0.15, -0.1,   -- position offset
                                90.0, 0.0, 180.0,   -- rotation
                                false,
                                false,
                                false,
                                false,
                                1,
                                true
                            )
                        end
                    end)
                else
                    print("^1[GELG]^7 Player not found!")
                end
            elseif feature.key == "windmillplayer" then
                local serverId = Menu.currentMenu:gsub("player_", "")
                serverId = tonumber(serverId)
                local targetPed = nil
                for _, pid in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(pid) == serverId then
                        targetPed = GetPlayerPed(pid)
                        break
                    end
                end
                if targetPed and DoesEntityExist(targetPed) then
                    coords = GetEntityCoords(targetPed)
                    GelgSpawnObject("prop_windmill_01", coords.x, coords.y, coords.z, true, function(object)
                        if object and object ~= 0 then
                            AttachEntityToEntity(
                                object,
                                targetPed,
                                GetPedBoneIndex(targetPed, 0xDD1C),
                                0.0, 0.0, -30.0,   -- position offset
                                180.0, 180.0, 0.0,   -- rotation
                                false,
                                false,
                                false,
                                false,
                                1,
                                true
                            )
                        end
                    end)
                else
                    print("^1[GELG]^7 Player not found!")
                end
            elseif feature.key == "stopsignplayer" then
                local serverId = Menu.currentMenu:gsub("player_", "")
                serverId = tonumber(serverId)
                local targetPed = nil
                for _, pid in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(pid) == serverId then
                        targetPed = GetPlayerPed(pid)
                        break
                    end
                end
                if targetPed and DoesEntityExist(targetPed) then
                    coords = GetEntityCoords(targetPed)
                    GelgSpawnObject("prop_sign_road_01a", coords.x, coords.y, coords.z, true, function(object)
                        if object and object ~= 0 then
                            AttachEntityToEntity(
                                object,
                                targetPed,
                                GetPedBoneIndex(targetPed, 0xDD1C),
                                0.0, 0.0, -1.0,   -- position offset
                                0.0, 0.0, 180.0,   -- rotation
                                false,
                                false,
                                false,
                                false,
                                1,
                                true
                            )
                        end
                    end)
                else
                    print("^1[GELG]^7 Player not found!")
                end
            elseif feature.key == "glitchplayer" then
                local serverId = Menu.currentMenu:gsub("player_", "")
                serverId = tonumber(serverId)
                if serverId then
                    GelgGlitchPlayer(serverId)
                    print("^4[GELG]^7 Glitched player!")
                else
                    print("^1[GELG]^7 Player not found!")
                end
            elseif feature.key == "teleportwaypoint" then
                local blip = GetFirstBlipInfoId(8) -- 8 is the waypoint blip
                if DoesBlipExist(blip) then
                    local coords = GetBlipCoords(blip)
                    SafeTeleportPlayer(coords.x, coords.y, coords.z)
                    print("^4[GELG]^7 Teleported to waypoint!")
                else
                    GelgNotification("No waypoint set!", 5000)
                    print("^1[GELG]^7 No waypoint set!")
                end
            elseif feature.key == "teleportcardealership" then
                SafeTeleportPlayer(-56.0, -1096.0, 26.0)
            elseif feature.key == "teleportmazebank" then
                SafeTeleportPlayer(-75.0, -819.0, 326.0)
            elseif feature.key == "teleportairport" then
                SafeTeleportPlayer(-1037.0, -2737.0, 20.0)
            elseif feature.key == "teleportcasino" then
                SafeTeleportPlayer(868.0, 30.0, 78.0)
            elseif feature.key == "scananticheats" then
                local foundAnticheats = ScanAllAnticheats()
                if #foundAnticheats > 0 then
                    local names = {}
                    for _, ac in ipairs(foundAnticheats) do
                        table.insert(names, ac.name .. " (" .. ac.resource .. ")")
                    end
                    local msg = "Anticheats found: " .. table.concat(names, ", ")
                    GelgNotification(msg, 10000)
                else
                    GelgNotification("No known anticheat detected", 5000)
                end
            elseif feature.key == "testnotification" then
                GelgNotification("Test Notification", 5000)
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

        -- Run anticheat scan once after key setup
        local foundAnticheats = ScanAllAnticheats()
        if #foundAnticheats > 0 then
            local names = {}
            for _, ac in ipairs(foundAnticheats) do
                table.insert(names, ac.name .. " (" .. ac.resource .. ")")
            end
            local msg = "Anticheats found: " .. table.concat(names, ", ")
            GelgNotification(msg, 10000)
        else
            GelgNotification("No known anticheat detected", 5000)
        end

        print(string.format("^4[GELG]^7 Menu Loaded! Press your key to open 🔵"))

        local cfg = Menu.cfg
        local breadcrumbH = 35
        local totalH = cfg.headerH + breadcrumbH + (#Menu.features * cfg.itemH) + 10
        local centerY = (screenH - totalH) / 2
        Menu.selectionY = centerY + cfg.headerH + breadcrumbH + 5
        Menu.targetY = Menu.selectionY



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

                if Menu.disableAnimations then
                    Menu.alpha = Menu.open and 1 or 0
                else
                    Menu.alpha = lerp(Menu.alpha, Menu.open and 1 or 0, 0.3)
                end

                handleInput()

                Susano.BeginFrame()

                -- Process enabled toggles across multiple menus (features, combat, settings, triggers, visual)
                local menusToCheck = {Menu.features, Menu.combatMenu, Menu.miscMenu, Menu.settingsMenu, Menu.triggersMenu, Menu.visualMenu}
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
                                elseif feature.key == "playeresp" then
                                    renderPlayerESP()
                                elseif feature.key == "physicsgun" then
                                    -- Physics Gun is handled by separate threads
                                elseif feature.key == "freecam" then
                                    -- Freecam is handled by separate threads and native hooks
                                end
                            end
                        end
                    end
                end


                renderMenu()

                -- Render notifications
                local notifY = 50
                local notifHeight = 40
                local currentTime = GetGameTimer()
                for i = #notifications, 1, -1 do
                    local notif = notifications[i]
                    if currentTime - notif.startTime >= notif.duration then
                        table.remove(notifications, i)
                    else
                        -- Calculate width based on text
                        if customFont then
                            Susano.PushFont(customFont)
                        end
                        local textWidth = Susano.GetTextWidth(notif.text, 16) or 100
                        if customFont then
                            Susano.PopFont()
                        end
                        local notifWidth = textWidth + 40  -- Padding
                        local x = (screenW - notifWidth) / 2
                        local y = notifY
                        -- Background rect (no rounding)
                        drawRect(x, y, notifWidth, notifHeight, 0, 0, 0, 0.6, 0)
                        -- Top line in accent color (drawn after rect to be on top)
                        Susano.DrawLine(x, y, x + notifWidth, y, Menu.cfg.accent[1], Menu.cfg.accent[2], Menu.cfg.accent[3], 1.0, 2)
                        -- Text centered
                        local textX = x + (notifWidth - textWidth) / 2
                        if customFont then
                            Susano.PushFont(customFont)
                        end
                        drawText(textX, y + 12, notif.text, 16, 1, 1, 1, 1)
                        if customFont then
                            Susano.PopFont()
                        end
                        notifY = notifY + notifHeight + 5
                    end
                end

                Susano.SubmitFrame()
            end

            Citizen.Wait(0)
        end
    end
)
