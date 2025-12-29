-- Constantes pré-calculées
local PCT_BG_DICT = "commonmenu"
local PCT_BG_TEX = "gradient_bgd"
local PCT_BG_Y = 4
local PCT_BG_W = 431
local PCT_BG_H = 76
local PCT_BAR_X = 9
local PCT_BAR_Y = 50
local PCT_BAR_W = 413
local PCT_BAR_H = 10
local PCT_TEXT_LEFT_X = 25
local PCT_TEXT_LEFT_Y = 15
local PCT_TEXT_MID_X = 215.5
local PCT_TEXT_MID_Y = 15
local PCT_TEXT_RIGHT_X = 398
local PCT_TEXT_RIGHT_Y = 15
local PCT_TEXT_SCALE = 0.35

local _IsDisabledControlPressed = IsDisabledControlPressed
local _GetControlNormal = GetControlNormal
local _round = math.round

function RageUI.PercentagePanel(Percent, HeaderText, MinText, MaxText, Action, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end
    if Index and CurrentMenu.Index ~= Index then return end

    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local safeX = CurrentMenu.SafeZoneSize.X
    local safeY = CurrentMenu.SafeZoneSize.Y
    local halfWidth = widthOff * 0.5

    if Percent < 0.0 then Percent = 0.0
    elseif Percent > 1.0 then Percent = 1.0 end

    local Progress = PCT_BAR_W * Percent
    local barBaseX = menuX + PCT_BAR_X + halfWidth
    local barBaseY = menuY + PCT_BAR_Y + subH + itemOff

    RenderSprite(PCT_BG_DICT, PCT_BG_TEX, menuX, menuY + PCT_BG_Y + subH + itemOff, PCT_BG_W + widthOff, PCT_BG_H)
    RenderRectangle(barBaseX, barBaseY, PCT_BAR_W, PCT_BAR_H, 87, 87, 87, 255)
    RenderRectangle(barBaseX, barBaseY, Progress, PCT_BAR_H, 245, 245, 245, 255)

    RenderText(HeaderText or "Opacity", menuX + PCT_TEXT_MID_X + halfWidth, menuY + PCT_TEXT_MID_Y + subH + itemOff, 0, PCT_TEXT_SCALE, 245, 245, 245, 255, 1)
    RenderText(MinText or "0%", menuX + PCT_TEXT_LEFT_X + halfWidth, menuY + PCT_TEXT_LEFT_Y + subH + itemOff, 0, PCT_TEXT_SCALE, 245, 245, 245, 255, 1)
    RenderText(MaxText or "100%", menuX + PCT_TEXT_RIGHT_X + halfWidth, menuY + PCT_TEXT_RIGHT_Y + subH + itemOff, 0, PCT_TEXT_SCALE, 245, 245, 245, 255, 1)

    local Hovered = RageUI.IsMouseInBounds(barBaseX + safeX, barBaseY + safeY - 4, PCT_BAR_W + widthOff, PCT_BAR_H + 8)
    local Selected = false

    if Hovered and _IsDisabledControlPressed(0, 24) then
        Selected = true
        Progress = _round(_GetControlNormal(2, 239) * 1920) - safeX - barBaseX
        if Progress < 0 then Progress = 0
        elseif Progress > PCT_BAR_W then Progress = PCT_BAR_W end
        Percent = _round(Progress / PCT_BAR_W, 2)
        if Action.onProgressChange then
            Action.onProgressChange(Percent)
        end
    end

    RageUI.ItemOffset = itemOff + PCT_BG_H + PCT_BG_Y

    if Hovered and Selected then
        local Audio = RageUI.Settings.Audio
        RageUI.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
        if Action.onSelected then
            Action.onSelected(Percent)
        end
    end
end
