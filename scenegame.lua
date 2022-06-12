function updateGame()
    if pacman.state ~= PACMAN_STATE_DEAD then
        -- Pacaman moves
        local camc = math.floor((pacman.x + camera.x) / 8) + 1
        local caml = math.floor((pacman.y + camera.y) / 8) + 1
        local c = math.floor(pacman.x / 8) + 1
        local l = math.floor(pacman.y / 8) + 1
        local oldX,
            oldY = pacman.x, pacman.y
        local oldCamX,
            oldCamY = camera.x, camera.y

        if vthumb.buttonR.pressed then
            pacman.nextDir = "r"
        elseif vthumb.buttonL.pressed then
            pacman.nextDir = "l"
        elseif vthumb.buttonU.pressed then
            pacman.nextDir = "u"
        elseif vthumb.buttonD.pressed then
            pacman.nextDir = "d"
        end
        if pacman.x % 8 == 0 and pacman.y % 8 == 0 then
            if pacman.nextDir == "l" then
                pacman.columnTo = pacman.column - 1
                pacman.current = pacman.left
                pacman.moving = true
                pacman.start = true
            elseif pacman.nextDir == "r" then
                pacman.columnTo = pacman.column + 1
                pacman.current = pacman.right
                pacman.moving = true
                pacman.start = true
            elseif pacman.nextDir == "u" then
                pacman.lineTo = pacman.lineTo - 1
                pacman.current = pacman.up
                pacman.moving = true
                pacman.start = true
            elseif pacman.nextDir == "d" then
                pacman.lineTo = pacman.line + 1
                pacman.current = pacman.down
                pacman.moving = true
                pacman.start = true
            end
            if not canWalk(pacman.lineTo, pacman.columnTo) then
                pacman.columnTo = pacman.column
                pacman.lineTo = pacman.line
                pacman.moving = false
                reArange(pacman)
            end
        end

        if not pacman.moving and pacman.start then
            if pacman.current == pacman.right then -- Right
                if canWalk(pacman.line, pacman.column + 1) then
                    pacman.columnTo = pacman.column + 1
                    pacman.moving = true
                end
            elseif pacman.current == pacman.left then -- Left
                if canWalk(pacman.line, pacman.column - 1) then
                    pacman.columnTo = pacman.column - 1
                    pacman.moving = true
                end
            elseif pacman.current == pacman.down then -- Down
                if canWalk(pacman.line + 1, pacman.column) then
                    pacman.lineTo = pacman.line + 1
                    pacman.moving = true
                end
            elseif pacman.current == pacman.up then -- Up
                if canWalk(pacman.line - 1, pacman.column) then
                    pacman.lineTo = pacman.line - 1
                    pacman.moving = true
                end
            end
        end

        if pacman.moving then
            if pacman.columnTo > pacman.column then -- To the right
                pacman.x = pacman.x + 1
                if (pacman.x / 8) + 1 >= pacman.columnTo then
                    pacman.moving = false
                    pacman.column = pacman.columnTo
                end
                -- Camera
                if camc > 5 and string.sub(map.grid[l], c + 4, c + 4) ~= "" then
                    camera.x = camera.x - 1
                end
            elseif pacman.columnTo < pacman.column then -- To the left
                pacman.x = pacman.x - 1
                if (pacman.x / 8) + 1 <= pacman.columnTo then
                    pacman.moving = false
                    pacman.column = pacman.columnTo
                end
                -- Camera
                if camc < 3 then
                    camera.x = camera.x + 1
                    if c <= 2 then
                        camera.x = 0
                    end
                end
            elseif pacman.lineTo < pacman.line then -- To up
                pacman.y = pacman.y - 1
                if (pacman.y / 8) + 1 <= pacman.lineTo then
                    pacman.line = pacman.lineTo
                    pacman.moving = false
                end
                -- Camera
                if caml < 3 and map.grid[l - 2] ~= nil then
                    camera.y = camera.y + 1
                end
            elseif pacman.lineTo > pacman.line then -- To bottom
                pacman.y = pacman.y + 1
                if (pacman.y / 8) + 1 >= pacman.lineTo then
                    pacman.line = pacman.lineTo
                    pacman.moving = false
                end
                -- Camera
                if caml > 2 and map.grid[l + 3] ~= nil then
                    camera.y = camera.y - 1
                end
            end
            if pacman.column <= 0 then
                camera.x = -88
                pacman.column = map.width
                pacman.columnTo = map.width
                reArange(pacman)
            elseif pacman.column > map.width then
                pacman.column = 1
                pacman.columnTo = 1
                camera.x = 1
                reArange(pacman)
            end
        end
    else
        pacman.deathTimer = pacman.deathTimer + 1 / love.timer.getFPS()
        if pacman.deathTimer >= 3 then
            pacman.lives = pacman.lives - 1
            if pacman.lives < 1 then
                gameOver = true
                if currentScore > hiScore then
                    hiScore = currentScore
                    saveHightScore(hiScore)
                end
            else
                for l = #listElements, 1, -1 do
                    if listElements[l].type == GHOST then
                        table.remove(listElements, l)
                    end
                end
                loadLevel(true)
            end
        end
    end
end

function drawGame()
    drawMap()
    drawElements(camera.x, camera.y)
end
