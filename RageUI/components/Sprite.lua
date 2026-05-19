local INV_WIDTH = 1 / 1920
local INV_HEIGHT = 1 / 1080
local _DrawSprite = DrawSprite
local _HasStreamedTextureDictLoaded = HasStreamedTextureDictLoaded
local _RequestStreamedTextureDict = RequestStreamedTextureDict

-- Cache des textures chargées : la valeur passe à `true` une fois le streaming
-- réellement effectif (et non au moment de la demande). Évite que les
-- premières frames ne dessinent sur une texture pas encore chargée.
local COMMON_TEXTURES = {
    "commonmenu",
    "commonmenutu",
    "mpleaderboard",
    "mpinventory",
    "pause_menu_pages_char_mom_dad",
}
local loadedTextures = {}

-- Pré-charger les textures communes au démarrage
Citizen.CreateThread(function()
    for i = 1, #COMMON_TEXTURES do
        local dict = COMMON_TEXTURES[i]
        if not _HasStreamedTextureDictLoaded(dict) then
            _RequestStreamedTextureDict(dict, true)
            while not _HasStreamedTextureDictLoaded(dict) do
                Citizen.Wait(0)
            end
        end
        loadedTextures[dict] = true
    end
end)

---RenderSprite - Optimisé
---@param dictionary string
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param heading number
---@param r number
---@param g number
---@param b number
---@param a number
---@return nil
---@public
function RenderSprite(dictionary, name, x, y, width, height, heading, r, g, b, a)
    -- Calculs inline optimisés
    local nW = (width or 0) * INV_WIDTH
    local nH = (height or 0) * INV_HEIGHT
    local centerX = (x or 0) * INV_WIDTH + nW * 0.5
    local centerY = (y or 0) * INV_HEIGHT + nH * 0.5

    -- Vérification texture avec cache
    if not loadedTextures[dictionary] then
        if _HasStreamedTextureDictLoaded(dictionary) then
            loadedTextures[dictionary] = true
        else
            _RequestStreamedTextureDict(dictionary, true)
            return -- Ne pas dessiner si pas encore chargée
        end
    end

    _DrawSprite(dictionary, name, centerX, centerY, nW, nH, heading or 0, r or 255, g or 255, b or 255, a or 255)
end