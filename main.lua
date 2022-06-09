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
    local x,
        y = 0, 0
    local xycor = {{x = 0, y = 0}, {x = 600, y = 0}, {x = 0, y = 200}, {x = 600, y = 200}}
    for k, ghost in pairs(listGhosts) do
        y = xycor[k].y
        x = xycor[k].x
        love.graphics.print("current " .. ghost.level, x, y)
        love.graphics.print("x: " .. ghost.x .. "  y: " .. ghost.y, x, y + 15)
        love.graphics.print("line: " .. ghost.line .. ", column: " .. ghost.column, x, y + 30)
        love.graphics.print("lineTo: " .. ghost.lineTo .. ", columnTo: " .. ghost.columnTo, x, y + 45)
        love.graphics.print("state: " .. ghost.state, x, y + 60)
        love.graphics.print("state timer: " .. ghost.stateTimer, x, y + 75)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
