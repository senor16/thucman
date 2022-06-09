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
    if scene == SCENE_GAME then
        local x,
            y = 0, 0
        local xycor = {{x = 0, y = 0}, {x = 600, y = 0}, {x = 0, y = 200}, {x = 600, y = 200}}
        for k, ghost in pairs(listGhosts) do
            y = xycor[k].y
            x = xycor[k].x
            love.graphics.print("current " .. ghost.level, x, y)
            y = y + 15
            love.graphics.print("x: " .. ghost.x .. "  y: " .. ghost.y, x, y)
            love.graphics.print("line: " .. ghost.line .. ", column: " .. ghost.column, x, y + 30)
            love.graphics.print("lineTo: " .. ghost.lineTo .. ", columnTo: " .. ghost.columnTo, x, y + 45)
            love.graphics.print("state: " .. ghost.state .. ", Level : " .. currentLevel, x, y + 60)
            love.graphics.print(
                "state timer: " .. math.floor(ghost.stateTimer) .. ", blue timer: " .. math.floor(ghost.blueTimer),
                x,
                y + 75
            )
            love.graphics.print(
                "State Goal : Scatter" ..
                    GHOST_TRANSITIONS[currentLevel][ghost.trans][1] ..
                        ", Chase " .. GHOST_TRANSITIONS[currentLevel][ghost.trans][2],
                x,
                y + 90
            )
            love.graphics.print("Trans : " .. ghost.trans, x, y + 105)
        end
        y = y + 200
        love.graphics.print("x: " .. pacman.x .. "  y: " .. pacman.y, x, y + 15)
        love.graphics.print("line: " .. pacman.line .. ", column: " .. pacman.column, x, y + 30)
        love.graphics.print("lineTo: " .. pacman.lineTo .. ", columnTo: " .. pacman.columnTo, x, y + 45)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
