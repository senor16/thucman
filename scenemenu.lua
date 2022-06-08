-- Menu variables
menu = {}
menu.timer = 0
menu.pacman = {}
menu.ghosts = {}
menu.vx = -1

-- Functions specific to the Menu scene
function initMenu()
    menu.timer = 0
    menu.pacman = {}
    menu.ghosts = {}
    menu.vx = -1
    local x,
        y = 80, 32
    menu.ghosts[1] = addGhost(x, y, ghost.botomLeft[1], GHOST_LEVEL_BLINKY)
    menu.ghosts[2] = addGhost(x + 10, y, ghost.botomLeft[1], GHOST_LEVEL_CLYDE)
    menu.ghosts[3] = addGhost(x + 20, y, ghost.botomLeft[1], GHOST_LEVEL_INKY)
    menu.ghosts[4] = addGhost(x + 30, y, ghost.botomLeft[1], GHOST_LEVEL_PINKY)
    menu.bigDot = addDots(1, y, sprites[DOT_LEVEL_BIG], DOT_LEVEL_BIG)
    pacman.x = x - 12
    pacman.y = y
    pacman.current = pacman.left
end

function updateMenu()
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

    if vthumb.buttonA.pressed and vthumb.buttonB.pressed then
        scene = SCENE_GAME
        init()
    end
end

function drawMenu()
    local y = 1
    drawText(4, y, "THUC-MAN")
    drawString(10, y + 12, "HI-SCORE " .. hiScore)
    drawString(20, y + 22, "PRESS A+B")
    drawElements(0, 0)
end
