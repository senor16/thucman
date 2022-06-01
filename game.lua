-- API
--[[

vthumb.display.width  : largeur de l'écran
vthumb.display.height : heuteur de l'écran

Récupérer l'état des boutons :
vthumb.buttonA.pressed / justPressed
vthumb.buttonB.pressed / justPressed
vthumb.buttonU.pressed / justPressed
vthumb.buttonD.pressed / justPressed
vthumb.buttonL.pressed / justPressed
vthumb.buttonR.pressed / justPressed

Modifier un pixel :
vthumb.setPixel(x,y)

Lire la valeur d'un pixel (0 ou 1) :
pixel = vthumb.getPixel(x,y)

Dessiner un sprite (8x8, chaque ligne décrite avec un octet)
sprite = {255, 129, 129, 129, 129, 129, 129, 255}
vthumb.Sprite(x, y, sprite)

]]
-- Game variables
local level = 1
local gameOver = false
local gameWon = false

-- Game constants
local DOT = "."
local GHOST = "GHOST"
local GHOST_LEVEL_INKY = "i"
local GHOST_LEVEL_PINKY = "p"
local GHOST_LEVEL_BLINKY = "b"
local GHOST_LEVEL_CLYDE = "c"
local BONUS = "BONUS"
local PACMAN = "PACMAN"

-- Lists
local listElements = {}
local listDots = {}
local listGhosts = {}
local listBonus = {}

function addElement(pX, pY, pSprite, pType)
    local el = {x = pX, y = pY, sprite = pSprite, del = false, type = pType}
    table.insert(listElements, el)
    return el
end

function addGhost(pX, pY, pSprite, pLevel)
    local gh = addElement(pX, pY, pSprite, GHOST)
    gh.level = pLevel
    table.insert(listGhosts, gh)
end

function addDots(pX, pY, pSprite, pLevel)
    local dt = addElement(pX, pY, pSprite, DOT)
    dt.level = pLevel
    table.insert(listDots, dt)
end

function addBonus(pX, pY, pSprite, pLevel)
    local bn = addElement(pX, pY, pSprite, BONUS)
    bn.level = pLevel
    table.insert(listBonus, bn)
end

-- Camera
camera = {x = 0, y = 0}

-- Map
local map = {}
map.height = 9
map.width = 14
map.grid = {}
map.grid[1] = {
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    ".............."
}

map.grid[2] = {
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    ".............."
}

map.grid[3] = {
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    ".............."
}

map.grid[4] = {
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    ".............."
}

map.grid[5] = {
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    "..............",
    ".............."
}

-- Items
local dots = {0, 0, 0, 24, 24, 0, 0, 0}
local bigdot = {0, 24, 60, 126, 126, 60, 24, 0}
local tomato = {8, 60, 126, 126, 126, 126, 60, 24}
local candy = {15, 18, 100, 244, 236, 94, 30, 12}

-- ghost animations
local ghost = {}
ghost.topRight = {
    {0, 124, 254, 146, 218, 254, 254, 170},
    {0, 124, 254, 146, 218, 254, 254, 84}
}

ghost.topLeft = {
    {0, 124, 254, 146, 182, 254, 254, 170},
    {0, 124, 254, 146, 182, 254, 254, 84}
}

ghost.botomLeft = {
    {0, 124, 254, 182, 146, 254, 254, 170},
    {0, 124, 254, 182, 146, 254, 254, 84}
}

ghost.botomRight = {
    {0, 124, 254, 218, 146, 254, 254, 170},
    {0, 124, 254, 218, 146, 254, 254, 84}
}

ghost.current = ghost.topLeft

-- Pacman
pacman = {}
pacman.time = 1
pacman.x = 1
pacman.y = 1
--------------------
---  Animations  ---
--------------------
-- Moving
pacman.right = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {60, 126, 248, 240, 224, 240, 120, 60}
}

pacman.left = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {60, 30, 15, 7, 15, 31, 126, 60}
}

pacman.up = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {0, 64, 193, 227, 247, 255, 126, 60}
}

pacman.down = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {60, 126, 255, 239, 199, 131, 2, 0}
}

-- Death
pacman.death = {
    {0, 66, 195, 231, 255, 255, 126, 60},
    {0, 0, 129, 231, 255, 255, 126, 60},
    {0, 0, 129, 231, 255, 126, 24, 0},
    {0, 0, 0, 255, 255, 255, 24, 0},
    {0, 0, 0, 60, 255, 219, 0, 0},
    {0, 0, 0, 24, 60, 126, 255, 102},
    {0, 0, 0, 24, 24, 60, 126, 36},
    {0, 0, 0, 24, 24, 60, 60, 0},
    {0, 0, 0, 0, 24, 24, 24, 24},
    {66, 36, 129, 66, 66, 129, 36, 66}
}

pacman.current = pacman.right

function drawMap()
    local x,
        y = 0, camera.y
    local char
    for l = 1, map.height do
        x = camera.x
        for c = 1, map.width do
            char = string.sub(map.currentGrid[l], c, c)
            if char ~= "." then
                vthumb.Sprite(x, y, {0, 42, 64, 2, 64, 2, 84, 0})
            end
            x = x + 8
        end
        y = y + 8
    end
end

function loadLevel(pLevel)
    map.currentGrid = map.grid[pLevel]
    local char
    for l = 1, map.height do
        for c = 1, map.width do
            char = string.sub(map.currentGrid[l], c, c)
            if char == "." then
                addDots((c - 1) * 8, (l - 1) * 8, dots, "casual")
            end
        end
    end
end

function initGame(pLevel)
    loadLevel(pLevel)
end

initGame(1)

function v()
    --- Updates ---
    -- Pacman animation
    pacman.time = pacman.time + 1 / 4
    if pacman.time >= #pacman.current + 1 then
        pacman.time = 1
    end
    -- Pacaman moves
    local camc = math.floor((pacman.x + camera.x) / 8) + 1
    local caml = math.floor((pacman.y + camera.y) / 8) + 1
    local c = math.floor(pacman.x / 8) + 1
    local l = math.floor(pacman.y / 8) + 1

    if vthumb.buttonR.pressed == true and pacman.x < (map.width - 1) * 8 then
        pacman.x = pacman.x + 1
        pacman.current = pacman.right
        -- Camera
        if camc > 5 and string.sub(map.currentGrid[l], c + 4, c + 4) ~= "" then
            camera.x = camera.x - 1
        end
    elseif vthumb.buttonL.pressed == true and pacman.x > 0 then
        -- Camera
        if camc < 3 then
            camera.x = camera.x + 1
            if c <= 2 then
                camera.x = 0
            end
        end
        pacman.x = pacman.x - 1
        pacman.current = pacman.left
    elseif vthumb.buttonU.pressed == true and pacman.y > 0 then
        -- Camera
        if caml < 3 and map.currentGrid[l - 2] ~= nil then
            camera.y = camera.y + 1
        end
        pacman.y = pacman.y - 1
        pacman.current = pacman.up
    elseif vthumb.buttonD.pressed == true and pacman.y < (map.height - 1) * 8 then
        -- Camera
        if caml > 2 and map.currentGrid[l + 3] ~= nil then
            camera.y = camera.y - 1
        end
        pacman.y = pacman.y + 1
        pacman.current = pacman.down
    end

    ----------------
    --- Drawings ---
    ----------------
    drawMap()
    vthumb.Sprite(camera.x + pacman.x, camera.y + pacman.y, pacman.current[math.floor(pacman.time)])
    for i = 1, #listElements do
        local el = listElements[i]
        vthumb.Sprite(camera.x + el.x, camera.y + el.y, el.sprite)
    end
end
