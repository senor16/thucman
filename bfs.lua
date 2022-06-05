----------------------------------------
------BFS PATHFINDING ALGORITHM---------
----------------------------------------
function bfs(a, b)
    local start = {a.x, a.y}
    local goal = {b.x, b.y}

    local open = {start}
    local closed = {}
    local path = {}
    local mode = "search"

    --a function to check if an item is
    --already in a given list
    function is_in(item, list)
        for i, ele in ipairs(list) do
            if ele[1] == item[1] and ele[2] == item[2] then
                return true
            end
        end
    end

    --a function to get the four adjacents
    --to "cell" and log the valid ones
    function get_adjacents(cell)
        local up = {cell[1], cell[2] - 1}
        local down = {cell[1], cell[2] + 1}
        local left = {cell[1] - 1, cell[2]}
        local right = {cell[1] + 1, cell[2]}
        local adjacents = {up, down, left, right}

        --test each adjacent for validity
        for i, v in ipairs(adjacents) do
            if not is_in(v, closed) and not is_in(v, open) and mget(v[1], v[2]) < WALL then
                --build the object for logging
                local z = {v[1], v[2], cell}
                --log it into open
                table.insert(open, #open + 1, z)
            end
        end
    end

    ::search::
    --search as long as there's places to search
    if #open > 0 then
        --get the first cell out of open
        current = open[1]
        table.remove(open, 1)

        --check if it's the goal
        if current[1] == goal[1] and current[2] == goal[2] then
            path_end = current
            mode = "path"
        end

        --log its valid neighbors into open
        get_adjacents(current, open, closed)
        --log current into closed
        table.insert(closed, #closed + 1, current)
    end

    if mode == "search" then
        goto search
    end

    --pathbuilding
    ::path_find::
    table.insert(path, #path + 1, path_end)
    if path_end ~= start then
        path_end = path_end[3]
        goto path_find
    end

    return path
end
----------------------------------------
--------END OF BFS ALGORITHM------------
----------------------------------------
