-- Map
map = {}
map.height = 21
map.width = 21
map.grid = {}
map.grid = {
    " wwwwwwwwwwwwwwwwwww ",
    " w........w........w ",
    " wdww.www.w.www.wwdw ",
    " w.................w ",
    " w.ww.w.wwwww.w.ww.w ",
    " w....w...w...w....w ",
    " wwww.www w www.wwww ",
    "    w.w   b   w.w    ",
    "wwwww.w ww-ww w.wwwww",
    "        wipcw        ",
    "wwwww.w wwwww w.wwwww",
    "    w.w       w.w    ",
    " wwww.w wwwww w.wwww ",
    " w........w........w ",
    " w.ww.www.w.www.ww.w ",
    " wd.w.....@.....w.dw ",
    " ww.w.w.wwwww.w.w.ww ",
    " w....w...w...w....w ",
    " w.wwwwww.w.wwwwww.w ",
    " w.................w ",
    " wwwwwwwwwwwwwwwwwww "
}

-- Map functions
function getDirections(pLine, pCol, pDir, pState)
    local directions = {}
    local grid = map.grid

    if grid[pLine - 1] ~= nil and string.sub(grid[pLine - 1], pCol, pCol) ~= WALL and pDir ~= "d" then
        table.insert(directions, "u")
    end
    if grid[pLine + 1] ~= nil and string.sub(grid[pLine + 1], pCol, pCol) ~= WALL and pDir ~= "u" then
        if string.sub(grid[pLine + 1], pCol, pCol) == ROPE then
            if pState == GHOST_STATE_EATEN then
                table.insert(directions, "d")
            end
        else
            table.insert(directions, "d")
        end
    end
    if grid[pLine] ~= nil and string.sub(grid[pLine], pCol + 1, pCol + 1) ~= WALL and pDir ~= "l" then
        table.insert(directions, "r")
    end
    if grid[pLine] ~= nil and string.sub(grid[pLine], pCol - 1, pCol - 1) ~= WALL and pDir ~= "r" then
        table.insert(directions, "l")
    end
    return directions
end

function nextDirection(pLine, pCol, pTLine, pTCol, pDir)
    local shortest = 999
    local dir = ""
    local dist = 0
    for i = 1, #pDir do
        if pDir[i] == "d" then
            dist = math.dist(pLine + 1, pCol, pTLine, pTCol)
        elseif pDir[i] == "u" then
            dist = math.dist(pLine - 1, pCol, pTLine, pTCol)
        elseif pDir[i] == "r" then
            dist = math.dist(pLine, pCol + 1, pTLine, pTCol)
        elseif pDir[i] == "l" then
            dist = math.dist(pLine, pCol - 1, pTLine, pTCol)
        end
        if dist < shortest then
            shortest = dist
            dir = pDir[i]
        end
    end
    return dir
end

function reArange(el)
    el.x = (el.column - 1) * 8
    el.y = (el.line - 1) * 8
end

function canWalk(pL, pC)
    return string.sub(map.grid[pL], pC, pC) ~= WALL and string.sub(map.grid[pL], pC, pC) ~= ROPE
end

function canDraw(pTile)
    return pTile == WALL or pTile == ROPE
end

function drawMap()
    local x,
        y = 0, camera.y
    local char
    for l = 1, map.height do
        x = camera.x
        for c = 1, map.width do
            char = string.sub(map.grid[l], c, c)
            if canDraw(char) then
                vthumb.Sprite(x, y, sprites[char])
            end
            x = x + 8
        end
        y = y + 8
    end
end

function loadLevel(pResume)
    local char
    for l = 1, map.height do
        for c = 1, map.width do
            char = string.sub(map.grid[l], c, c)
            if (char == DOT_LEVEL_SMALL or char == DOT_LEVEL_BIG) and not pResume then
                addDots((c - 1) * 8, (l - 1) * 8, sprites[char], char)
            elseif
                char == GHOST_LEVEL_BLINKY or char == GHOST_LEVEL_CLYDE or char == GHOST_LEVEL_INKY or
                    char == GHOST_LEVEL_PINKY
             then
                addGhost((c - 1) * 8 + 1, (l - 1) * 8, ghost.botomLeft, char)
            elseif char == PACMAN then
                pacman.line = l
                pacman.column = c
                pacman.columnTo = c
                pacman.lineTo = l
                pacman.deathTimer = 0
                pacman.state = PACMAN_STATE_NORMAL

                camera.x = -47
                camera.y = -102
                pacman.start = false
                reArange(pacman)
            end
            if char == ROPE then
                ghostHome.line = l - 1
                ghostHome.column = c
            end
        end
    end
end
