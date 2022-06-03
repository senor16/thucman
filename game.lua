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
-- Game constants
local DOT = "."
local DOT_LEVEL_BIG = "D"
local DOT_LEVEL_SMALL = "d"
local GHOST = "GHOST"
local GHOST_LEVEL_INKY = "i"
local GHOST_LEVEL_PINKY = "p"
local GHOST_LEVEL_BLINKY = "b"
local GHOST_LEVEL_CLYDE = "c"
local GHOST_STATE_FEAR = "fear"
local BONUS = "BONUS"
local PACMAN = "PACMAN"
local PACMAN_STATE_KILL = "kill"
local SCENE_MENU = "menu"
local SCENE_GAME = "game"
local LETTERS = {
    U = {99, 99, 99, 99, 99, 99, 127, 62},
    T = {63, 63, 12, 12, 12, 12, 12, 12},
    C = {62, 127, 97, 96, 96, 97, 127, 62},
    M = {99, 119, 127, 107, 99, 99, 99, 99},
    A = {62, 127, 127, 99, 99, 127, 99, 99},
    N = {99, 115, 115, 107, 107, 103, 103, 99},
    H = {99, 99, 99, 127, 127, 99, 99, 99},
    B = {127, 99, 100, 120, 100, 99, 127, 127},
    -- Small caps
    a = {0, 0, 0, 56, 68, 124, 68, 68},
    b = {0, 0, 0, 112, 72, 112, 72, 112}
}
LETTERS["-"] = {0, 0, 0, 60, 60, 0, 0, 0}
LETTERS[">"] = {0, 0, 0, 16, 8, 252, 8, 16}
LETTERS["+"] = {0, 0, 0, 0, 16, 56, 16, 0}

-- Game variables
local scene = SCENE_MENU
local level = 1
local gameOver = false
local gameWon = false

-- Lists
local listElements = {}
local listDots = {}
local listGhosts = {}
local listBonus = {}

-- Menu variables
local menu = {}
menu.timer = 0
menu.pacman = {}
menu.ghosts = {}
menu.vx = -1

-- Sprites
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

function addElement(pX, pY, pSprite, pType)
    local el = {x = pX, y = pY, sprite = pSprite, anim = nil, time = 1, del = false, type = pType}
    table.insert(listElements, el)
    return el
end

function addGhost(pX, pY, pSprite, pLevel)
    local gh = addElement(pX, pY, pSprite, GHOST)
    gh.level = pLevel
    gh.anim = ghost.botomLeft
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

-- Pacman
local pacman = {}
pacman.time = 1
pacman.x = 1
pacman.y = 1
pacman.sp = 0
-- Pacman animations
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

-- Generic functions
function isColliding(x1, y1, x2, y2)
    return x1 < x2 + 8 and x2 < x1 + 8 and y1 < y2 + 8 and y2 < y1 + 8
end

function drawText(pX, pY, pText)
    local x = pX
    for i = 1, #pText do
        if LETTERS[string.sub(pText, i, i)] ~= nil then
            vthumb.Sprite(x, pY, LETTERS[string.sub(pText, i, i)])
            x = x + 8
        end
    end
end

-- Map functions
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

-- Functions working on characters
function updateAnimations()
    -- Pacman animation
    pacman.time = pacman.time + 1 / 4
    if pacman.time >= #pacman.current + 1 then
        pacman.time = 1
    end
    -- Other animations
    for i = 1, #listElements do
        local el = listElements[i]
        if el.anim ~= nil then
            el.time = el.time + 1 / 4
            if el.time >= #el.anim + 1 then
                el.time = 1
            end
            el.sprite = el.anim[math.floor(el.time)]
        end
    end
end

function updateElements()
    for i = #listElements, 1, -1 do
        local el = listElements[i]
        if el.type == DOT then
            if isColliding(el.x - 6, el.y, pacman.x, pacman.y) then
                if scene == SCENE_MENU then
                    menu.vx = 1
                    pacman.current = pacman.right
                    for l = 1, #listGhosts do
                        local gh = listGhosts[l]
                        gh.anim = ghost.botomRight
                    end
                end
                if el.level == DOT_LEVEL_BIG then
                    pacman.state = PACMAN_STATE_KILL
                end

                table.remove(listElements, i)
                el.del = true
            end
        elseif el.type == GHOST then
            if isColliding(el.x + 6, el.y, pacman.x, pacman.y) then
                if pacman.state == PACMAN_STATE_KILL then
                    table.remove(listElements, i)
                    el.del = true
                end
            end
        end
    end
end

function drawElements(pCamx, pCamy)
    for i = 1, #listElements do
        local el = listElements[i]
        vthumb.Sprite(pCamx + el.x, pCamy + el.y, el.sprite)
    end
    vthumb.Sprite(pCamx + pacman.x, pCamy + pacman.y, pacman.current[math.floor(pacman.time)])
end

-- Functions specific the Game scene
function initGame(pLevel)
    listBonus = {}
    listDots = {}
    listElements = {}
    listGhosts = {}
    loadLevel(pLevel)
end

function updateGame()
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
end

function drawGame()
    drawMap()
    drawElements(camera.x, camera.y)
end

-- Functions specific to the Menu scene
function initMenu()
    menu.timer = 0
    menu.pacman = {}
    menu.ghosts = {}
    menu.vx = -1
    local x,
        y = 80, 30
    menu.ghosts[1] = addGhost(x, y, ghost.botomLeft[1], GHOST_LEVEL_BLINKY)
    menu.ghosts[2] = addGhost(x + 10, y, ghost.botomLeft[1], GHOST_LEVEL_CLYDE)
    menu.ghosts[3] = addGhost(x + 20, y, ghost.botomLeft[1], GHOST_LEVEL_INKY)
    menu.ghosts[4] = addGhost(x + 30, y, ghost.botomLeft[1], GHOST_LEVEL_PINKY)
    menu.bigDot = addDots(1, y, bigdot, DOT_LEVEL_BIG)
    pacman.x = x - 12
    pacman.y = y
    pacman.current = pacman.left
end

function updateMenu()
    if vthumb.buttonA.pressed and vthumb.buttonB.pressed then
        scene = SCENE_GAME
        init()
    end

    if menu.vx > 0 then
        pacman.x = pacman.x + 1
    end
    pacman.x = pacman.x + menu.vx
    for i = #listElements, 1, -1 do
        local el = listElements[i]
        if el.type == GHOST then
            el.x = el.x + menu.vx
        end
    end
    if #listElements <= 0 and pacman.x >= 172 then
        initMenu()
    end
end

function drawMenu()
    drawText(4, 2, "THUC-MAN")
    drawText(20, 15, ">a+b")
    drawElements(0, 0)
end

-- Init everything
function init()
    if scene == SCENE_MENU then
        initMenu()
    elseif scene == SCENE_GAME then
        initGame(1)
    end
end

init()
function v()
    -- Updates
    if scene == SCENE_MENU then
        updateMenu()
    elseif scene == SCENE_GAME then
        updateGame()
    end
    updateAnimations()
    updateElements()

    -- Drawings
    if scene == SCENE_MENU then
        drawMenu()
    elseif scene == SCENE_GAME then
        drawGame()
    end
end
