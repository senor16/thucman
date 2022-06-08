-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")
-- Désactive le lissage en cas de scale
love.graphics.setDefaultFilter("nearest")
-- Returns the distance between two points.
function math.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end
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
    [[if ghostIT ~= nil then
        love.graphics.print(
            "current " .. string.sub(map.grid[currentLevel][ghostIT.line], ghostIT.column, ghostIT.column)
        )
        love.graphics.print("x: " .. ghostIT.x .. "  y: " .. ghostIT.y, 0, 15)
        love.graphics.print("line: " .. ghostIT.line .. ", column: " .. ghostIT.column, 0, 30)
        love.graphics.print("lineTo: " .. ghostIT.lineTo .. ", columnTo: " .. ghostIT.columnTo, 0, 45)
        love.graphics.print("state: " .. ghostIT.state, 0, 60)
        love.graphics.print("state timer: " .. ghostIT.stateTimer, 0, 75)]]
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
