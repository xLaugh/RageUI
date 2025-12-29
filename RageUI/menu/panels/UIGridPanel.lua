local GridType = RageUI.Enum {
    Default = 1,
    Horizontal = 2,
    Vertical = 3
}

local GridSprite = {
    [GridType.Default] = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "nose_grid", },
    [GridType.Horizontal] = { Dictionary = "offline", Texture = "horizontal_grid", },
    [GridType.Vertical] = { Dictionary = "offline", Texture = "vertical_grid", },
}

-- Constantes pré-calculées
local GRID_BG_DICT = "commonmenu"
local GRID_BG_TEX = "gradient_bgd"
local GRID_BG_Y = 4
local GRID_BG_W = 431
local GRID_BG_H = 275
local GRID_X = 115.5
local GRID_Y = 47.5
local GRID_W = 200
local GRID_H = 200
local CIRCLE_DICT = "mpinventory"
local CIRCLE_TEX = "in_world_circle"
local CIRCLE_W = 20
local CIRCLE_H = 20
local TEXT_TOP_X = 215.5
local TEXT_TOP_Y = 15
local TEXT_BOT_X = 215.5
local TEXT_BOT_Y = 250
local TEXT_LEFT_X = 57.75
local TEXT_LEFT_Y = 130
local TEXT_RIGHT_X = 373.25
local TEXT_RIGHT_Y = 130
local TEXT_SCALE = 0.35

-- Natives localisées
local _IsDisabledControlPressed = IsDisabledControlPressed
local _IsControlEnabled = IsControlEnabled
local _GetControlNormal = GetControlNormal
local _GetDisabledControlNormal = GetDisabledControlNormal
local _round = math.round

local function UIGridPanel(Type, StartedX, StartedY, TopText, BottomText, LeftText, RightText, Action, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() or CurrentMenu.Index ~= Index then return end
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local safeX = CurrentMenu.SafeZoneSize.X
    local safeY = CurrentMenu.SafeZoneSize.Y
    local halfWidth = widthOff * 0.5
    
    local X = Type == GridType.Default and StartedX or Type == GridType.Horizontal and StartedX or 0.5
    local Y = Type == GridType.Default and StartedY or Type == GridType.Horizontal and 0.5 or StartedY
    
    if X < 0.0 or X > 1.0 then X = 0.0 end
    if Y < 0.0 or Y > 1.0 then Y = 0.0 end
    
    local gridBaseX = menuX + GRID_X + halfWidth + 20
    local gridBaseY = menuY + GRID_Y + subH + itemOff + 20
    local gridInnerW = GRID_W - 40
    local gridInnerH = GRID_H - 40
    
    local CircleX = gridBaseX + (gridInnerW * X) - (CIRCLE_W * 0.5)
    local CircleY = gridBaseY + (gridInnerH * Y) - (CIRCLE_H * 0.5)
    
    RenderSprite(GRID_BG_DICT, GRID_BG_TEX, menuX, menuY + GRID_BG_Y + subH + itemOff, GRID_BG_W + widthOff, GRID_BG_H)
    RenderSprite(GridSprite[Type].Dictionary, GridSprite[Type].Texture, menuX + GRID_X + halfWidth, menuY + GRID_Y + subH + itemOff, GRID_W, GRID_H)
    RenderSprite(CIRCLE_DICT, CIRCLE_TEX, CircleX, CircleY, CIRCLE_W, CIRCLE_H)
    
    if Type == GridType.Default then
        RenderText(TopText or "", menuX + TEXT_TOP_X + halfWidth, menuY + TEXT_TOP_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
        RenderText(BottomText or "", menuX + TEXT_BOT_X + halfWidth, menuY + TEXT_BOT_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
        RenderText(LeftText or "", menuX + TEXT_LEFT_X + halfWidth, menuY + TEXT_LEFT_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
        RenderText(RightText or "", menuX + TEXT_RIGHT_X + halfWidth, menuY + TEXT_RIGHT_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
    elseif Type == GridType.Vertical then
        RenderText(TopText or "", menuX + TEXT_TOP_X + halfWidth, menuY + TEXT_TOP_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
        RenderText(BottomText or "", menuX + TEXT_BOT_X + halfWidth, menuY + TEXT_BOT_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
    else
        RenderText(LeftText or "", menuX + TEXT_LEFT_X + halfWidth, menuY + TEXT_LEFT_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
        RenderText(RightText or "", menuX + TEXT_RIGHT_X + halfWidth, menuY + TEXT_RIGHT_Y + subH + itemOff, 0, TEXT_SCALE, 245, 245, 245, 255, 1)
    end
    
    local Selected = false
    local Hovered = RageUI.IsMouseInBounds(menuX + GRID_X + safeX + 20, gridBaseY - 20 + safeY, GRID_W + widthOff - 40, gridInnerH)
    
    if Hovered and _IsDisabledControlPressed(0, 24) then
        Selected = true
        local halfCircle = CIRCLE_W * 0.5
        CircleX = _round((_IsControlEnabled(2, 239) and _GetControlNormal(2, 239) or _GetDisabledControlNormal(2, 239)) * 1920) - safeX - halfCircle
        CircleY = _round((_IsControlEnabled(2, 240) and _GetControlNormal(2, 240) or _GetDisabledControlNormal(2, 240)) * 1080) - safeY - halfCircle
        
        local maxX = gridBaseX + gridInnerW
        local minX = menuX + GRID_X + 20 - halfCircle
        local maxY = gridBaseY + gridInnerH
        local minY = gridBaseY - halfCircle
        
        if CircleX > maxX then CircleX = maxX
        elseif CircleX < minX then CircleX = minX end
        if CircleY > maxY then CircleY = maxY
        elseif CircleY < minY then CircleY = minY end
        
        X = _round((CircleX - gridBaseX + halfCircle) / gridInnerW, 2)
        Y = _round((CircleY - gridBaseY + halfCircle) / gridInnerH, 2)
        
        if X > 1.0 then X = 1.0 end
        if Y > 1.0 then Y = 1.0 end
        
        if X ~= StartedX or Y ~= StartedY then
            if Action.onPositionChange then
                Action.onPositionChange(X, Y, (X * 2 - 1), (Y * 2 - 1))
            end
        end
    end
    
    RageUI.ItemOffset = itemOff + GRID_BG_H + GRID_BG_Y
    
    if Hovered and Selected then
        local Audio = RageUI.Settings.Audio
        RageUI.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
        if Action.onSelected then
            Action.onSelected(X, Y, (X * 2 - 1), (Y * 2 - 1))
        end
    end
end

function RageUI.Grid(StartedX, StartedY, TopText, BottomText, LeftText, RightText, Action, Index)
    UIGridPanel(GridType.Default, StartedX, StartedY, TopText, BottomText, LeftText, RightText, Action, Index)
end

function RageUI.GridHorizontal(StartedX, LeftText, RightText, Action, Index)
    UIGridPanel(GridType.Horizontal, StartedX, nil, nil, nil, LeftText, RightText, Action, Index)
end

function RageUI.GridVertical(StartedY, TopText, BottomText, Action, Index)
    UIGridPanel(GridType.Vertical, nil, StartedY, TopText, BottomText, nil, nil, Action, Index)
end
