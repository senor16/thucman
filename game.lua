-- API
--[[

vthumb.display.width  : largeur de l'écran
vthumb.display.height : heuteur de l'écran

Récupérer l'état des boutons :
vthumb.buttonA.pressed / justPressed
vthumb.buttonB.pressed / justPressed
vthumb.buttonU.pressed / justPressed
vthumb.buttonD.pressed / justPressed
vthumb.buttonL.pressed / justPressed
vthumb.buttonR.pressed / justPressed

Modifier un pixel :
vthumb.setPixel(x,y)

Lire la valeur d'un pixel (0 ou 1) :
pixel = vthumb.getPixel(x,y)

Dessiner un sprite (8x8, chaque ligne décrite avec un octet)
sprite = {255, 129, 129, 129, 129, 129, 129, 255}
vthumb.Sprite(x, y, sprite)

]]
local t = 1
-- Items
dots = {0, 0, 0, 24, 24, 0, 0, 0}
bigdot = {0, 24, 60, 126, 126, 60, 24, 0}
tomato = {8, 60, 126, 126, 126, 126, 60, 24}
candy = {15, 18, 100, 244, 236, 94, 30, 12}

-- ghost animations
local ghost = {}
ghost.topRight = {
    {0, 124, 254, 146, 218, 254, 254, 170},
    {0, 124, 254, 146, 218, 254, 254, 84}
}

ghost.topLeft = {
    {0, 124, 254, 146, 182, 254, 254, 170},
    {0, 124, 254, 146, 182, 254, 254, 84}
}

ghost.botomLeft = {
    {0, 124, 254, 182, 146, 254, 254, 170},
    {0, 124, 254, 182, 146, 254, 254, 84}
}

ghost.botomRight = {
    {0, 124, 254, 218, 146, 254, 254, 170},
    {0, 124, 254, 218, 146, 254, 254, 84}
}

ghost.current = ghost.topLeft

-- Pacman
local pacman = {}
-- Animation
-- Moving
pacman.right = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {60, 126, 248, 240, 224, 240, 120, 60}
}

pacman.left = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {60, 30, 15, 7, 15, 31, 126, 60}
}

pacman.up = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {0, 64, 193, 227, 247, 255, 126, 60}
}

pacman.down = {
    {60, 126, 255, 255, 255, 255, 126, 60},
    {60, 126, 255, 239, 199, 131, 2, 0}
}

-- Death
pacman.death = {
    {0, 66, 195, 231, 255, 255, 126, 60},
    {0, 0, 129, 231, 255, 255, 126, 60},
    {0, 0, 129, 231, 255, 126, 24, 0},
    {0, 0, 0, 255, 255, 255, 24, 0},
    {0, 0, 0, 60, 255, 219, 0, 0},
    {0, 0, 0, 24, 60, 126, 255, 102},
    {0, 0, 0, 24, 24, 60, 126, 36},
    {0, 0, 0, 24, 24, 60, 60, 0},
    {0, 0, 0, 0, 24, 24, 24, 24},
    {66, 36, 129, 66, 66, 129, 36, 66}
}

pacman.current = pacman.death
local x,
    y
x = 1
y = 1

function v()
    t = t + 1 / 4
    if t >= #pacman.current + 1 then
        t = 1
    end
    vthumb.Sprite(x, y, pacman.current[math.floor(t)])

    if vthumb.buttonA.justPressed == true then
        x = x - 1
    end
    if vthumb.buttonB.justPressed == true then
        x = x + 1
    end

    if vthumb.buttonR.pressed == true then
        x = x + 1
        pacman.current = pacman.right
    end
    if vthumb.buttonL.pressed == true then
        x = x - 1
        pacman.current = pacman.left
    end
    if vthumb.buttonU.pressed == true then
        y = y - 1
        pacman.current = pacman.up
    end
    if vthumb.buttonD.pressed == true then
        y = y + 1
        pacman.current = pacman.down
    end
end
