-- Constantes pré-extraites
local PNL_BG_Y = 0
local PNL_BG_W = 431
local PNL_BG_H = 76
local PNL_TEXT_LEFT_X = 18
local PNL_TEXT_LEFT_Y = 5
local PNL_TEXT_SCALE = 0.32
local PNL_BAR_Y = 34
local PNL_BAR_H = 16
local PNL_LA_X = 12
local PNL_LA_Y = 29
local PNL_LA_W = 25
local PNL_LA_H = 25
local PNL_RA_X = 389

local _IsDisabledControlPressed = IsDisabledControlPressed
local _GetDisabledControlNormal = GetDisabledControlNormal
local _mathround = math.round

function RageUI.SliderPanel(Value, MinValue, UpperText, MaxValue, Actions, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() or CurrentMenu.Index ~= Index then return end

    Value = Value or 0
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local baseY = menuY + subH + itemOff

    local barX = PNL_LA_X + PNL_LA_W
    local barW = PNL_RA_X - PNL_LA_X - PNL_LA_W - 5 + widthOff
    local upperTextX = barW * 0.5 + barX
    local rightTextX = PNL_RA_X + PNL_LA_W
    
    local SliderW = barW / 65
    local SliderX = menuX + barX + Value * barW / MaxValue

    local safeX = CurrentMenu.SafeZoneSize.X
    local safeY = CurrentMenu.SafeZoneSize.Y

    local Hovered = RageUI.IsMouseInBounds(menuX + barX + safeX, baseY + PNL_BAR_Y + safeY - 4, barW, PNL_BAR_H + 8)

    RenderSprite("commonmenu", "gradient_bgd", menuX, baseY + PNL_BG_Y, PNL_BG_W + widthOff, PNL_BG_H, 0, 255, 255, 255, 255)
    RenderText(MinValue, menuX + PNL_TEXT_LEFT_X, baseY + PNL_TEXT_LEFT_Y, 0, PNL_TEXT_SCALE, 255, 255, 255, 255)
    RenderText(UpperText, menuX + upperTextX, baseY + PNL_TEXT_LEFT_Y, 0, PNL_TEXT_SCALE, 255, 255, 255, 255, 1)
    RenderText(MaxValue, menuX + rightTextX + widthOff, baseY + PNL_TEXT_LEFT_Y, 0, PNL_TEXT_SCALE, 255, 255, 255, 255, 2)

    RenderSprite("commonmenu", "arrowleft", menuX + PNL_LA_X, baseY + PNL_LA_Y, PNL_LA_W, PNL_LA_H, 0, 255, 255, 255, 255)
    RenderSprite("commonmenu", "arrowright", menuX + PNL_RA_X + widthOff, baseY + PNL_LA_Y, PNL_LA_W, PNL_LA_H, 0, 255, 255, 255, 255)
    RenderRectangle(menuX + barX, baseY + PNL_BAR_Y, barW, PNL_BAR_H, 87, 87, 87, 255)
    RenderRectangle(SliderX, baseY + PNL_BAR_Y, SliderW, PNL_BAR_H, 245, 245, 245, 255)

    local LeftArrowHovered = RageUI.IsMouseInBounds(menuX + PNL_LA_X + safeX, baseY + PNL_LA_Y + safeY, PNL_LA_W, PNL_LA_H)
    local RightArrowHovered = RageUI.IsMouseInBounds(menuX + PNL_RA_X + safeX + widthOff, baseY + PNL_LA_Y + safeY, PNL_LA_W, PNL_LA_H)

    if Hovered and _IsDisabledControlPressed(0, 24) then
        Value = (_mathround(_GetDisabledControlNormal(2, 239) * 1920) - safeX - barX) / barW * MaxValue
        if Value < 0 then Value = 0
        elseif Value >= MaxValue then Value = MaxValue end
        Value = _mathround(Value, 0)
        if Actions.onSliderChange then Actions.onSliderChange(Value) end
    elseif CurrentMenu.Controls.Click.Active and (LeftArrowHovered or RightArrowHovered) then
        Value = Value + (LeftArrowHovered and -1 or 1)
        if Value < MinValue then Value = MaxValue
        elseif Value > MaxValue then Value = MinValue end
        if Actions.onSliderChange then Actions.onSliderChange(Value) end
        local Audio = RageUI.Settings.Audio
        RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
    end
end
