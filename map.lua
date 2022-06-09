-- Map
map = {}
map.height = 11
map.width = 20
map.grid = {}
map.grid[1] = {
    "wwwwwwwwwwwwwwwwwwww",
    "wd................dw",
    "w.ww............ww.w",
    "w.........b........w",
    "e.......ww-ww......e",
    "w...ww..wipcw..ww..w",
    "e.......wwwww......e",
    "w........@.........w",
    "w.ww....wwww....ww.w",
    "wd................dw",
    "wwwwwwwwwwwwwwwwwwww"
}

map.grid[2] = {
    "wwwwwwwwwwwwwwwwwwww",
    "w....w........w....w",
    "w....w........w....w",
    "e...ww....b...ww...e",
    "ww......ww-ww.....ww",
    " w......wipcw.....w ",
    "ww......wwwww.....ww",
    "e..................e",
    "w.......wwww.......w",
    "w..................w",
    "wwwwwwwwwwwwwwwwwwww"
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

-- Map functions
function getDirections(pLine, pCol, pDir, pState)
    local directions = {}
    local grid = map.grid[currentLevel]
    if string.sub(grid[pLine - 1], pCol, pCol) ~= WALL and pDir ~= "d" then
        table.insert(directions, "u")
    end
    if string.sub(grid[pLine + 1], pCol, pCol) ~= WALL and pDir ~= "u" then
        if string.sub(grid[pLine + 1], pCol, pCol) == ROPE then
            if pState == GHOST_STATE_EATEN then
                table.insert(directions, "d")
            end
        else
            table.insert(directions, "d")
        end
    end
    if string.sub(grid[pLine], pCol + 1, pCol + 1) ~= WALL and pDir ~= "l" then
        table.insert(directions, "r")
    end
    if string.sub(grid[pLine], pCol - 1, pCol - 1) ~= WALL and pDir ~= "r" then
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
    return string.sub(map.grid[1][pL], pC, pC) ~= WALL and string.sub(map.grid[1][pL], pC, pC) ~= ROPE
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
            char = string.sub(map.currentGrid[l], c, c)
            if canDraw(char) then
                vthumb.Sprite(x, y, sprites[char])
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
            if char == DOT_LEVEL_SMALL or char == DOT_LEVEL_BIG then
                addDots((c - 1) * 8, (l - 1) * 8, sprites[char], char)
            elseif
                char == GHOST_LEVEL_BLINKY or char == GHOST_LEVEL_CLYDE or char == GHOST_LEVEL_INKY or
                    char == GHOST_LEVEL_PINKY
             then
                addGhost((c - 1) * 8 + 1, (l - 1) * 8, ghost.botomLeft, char)
            elseif char == PACMAN then
                pacman.line = l
                pacman.column = c
                reArange(pacman)
            end
            if char == ROPE then
                ghostHome.line = l - 1
                ghostHome.column = c
            end
        end
    end
end
