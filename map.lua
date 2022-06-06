-- Map
map = {}
map.height = 11
map.width = 20
map.grid = {}
map.grid[1] = {
    "wwwwwwwwwwwwwwwwwwww",
    "wd...w........w...dw",
    "w....w........w....w",
    "e...ww....b...ww...e",
    "ww......ww-ww.....ww",
    " w..ww..wipcw..ww.w ",
    "ww...w..wwwww..w..ww",
    "e....w.........w...e",
    "w.......wwww.......w",
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

-- Usage Example
-- First, set a collision map
local char
local mapG = {}
map.currentGrid = map.grid[1]
for l = 1, map.height do
    mapG[l] = {}
    for c = 1, map.width do
        char = string.sub(map.currentGrid[l], c, c)
        if char == WALL then
            mapG[l][c] = 1
        else
            mapG[l][c] = 0
        end
    end
end

-- Value for walkable tiles
local walkable = 0

-- Library setup
local Grid = require("lib/jumper.grid") -- The grid class
local Pathfinder = require("lib/jumper.pathfinder") -- The pathfinder class

-- Creates a grid object
local grid = Grid(mapG)
-- Creates a pathfinder object using Jump Point Search
local myFinder = Pathfinder(grid, "BFS", walkable)
myFinder:setMode("ORTHOGONAL")
-- Define start and goal locations coordinates
local startx,
    starty = 5, 8
local endx,
    endy = 2, 4

-- Calculates the path, and its length
local path = myFinder:getPath(startx, starty, endx, endy)

-- Map functions
function reArange(el)
    local c = math.floor(el.x / 8) + 1
    local l = math.floor(el.y / 8) + 1
    el.x = c * 8
    el.y = l * 8
end

function canWalk(pX, pY)
    local c = math.floor(pX / 8) + 1
    local l = math.floor(pY / 8) + 1
    if c > 0 and c <= map.width and l > 0 and l <= map.height then
        return string.sub(map.grid[1][l], c, c) ~= WALL
    end
    return false
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

function drawPath()
    if path then
        for node, count in path:nodes() do
            vthumb.Sprite(
                (node:getX() - 1) * 8 + camera.x,
                (node:getY() - 1) * 8 + camera.y,
                {0, 0, 24, 48, 12, 24, 0, 0}
            )
        end
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
            end
        end
    end
end
