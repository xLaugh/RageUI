local INV_WIDTH = 1 / 1920
local INV_HEIGHT = 1 / 1080
local _DrawRect = DrawRect

---RenderRectangle
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/UIResRectangle.lua#L84
---
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
    local nX = (X or 0) * INV_WIDTH
    local nY = (Y or 0) * INV_HEIGHT
    local nW = (Width or 0) * INV_WIDTH
    local nH = (Height or 0) * INV_HEIGHT
    _DrawRect(nX + nW * 0.5, nY + nH * 0.5, nW, nH, R or 255, G or 255, B or 255, A or 255)
end
