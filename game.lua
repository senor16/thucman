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
-- Load the music lib
ScoreReader = require "lib/ScoreReader"
deltaTime = 0

require("constants")
require("map")
require("scenemenu")
require("functions")

-- Game variables
scene = SCENE_MENU
currentLevel = 1
gameOver = false
gameWon = false
hiScore = love.filesystem.read("hiScore.txt")

function saveHightScore(pScore)
    if pScore ~= nil and pScore > 0 then
        print(love.filesystem.write("hiScore.txt", tostring(pScore)))
    end
end
if hiScore == nil or hiScore == "" then
    hiScore = 1800
    saveHightScore(1800)
else
    hiScore = tonumber(hiScore)
end

currentScore = 0

-- Lists
listElements = {}
listDots = {}
listGhosts = {}
listBonus = {}
listPlayers = {}

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

-- Pacman
pacman = {}
pacman.time = 1
require("sprites")
pacman.current = pacman.right

-- Functions related to music and sfx
function addPlayer(pWave, pNotes, pBpm)
    local pl = ScoreReader:new(pWave, pNotes, pBpm)
    table.insert(listPlayers, pl)
    return pl
end
function updatePlayers()
    for p = 1, #listPlayers do
        local pl = listPlayers[p]
        pl:update(deltaTime)
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
        if scene == SCENE_MENU then
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
    pacman.x = 9
    pacman.y = 9
    pacman.state = PACMAN_STATE_NORMAL
end

function updateGame()
    -- Pacaman moves
    local camc = math.floor((pacman.x + camera.x) / 8) + 1
    local caml = math.floor((pacman.y + camera.y) / 8) + 1
    local c = math.floor(pacman.x / 8) + 1
    local l = math.floor(pacman.y / 8) + 1
    local oldX,
        oldY = pacman.x, pacman.y
    local oldCamX,
        oldCamY = camera.x, camera.y
    if vthumb.buttonR.pressed == true and canWalk(pacman.x + 8, pacman.y + 2) and pacman.x < (map.width - 1) * 8 then
        pacman.x = pacman.x + 1
        pacman.current = pacman.right
        -- Camera
        if camc > 5 and string.sub(map.currentGrid[l], c + 4, c + 4) ~= "" then
            camera.x = camera.x - 1
        end
    elseif vthumb.buttonL.pressed == true and canWalk(pacman.x - 2, pacman.y + 2) and pacman.x > 0 then
        -- Camera
        if camc < 3 then
            camera.x = camera.x + 1
            if c <= 2 then
                camera.x = 0
            end
        end
        pacman.x = pacman.x - 1
        pacman.current = pacman.left
    elseif vthumb.buttonU.pressed == true and canWalk(pacman.x + 2, pacman.y - 2) and pacman.y > 0 then
        -- Camera
        if caml < 3 and map.currentGrid[l - 2] ~= nil then
            camera.y = camera.y + 1
        end
        pacman.y = pacman.y - 1
        pacman.current = pacman.up
    elseif vthumb.buttonD.pressed == true and canWalk(pacman.x + 2, pacman.y + 8) and pacman.y < (map.height - 1) * 8 then
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
    -- drawString(1, 1, "HS " .. hiScore .. " " .. currentScore)
    drawElements(camera.x, camera.y)
end

-- Init everything
function init()
    if scene == SCENE_MENU then
        initMenu()
    elseif scene == SCENE_GAME then
        initGame(currentLevel)
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
    updatePlayers()

    -- Drawings
    if scene == SCENE_MENU then
        drawMenu()
    elseif scene == SCENE_GAME then
        drawGame()
    end
end
