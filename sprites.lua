-- Sprites
sprites = {}
sprites[WALL] = {0, 60, 66, 90, 90, 66, 60, 0}
sprites[ROPE] = {0, 0, 0, 255, 0, 0, 0, 0}
sprites[DOT_LEVEL_SMALL] = {0, 0, 0, 24, 24, 0, 0, 0}
sprites[DOT_LEVEL_BIG] = {0, 24, 60, 126, 126, 60, 24, 0}
sprites[BONUS_STRAWBERRY] = {8, 60, 126, 126, 126, 126, 60, 24}
sprites[BONUS_CHERRY] = {15, 18, 100, 244, 236, 94, 30, 12}

-- ghost animations
ghost = {}
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

-- Pacman animations
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
