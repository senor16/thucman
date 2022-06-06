-- Game constants
-- Bonus
DOT = "."
CHERRY = "1"
STRAWBERRY = "2"
ORANGE = "3"
APPLE = "4"
MELON = "5"
GALAXIAN = "6"
BELL = "7"
KEY = "8"
-- sprites
WALL = "w"
ROPE = "-"
ESCAPE = "e"
DOT_LEVEL_BIG = "d"
DOT_LEVEL_SMALL = "."
GHOST = "GHOST"
GHOST_LEVEL_INKY = "i"
GHOST_LEVEL_PINKY = "p"
GHOST_LEVEL_BLINKY = "b"
GHOST_LEVEL_CLYDE = "c"
GHOST_STATE_FEAR = "fear"
BONUS = "BONUS"
PACMAN = "PACMAN"
PACMAN_STATE_KILL = "kill"
PACMAN_STATE_NORMAL = "normal"
SCENE_MENU = "menu"
SCENE_GAME = "game"
LETTERS = {
    U = {99, 99, 99, 99, 99, 99, 127, 62},
    T = {63, 63, 12, 12, 12, 12, 12, 12},
    C = {62, 127, 97, 96, 96, 97, 127, 62},
    M = {99, 119, 127, 107, 99, 99, 99, 99},
    A = {62, 127, 127, 99, 99, 127, 99, 99},
    N = {99, 115, 115, 107, 107, 103, 103, 99},
    H = {99, 99, 99, 127, 127, 99, 99, 99},
    B = {127, 99, 100, 120, 100, 99, 127, 127},
    -- Small caps
    a = {0, 0, 0, 56, 68, 124, 68, 68},
    b = {0, 0, 0, 112, 72, 112, 72, 112}
}
LETTERS["-"] = {0, 0, 0, 60, 60, 0, 0, 0}
LETTERS[">"] = {0, 0, 0, 16, 8, 252, 8, 16}
LETTERS["+"] = {0, 0, 0, 0, 16, 56, 16, 0}

fnt = {}
fnt["A"] = {width = 4, map = "11101010111010101010"}
fnt["B"] = {width = 4, map = "11101010110010101110"}
fnt["C"] = {width = 4, map = "11101000100010001110"}
fnt["D"] = {width = 4, map = "11001010101010101100"}
fnt["E"] = {width = 4, map = "11101000110010001110"}
fnt["F"] = {width = 4, map = "11101000110010001000"}
fnt["G"] = {width = 4, map = "11101000101010101110"}
fnt["H"] = {width = 4, map = "10101010111010101010"}
fnt["I"] = {width = 4, map = "11100100010001001110"}
fnt["J"] = {width = 4, map = "01100010001010101110"}
fnt["K"] = {width = 4, map = "10101010110010101010"}
fnt["L"] = {width = 4, map = "10001000100010001110"}
fnt["M"] = {width = 5, map = "1001011110111101001010010"}
fnt["N"] = {width = 5, map = "1001011010111101011010010"}
fnt["O"] = {width = 4, map = "11101010101010101110"}
fnt["P"] = {width = 4, map = "11101010111010001000"}
fnt["Q"] = {width = 5, map = "1110010100101001110011110"}
fnt["R"] = {width = 4, map = "11101010110010101010"}
fnt["S"] = {width = 4, map = "11101000111000101110"}
fnt["T"] = {width = 4, map = "11100100010001000100"}
fnt["U"] = {width = 4, map = "10101010101010101110"}
fnt["V"] = {width = 4, map = "10101010101011100100"}
fnt["W"] = {width = 5, map = "1001010010111101111010010"}
fnt["X"] = {width = 4, map = "10101010010010101010"}
fnt["Y"] = {width = 4, map = "10101010010001000100"}
fnt["Z"] = {width = 4, map = "11100010010010001110"}
fnt["0"] = {width = 4, map = "11101010101010101110"}
fnt["1"] = {width = 4, map = "01001100010001001110"}
fnt["2"] = {width = 4, map = "11100010111010001110"}
fnt["3"] = {width = 4, map = "11100010011000101110"}
fnt["4"] = {width = 4, map = "10001010111000100010"}
fnt["5"] = {width = 4, map = "11101000111000101110"}
fnt["6"] = {width = 4, map = "11101000111010101110"}
fnt["7"] = {width = 4, map = "11100010001000100010"}
fnt["8"] = {width = 4, map = "11101010111010101110"}
fnt["9"] = {width = 4, map = "11101010111000101110"}
fnt["."] = {width = 3, map = "000000000110110"}
fnt[","] = {width = 4, map = "00000000011001101100"}
fnt['"'] = {width = 4, map = "10101010000000000000"}
fnt["!"] = {width = 3, map = "110110110000110"}
fnt["?"] = {width = 4, map = "11000110110000001100"}
fnt["-"] = {width = 4, map = "00000000111000000000"}
fnt["+"] = {width = 4, map = "00000100111001000000"}
fnt["'"] = {width = 4, map = "01100110110000000000"}
fnt[" "] = {width = 3, map = "000000000000000"}

-- Rewards
REWARDS = {}
REWARDS[DOT_LEVEL_SMALL] = 10
REWARDS[DOT_LEVEL_BIG] = 50
REWARDS[GHOST] = {200, 400, 800, 1600}
REWARDS[STRAWBERRY] = 300
REWARDS[CHERRY] = 100
REWARDS[ORANGE] = 500
REWARDS[APPLE] = 700
REWARDS[MELON] = 1000
REWARDS[GALAXIAN] = 2000
REWARDS[BELL] = 3000
REWARDS[KEY] = 5000