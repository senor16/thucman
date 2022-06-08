-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")
-- Désactive le lissage en cas de scale
love.graphics.setDefaultFilter("nearest")

--[[

██╗   ██╗████████╗██╗  ██╗██╗   ██╗███╗   ███╗██████╗ 
██║   ██║╚══██╔══╝██║  ██║██║   ██║████╗ ████║██╔══██╗
██║   ██║   ██║   ███████║██║   ██║██╔████╔██║██████╔╝
╚██╗ ██╔╝   ██║   ██╔══██║██║   ██║██║╚██╔╝██║██╔══██╗
 ╚████╔╝    ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║██████╔╝
  ╚═══╝     ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═════╝ 
                                         
  Version : 220524-2
  (C) Gamecodeur Mai 2022 - By David Mekersa

]]
local vthumb_engine = require("vthumb")

function love.load()
    vthumb_engine.load()
end

function love.update(dt)
    vthumb_engine.update(dt)
end

function love.draw()
    vthumb_engine.draw()
    --[[love.graphics.print("current " .. string.sub(map.grid[currentLevel][pacman.line], pacman.column, pacman.column))
    love.graphics.print("x: " .. pacman.x .. "  y: " .. pacman.y, 0, 15)
    love.graphics.print("line: " .. pacman.line .. ", column: " .. pacman.column, 0, 30)
    love.graphics.print("lineTo: " .. pacman.lineTo .. ", columnTo: " .. pacman.columnTo, 0, 45)
    ]]
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
