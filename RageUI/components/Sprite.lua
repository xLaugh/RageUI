local INV_WIDTH = 1 / 1920
local INV_HEIGHT = 1 / 1080
local _DrawSprite = DrawSprite
local _HasStreamedTextureDictLoaded = HasStreamedTextureDictLoaded
local _RequestStreamedTextureDict = RequestStreamedTextureDict

local loadedTextures = {}

---RenderSprite
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/Sprite.lua#L90
---
---@param TextureDictionary string
---@param TextureName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function RenderSprite(dictionary, name, x, y, width, height, heading, r, g, b, a)
    local nX = (x or 0) * INV_WIDTH
    local nY = (y or 0) * INV_HEIGHT
    local nW = (width or 0) * INV_WIDTH
    local nH = (height or 0) * INV_HEIGHT

    if not loadedTextures[dictionary] then
        if not _HasStreamedTextureDictLoaded(dictionary) then
            _RequestStreamedTextureDict(dictionary, true)
        else
            loadedTextures[dictionary] = true
        end
    end

    _DrawSprite(dictionary, name, nX + nW * 0.5, nY + nH * 0.5, nW, nH, heading or 0, r or 255, g or 255, b or 255, a or 255)
end