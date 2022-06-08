-- Generic functions
function isColliding(x1, y1, x2, y2)
    return math.floor(x1 / 8) == math.floor(x2 / 8) and math.floor(y1 / 8) == math.floor(y2 / 8)
end

function drawChar(px, py, pchr)
    if fnt[pchr] == nil then
        return 0
    end
    local ax = 0
    local ay = 0
    for p = 1, string.len(fnt[pchr].map) do
        local pix = string.sub(fnt[pchr].map, p, p)
        if pix == "1" then
            vthumb.setPixel(px + ax, py + ay)
        end
        ax = ax + 1
        if ax == fnt[pchr].width then
            ax = 0
            ay = ay + 1
        end
    end
    return fnt[pchr].width
end

function drawString(px, py, pstr, pinterline)
    pinterline = pinterline or 6
    local ax = px
    local ay = py
    for s = 1, string.len(pstr) do
        local c = string.sub(pstr, s, s)
        ax = ax + drawChar(ax, ay, c)
        if ax >= vthumb.display.width then
            ax = px
            ay = ay + pinterline
        end
    end
end

function drawText(pX, pY, pText)
    local x = pX
    for i = 1, #pText do
        if LETTERS[string.sub(pText, i, i)] ~= nil then
            vthumb.Sprite(x, pY, LETTERS[string.sub(pText, i, i)])
            x = x + 8
        end
    end
end
