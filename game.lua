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

-- Musics
eat = love.audio.newSource("sfx/eat.wav", "static")
dead = love.audio.newSource("sfx/dead.wav", "static")

-- Game variables
scene = SCENE_MENU
currentLevel = 1
gameOver = false
gameWon = false
hiScore = love.filesystem.read("hiScore.txt")
ghostHome = {line = 0, column = 0}
blinkyId = 0
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
    local el = {x = pX, y = pY, sprite = pSprite, time = 1, anim = nil, del = false, type = pType}
    table.insert(listElements, el)
    return el
end

function addGhost(pX, pY, pSprite, pLevel)
    local gh = addElement(pX, pY, pSprite, GHOST)
    gh.level = pLevel
    gh.state = GHOST_STATE_SCATTER
    gh.dir = "l"
    gh.trans = 1
    gh.stateTimer = 0
    gh.blueTimer = 0
    gh.moving = false
    gh.line = math.ceil(pY / 8)
    gh.column = math.ceil(pX / 8)
    gh.lineTo = gh.line
    gh.columnTo = gh.column
    gh.anim = ghost.botomLeft
    table.insert(listGhosts, gh)
    if pLevel == GHOST_LEVEL_BLINKY then
        blinkyId = #listGhosts
    end
    return gh
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
pacman.nextDir = ""
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

function updateGhosts(pGhost)
    local gh = pGhost
    if gh.state == GHOST_STATE_FRIGHTENED then
        gh.blueTimer = gh.blueTimer + 1 / love.timer.getFPS()
    end
    if gh.state == GHOST_STATE_SCATTER or gh.state == GHOST_FORCE_CHASE then
        gh.stateTimer = gh.stateTimer + 1 / love.timer.getFPS()
    end

    if gh.moving then
        if gh.columnTo > gh.column then -- To the right
            gh.x = gh.x + 1
            if (gh.x / 8) + 1 >= gh.columnTo then
                gh.moving = false
                gh.column = gh.columnTo
            end
        elseif gh.columnTo < gh.column then -- To the left
            gh.x = gh.x - 1
            if (gh.x / 8) + 1 <= gh.columnTo then
                gh.moving = false
                gh.column = gh.columnTo
            end
        elseif gh.lineTo < gh.line then -- To up
            gh.y = gh.y - 1
            if (gh.y / 8) + 1 <= gh.lineTo then
                gh.line = gh.lineTo
                gh.moving = false
            end
        elseif gh.lineTo > gh.line then -- To bottom
            gh.y = gh.y + 1
            if (gh.y / 8) + 1 >= gh.lineTo then
                gh.line = gh.lineTo
                gh.moving = false
            end
        end
    else
        local dir = getDirections(gh.line, gh.column, gh.dir, gh.level)
        local nDir = ""
        -- Chase state
        if gh.state == GHOST_STATE_CHASE then
            if gh.trans < #GHOST_TRANSITIONS then
                local chaseTime = GHOST_TRANSITIONS[currentLevel][gh.trans][2]
                if gh.stateTimer >= chaseTime and chaseTime > 0 then
                    gh.dir = goBack(gh.dir)
                    gh.state = GHOST_STATE_SCATTER
                    if gh.level == GHOST_LEVEL_BLINKY and #listDots <= GHOST_FORCE_CHASE[currentLevel] then
                        gh.state = GHOST_STATE_CHASE
                    end
                    gh.trans = gh.trans + 1
                    if gh.trans > #GHOST_TRANSITIONS[currentLevel] then
                        gh.trans = #GHOST_TRANSITIONS[currentLevel]
                    end
                    gh.stateTimer = 0
                end
            end
            if gh.level == GHOST_LEVEL_BLINKY then -- Blinky
                nDir = nextDirection(gh.line, gh.column, pacman.line, pacman.column, dir)
            elseif gh.level == GHOST_LEVEL_PINKY then -- Pinky
                if pacman.current == pacman.left then
                    nDir = nextDirection(gh.line, gh.column, pacman.line, pacman.column - 4, dir)
                elseif pacman.current == pacman.right then
                    nDir = nextDirection(gh.line, gh.column, pacman.line, pacman.column + 4, dir)
                elseif pacman.current == pacman.up then
                    nDir = nextDirection(gh.line, gh.column, pacman.line - 4, pacman.column - 4, dir)
                elseif pacman.current == pacman.down then
                    nDir = nextDirection(gh.line, gh.column, pacman.line + 4, pacman.column, dir)
                end
            elseif gh.level == GHOST_LEVEL_CLYDE then -- Clyde
                if math.dist(gh.column, gh.line, pacman.column, pacman.line) >= 8 then
                    nDir = nextDirection(gh.line, gh.column, pacman.line, pacman.column, dir)
                else
                    gh.state = GHOST_STATE_SCATTER
                    gh.dir = goBack(gh.dir)
                end
            elseif gh.level == GHOST_LEVEL_INKY then -- Inky
                local pL,
                    pC = 0, 0
                if pacman.current == pacman.left then
                    pL,
                        pC = pacman.line, pacman.column - 2
                elseif pacman.current == pacman.right then
                    pL,
                        pC = pacman.line, pacman.column + 2
                elseif pacman.current == pacman.up then
                    pL,
                        pC = pacman.line - 2, pacman.column - 2
                elseif pacman.current == pacman.down then
                    pL,
                        pC = pacman.line + 2, pacman.column
                end
                local tC,
                    tL = 0, 0
                local bL,
                    bC = listGhosts[blinkyId].line, listGhosts[blinkyId].column

                tL = pL + (pL - bL)
                tC = pC + (pC - bC)
                nDir = nextDirection(gh.line, gh.column, tL, tC, dir)
            end
        end
        -- Scatter state
        if gh.state == GHOST_STATE_SCATTER then
            if gh.trans < #GHOST_TRANSITIONS then
                local time = GHOST_TRANSITIONS[currentLevel][gh.trans][1]
                if gh.stateTimer >= time then
                    --gh.dir = goBack(gh.dir)
                    -- gh.state = GHOST_STATE_CHASE
                    gh.stateTimer = 0
                end
            end
            if gh.level == GHOST_LEVEL_BLINKY then -- Blinky
                nDir = nextDirection(gh.line, gh.column, -4, map.width, dir)
            elseif gh.level == GHOST_LEVEL_PINKY then -- Pinky
                nDir = nextDirection(gh.line, gh.column, -4, 0, dir)
            elseif gh.level == GHOST_LEVEL_INKY then -- Inky
                nDir = nextDirection(gh.line, gh.column, map.height + 4, map.width, dir)
            elseif gh.level == GHOST_LEVEL_CLYDE then -- Clyde
                nDir = nextDirection(gh.line, gh.column, map.height, 0, dir)
            end
        end
        -- Frightened state
        if gh.state == GHOST_STATE_FRIGHTENED then
            nDir = dir[love.math.random(1, #dir)]
            if gh.blueTimer >= GHOST_BLUE_TIME[currentLevel] then
                gh.state = gh.prevState
            end
        end
        -- Eaten state
        if gh.state == GHOST_STATE_EATEN then
            nDir = nextDirection(gh.line, gh.column, ghostHome.line + 2, ghostHome.column, dir)
        end
        if nDir == "l" then
            gh.columnTo = gh.column - 1
        elseif nDir == "r" then
            gh.columnTo = gh.column + 1
        elseif nDir == "u" then
            gh.lineTo = gh.line - 1
        elseif nDir == "d" then
            gh.lineTo = gh.line + 1
        end
        gh.dir = nDir
        if gh.dir ~= "" then
            gh.moving = true
        end
    end

    if isColliding(gh.x, gh.y, pacman.x, pacman.y) then
        if pacman.state == PACMAN_STATE_KILL and gh.state == GHOST_STATE_FRIGHTENED then
            gh.state = GHOST_STATE_EATEN
        else
            playSound(dead, false)
            pacman.current = pacman.dead
            pacman.time = 1
            pacman.state = PACMAN_STATE_DEAD
        end
        if gh.column <= 0 then
            gh.column = map.width
            gh.columnTo = map.width
        elseif gh.column > map.width then
            gh.column = 1
            gh.columnTo = 1
        end
    end
end

function updateElements()
    for i = #listElements, 1, -1 do
        local el = listElements[i]
        if scene == SCENE_MENU then
            if el.type == DOT then
                if isColliding(el.x - 6, el.y, pacman.x, pacman.y) then
                    playSound(eat)
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
                        playSound(eat)
                        table.remove(listElements, i)
                        el.del = true
                    end
                end
            end
        elseif scene == SCENE_GAME then
            if el.type == DOT then
                if isColliding(el.x, el.y, pacman.x, pacman.y) then
                    playSound(eat)
                    if el.level == DOT_LEVEL_BIG then
                        pacman.state = PACMAN_STATE_KILL
                        for l = 1, #listGhosts do
                            local gh = listGhosts[l]
                            gh.prevState = gh.state
                            gh.state = GHOST_STATE_FRIGHTENED
                            gh.dir = goBack(gh.dir)
                        end
                    end
                    table.remove(listElements, i)
                    el.del = true
                end
            elseif el.type == GHOST then
                updateGhosts(el)
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
end
function drawElements(pCamx, pCamy)
    for i = 1, #listElements do
        local el = listElements[i]
        if el.sprite ~= nil then
            vthumb.Sprite(pCamx + el.x, pCamy + el.y, el.sprite)
        end
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
    camera.x = -40
    camera.y = -102
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
    end
end
