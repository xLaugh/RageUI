-- Constantes pré-calculées
local INV_WIDTH = 0.000520833333333 -- 1/1920
local INV_HEIGHT = 0.000925925925926 -- 1/1080
local _DrawRect = DrawRect

---RenderRectangle - Optimisé
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function RenderRectangle(X, Y, Width, Height, R, G, B, A)
    local nW = Width * INV_WIDTH
    local nH = Height * INV_HEIGHT
    _DrawRect(X * INV_WIDTH + nW * 0.5, Y * INV_HEIGHT + nH * 0.5, nW, nH, R, G, B, A)
end
