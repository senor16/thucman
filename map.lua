-- Map
map = {}
map.height = 9
map.width = 14
map.grid = {}
map.grid[1] = {
    "wwwwwwwwwwwwww",
    "...w......w...",
    "...w......w...",
    "..............",
    ".....w--w......",
    ".....w..w.....",
    ".....wwww.....",
    "..............",
    "wwwwwwwwwwwwww"
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

function drawMap()
    local x,
        y = 0, camera.y
    local char
    for l = 1, map.height do
        x = camera.x
        for c = 1, map.width do
            char = string.sub(map.currentGrid[l], c, c)
            if char ~= "." then
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
            if char == "." then
                addDots((c - 1) * 8, (l - 1) * 8, dots, "casual")
            end
        end
    end
end
