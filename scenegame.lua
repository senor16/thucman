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
