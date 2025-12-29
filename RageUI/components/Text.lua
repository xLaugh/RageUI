local INV_WIDTH = 1 / 1920
local INV_HEIGHT = 1 / 1080
local _SetTextFont = SetTextFont
local _SetTextScale = SetTextScale
local _SetTextColour = SetTextColour
local _SetTextCentre = SetTextCentre
local _SetTextRightJustify = SetTextRightJustify
local _SetTextWrap = SetTextWrap
local _SetTextDropShadow = SetTextDropShadow
local _SetTextOutline = SetTextOutline
local _BeginTextCommandDisplayText = BeginTextCommandDisplayText
local _EndTextCommandDisplayText = EndTextCommandDisplayText
local _BeginTextCommandLineCount = BeginTextCommandLineCount
local _GetTextScreenLineCount = GetTextScreenLineCount
local _AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local _BeginTextCommandWidth = BeginTextCommandWidth
local _EndTextCommandGetWidth = EndTextCommandGetWidth
local _tostring = tostring
local _sub = string.sub
local _ceil = math.ceil
local _len = string.len

-- Cache pour les largeurs de texte mesurées
local textWidthCache = {}
local textWidthCacheSize = 0
local MAX_CACHE_SIZE = 200

---MeasureStringWidth - Avec cache
---@param str string
---@param font number
---@param scale number
---@return number
---@public
function MeasureStringWidth(str, font, scale)
    local cacheKey = str .. "_" .. (scale or 0)
    if textWidthCache[cacheKey] then
        return textWidthCache[cacheKey]
    end
    
    _BeginTextCommandWidth("CELL_EMAIL_BCON")
    _AddTextComponentSubstringPlayerName(str)
    _SetTextFont(0)
    _SetTextScale(1.0, scale or 0)
    local width = _EndTextCommandGetWidth(true) * 1920
    
    -- Cache avec limite de taille
    if textWidthCacheSize < MAX_CACHE_SIZE then
        textWidthCache[cacheKey] = width
        textWidthCacheSize = textWidthCacheSize + 1
    end
    
    return width
end

---AddText - Optimisé
---@param str string
function AddText(str)
    local s = _tostring(str)
    local charCount = _len(s)

    if charCount < 100 then
        _AddTextComponentSubstringPlayerName(s)
    else
        -- Découpage inline sans création de table intermédiaire
        local pos = 1
        while pos <= charCount do
            local chunk = _sub(s, pos, pos + 98)
            _AddTextComponentSubstringPlayerName(chunk)
            pos = pos + 99
        end
    end
end


-- Constantes numériques pour éviter les comparaisons de chaînes
local ALIGN_CENTER = 1
local ALIGN_RIGHT = 2

---GetLineCount - Optimisé
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment number
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return number
---@public
function GetLineCount(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    local nX = X * INV_WIDTH
    local nY = Y * INV_HEIGHT
    
    _SetTextFont(0)
    _SetTextScale(1.0, Scale or 0)
    _SetTextColour(R or 255, G or 255, B or 255, A or 255)
    
    if DropShadow then _SetTextDropShadow() end
    if Outline then _SetTextOutline() end
    
    if Alignment == ALIGN_CENTER then
        _SetTextCentre(true)
    elseif Alignment == 4 then
        _SetTextRightJustify(true)
    end
    
    if WordWrap and WordWrap ~= 0 then
        local wrapW = WordWrap * INV_WIDTH
        if Alignment == ALIGN_CENTER then
            _SetTextWrap(nX - wrapW * 0.5, nX + wrapW * 0.5)
        elseif Alignment == 4 then
            _SetTextWrap(4)
        else
            _SetTextWrap(nX, nX + wrapW)
        end
    elseif Alignment == 4 then
        _SetTextWrap(0, nX)
    end

    _BeginTextCommandLineCount("CELL_EMAIL_BCON")
    AddText(_tostring(Text))
    return _GetTextScreenLineCount(nX, nY)
end

---RenderText - Optimisé
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment number
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return nil
---@public
function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    local nX = X * INV_WIDTH
    local nY = Y * INV_HEIGHT
    
    _SetTextFont(Font or 0)
    _SetTextScale(1.0, Scale or 0)
    _SetTextColour(R or 20, G or 20, B or 20, A or 255)
    
    if DropShadow then _SetTextDropShadow() end
    if Outline then _SetTextOutline() end
    
    if Alignment == ALIGN_CENTER then
        _SetTextCentre(true)
    elseif Alignment == ALIGN_RIGHT then
        _SetTextRightJustify(true)
    end
    
    if WordWrap and WordWrap ~= 0 then
        local wrapW = WordWrap * INV_WIDTH
        if Alignment == ALIGN_CENTER then
            _SetTextWrap(nX - wrapW * 0.5, nX + wrapW * 0.5)
        elseif Alignment == ALIGN_RIGHT then
            _SetTextWrap(0, nX)
        else
            _SetTextWrap(nX, nX + wrapW)
        end
    elseif Alignment == ALIGN_RIGHT then
        _SetTextWrap(0, nX)
    end
    
    _BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddText(_tostring(Text))
    _EndTextCommandDisplayText(nX, nY)
end
