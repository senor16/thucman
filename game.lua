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
require("constants")
require("map")
require("scenemenu")
require("functions")
require("scenegame")

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
pacman.line = 1
pacman.column = 1
pacman.lineTo = 1
pacman.columnTo = 1
pacman.moving = false
require("sprites")

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
        elseif scene == SCENE_GAME then
            if el.type == DOT then
                if isColliding(el.x, el.y, pacman.x, pacman.y) then
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
                if isColliding(el.x, el.y, pacman.x, pacman.y) then
                    if pacman.state == PACMAN_STATE_KILL then
                        table.remove(listElements, i)
                        el.del = true
                    end
                end
            end
        end
    end

    -- Remove elements deleted elements from the corresponding list
    for i = #listBonus, 1, -1 do
        local el = listBonus[i]
        if el.del then
            table.remove(listBonus, i)
        end
    end
    for i = #listDots, 1, -1 do
        local el = listDots[i]
        if el.del then
            table.remove(listDots, i)
        end
    end
    for i = #listGhosts, 1, -1 do
        local el = listGhosts[i]
        if el.del then
            table.remove(listGhosts, i)
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
    pacman.column = 11
    pacman.columnTo = 11
    pacman.line = 8
    pacman.lineTo = 8
    pacman.x = (pacman.column - 1) * 8
    pacman.y = (pacman.line - 1) * 8
    camera.x = -40
    camera.y = -40
    pacman.state = PACMAN_STATE_NORMAL
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

    -- Drawings
    if scene == SCENE_MENU then
        drawMenu()
    elseif scene == SCENE_GAME then
        drawGame()
        drawPath()
    end
end
