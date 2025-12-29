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
local _tostring = tostring
local _sub = string.sub
local _ceil = math.ceil

---StringToArray
---
--- Reference : Frazzle <3
---
---@param str string
function StringToArray(str)
    local charCount = #str
    local strCount = _ceil(charCount / 99)
    local strings = {}

    for i = 1, strCount do
        local start = (i - 1) * 99 + 1
        local clamp = math.clamp(#_sub(str, start), 0, 99)
        local finish = ((i ~= 1) and (start - 1) or 0) + clamp

        strings[i] = _sub(str, start, finish)
    end

    return strings
end

---MeasureStringWidth
---
--- Reference : Frazzle <3
---
---@param str string
---@param font number
---@param scale number
---@return _G
---@public
function MeasureStringWidth(str, font, scale)
    BeginTextCommandWidth("CELL_EMAIL_BCON")
    AddTextComponentSubstringPlayerName(str)
    SetTextFont(0)
    SetTextScale(1.0, scale or 0)
    return EndTextCommandGetWidth(true) * 1920
end


---AddText
---
--- Reference : Frazzle <3
---
---@param str string
function AddText(str)
    local s = _tostring(str)
    local charCount = #s

    if charCount < 100 then
        _AddTextComponentSubstringPlayerName(s)
    else
        local strings = StringToArray(s)
        for i = 1, #strings do
            _AddTextComponentSubstringPlayerName(strings[i])
        end
    end
end


---GetLineCount
---
--- Reference : Frazzle <3
---
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return function
---@public
function GetLineCount(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    local sText = _tostring(Text)
    local nX = (X or 0) * INV_WIDTH
    local nY = (Y or 0) * INV_HEIGHT
    _SetTextFont(0)
    _SetTextScale(1.0, Scale or 0)
    _SetTextColour(R or 255, G or 255, B or 255, A or 255)
    if DropShadow then
        _SetTextDropShadow()
    end
    if Outline then
        _SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextCentre(true)
        elseif Alignment == 4 or Alignment == "Right" then
            _SetTextRightJustify(true)
        end
    end
    if WordWrap and WordWrap ~= 0 then
        local wrapW = WordWrap * INV_WIDTH
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextWrap(nX - wrapW * 0.5, nX + wrapW * 0.5)
        elseif Alignment == 4 or Alignment == "Right" then
            _SetTextWrap(4)
        else
            _SetTextWrap(nX, nX + wrapW)
        end
    else
        if Alignment == 4 or Alignment == "Right" then
            _SetTextWrap(0, nX)
        end
    end

    _BeginTextCommandLineCount("CELL_EMAIL_BCON")
    AddText(sText)
    return _GetTextScreenLineCount(nX, nY)
end

---RenderText
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/UIResText.lua#L189
---
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return nil
---@public
function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    local sText = _tostring(Text)
    local nX = (X or 0) * INV_WIDTH
    local nY = (Y or 0) * INV_HEIGHT
    _SetTextFont(Font or 0)
    _SetTextScale(1.0, Scale or 0)
    _SetTextColour(R or 20, G or 20, B or 20, A or 255)
    if DropShadow then
        _SetTextDropShadow()
    end
    if Outline then
        _SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            _SetTextRightJustify(true)
        end
    end
    if WordWrap and WordWrap ~= 0 then
        local wrapW = WordWrap * INV_WIDTH
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextWrap(nX - wrapW * 0.5, nX + wrapW * 0.5)
        elseif Alignment == 2 or Alignment == "Right" then
            _SetTextWrap(0, nX)
        else
            _SetTextWrap(nX, nX + wrapW)
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            _SetTextWrap(0, nX)
        end
    end
    _BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddText(sText)
    _EndTextCommandDisplayText(nX, nY)
end
