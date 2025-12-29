-- Constantes pré-extraites
local SLD_RECT_H = 38
local SLD_TEXT_X = 8
local SLD_TEXT_Y = 3
local SLD_TEXT_SCALE = 0.33
local SLD_LBADGE_Y = -2
local SLD_LBADGE_W = 40
local SLD_LBADGE_H = 40
local SLD_RBADGE_X = 385
local SLD_RBADGE_Y = -2
local SLD_RBADGE_W = 40
local SLD_RBADGE_H = 40
local SLD_RTEXT_X = 420
local SLD_RTEXT_Y = 4
local SLD_RTEXT_SCALE = 0.35
local SLD_SEL_DICT = "commonmenu"
local SLD_SEL_TEX = "gradient_nav"
local SLD_SEL_W = 431
local SLD_SEL_H = 38

local SLIDER_BG_X = 250
local SLIDER_BG_Y = 14.5
local SLIDER_BG_W = 150
local SLIDER_BG_H = 9
local SLIDER_X = 250
local SLIDER_Y = 14.5
local SLIDER_W = 75
local SLIDER_H = 9
local SLIDER_DIV_X = 323.5
local SLIDER_DIV_Y = 9
local SLIDER_DIV_W = 2.5
local SLIDER_DIV_H = 20
local ARROW_DICT = "commonmenutu"
local LARROW_X = 235
local LARROW_Y = 11.5
local ARROW_W = 15
local ARROW_H = 15
local RARROW_X = 400
local RARROW_Y = 11.5

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = SLD_RECT_H },
    Text = { X = SLD_TEXT_X, Y = SLD_TEXT_Y, Scale = SLD_TEXT_SCALE },
    LeftBadge = { Y = SLD_LBADGE_Y, Width = SLD_LBADGE_W, Height = SLD_LBADGE_H },
    RightBadge = { X = SLD_RBADGE_X, Y = SLD_RBADGE_Y, Width = SLD_RBADGE_W, Height = SLD_RBADGE_H },
    RightText = { X = SLD_RTEXT_X, Y = SLD_RTEXT_Y, Scale = SLD_RTEXT_SCALE },
    SelectedSprite = { Dictionary = SLD_SEL_DICT, Texture = SLD_SEL_TEX, Y = 0, Width = SLD_SEL_W, Height = SLD_SEL_H },
}

---@type table
local SettingsSlider = {
    Background = { X = SLIDER_BG_X, Y = SLIDER_BG_Y, Width = SLIDER_BG_W, Height = SLIDER_BG_H },
    Slider = { X = SLIDER_X, Y = SLIDER_Y, Width = SLIDER_W, Height = SLIDER_H },
    Divider = { X = SLIDER_DIV_X, Y = SLIDER_DIV_Y, Width = SLIDER_DIV_W, Height = SLIDER_DIV_H },
    LeftArrow = { Dictionary = ARROW_DICT, Texture = "arrowleft", X = LARROW_X, Y = LARROW_Y, Width = ARROW_W, Height = ARROW_H },
    RightArrow = { Dictionary = ARROW_DICT, Texture = "arrowright", X = RARROW_X, Y = RARROW_Y, Width = ARROW_W, Height = ARROW_H },
}

function RageUI.Slider(Label, ProgressStart, ProgressMax, Description, Divider, Style, Enabled, Actions)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu == nil or not CurrentMenu() then return end

    local Option = RageUI.Options + 1
    local pagination = CurrentMenu.Pagination

    if pagination.Minimum <= Option and pagination.Maximum >= Option then
        local Selected = CurrentMenu.Index == Option
        local menuX = CurrentMenu.X
        local menuY = CurrentMenu.Y
        local subH = CurrentMenu.SubtitleHeight
        local widthOff = CurrentMenu.WidthOffset
        local itemOff = RageUI.ItemOffset
        local safeX = CurrentMenu.SafeZoneSize.X
        local safeY = CurrentMenu.SafeZoneSize.Y

        RageUI.ItemsSafeZone(CurrentMenu)

        local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton) or false
        local LeftBadgeOffset = (Style.LeftBadge == nil or Style.LeftBadge == RageUI.BadgeStyle.None) and 0 or 27
        local RightBadgeOffset = (Style.RightBadge == nil or Style.RightBadge == RageUI.BadgeStyle.None) and 0 or 32
        local RightOffset = 0

        local LeftArrowHovered, RightArrowHovered = false, false

        if Selected then
            RenderSprite(SLD_SEL_DICT, SLD_SEL_TEX, menuX, menuY + subH + itemOff, SLD_SEL_W + widthOff, SLD_SEL_H)
            LeftArrowHovered = RageUI.IsMouseInBounds(menuX + LARROW_X + safeX + widthOff, menuY + LARROW_Y + safeY + subH + itemOff, ARROW_W, ARROW_H)
            RightArrowHovered = RageUI.IsMouseInBounds(menuX + RARROW_X + safeX + widthOff, menuY + RARROW_Y + safeY + subH + itemOff, ARROW_W, ARROW_H)
        end

        local isEnabled = Enabled == true or Enabled == nil
        local textColor = Selected and 0 or 245

        if isEnabled then
            if Style.RightLabel and Style.RightLabel ~= "" then
                RenderText(Style.RightLabel, menuX + SLD_RTEXT_X - RightBadgeOffset + widthOff, menuY + SLD_RTEXT_Y + subH + itemOff, 0, SLD_RTEXT_SCALE, textColor, textColor, textColor, 255, 2)
                RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
            end
        end

        RightOffset = RightOffset + RightBadgeOffset

        if isEnabled then
            RenderText(Label, menuX + SLD_TEXT_X + LeftBadgeOffset, menuY + SLD_TEXT_Y + subH + itemOff, 0, SLD_TEXT_SCALE, textColor, textColor, textColor, 255)
            if Selected then
                RenderSprite(ARROW_DICT, "arrowleft", menuX + LARROW_X + widthOff - RightOffset, menuY + LARROW_Y + subH + itemOff, ARROW_W, ARROW_H, 0, 0, 0, 0, 255)
                RenderSprite(ARROW_DICT, "arrowright", menuX + RARROW_X + widthOff - RightOffset, menuY + RARROW_Y + subH + itemOff, ARROW_W, ARROW_H, 0, 0, 0, 0, 255)
            end
        else
            RenderText(Label, menuX + SLD_TEXT_X + LeftBadgeOffset, menuY + SLD_TEXT_Y + subH + itemOff, 0, SLD_TEXT_SCALE, 163, 159, 148, 255)
            if Selected then
                RenderSprite(ARROW_DICT, "arrowleft", menuX + LARROW_X + widthOff - RightOffset, menuY + LARROW_Y + subH + itemOff, ARROW_W, ARROW_H, 163, 159, 148, 255)
                RenderSprite(ARROW_DICT, "arrowright", menuX + RARROW_X + widthOff - RightOffset, menuY + RARROW_Y + subH + itemOff, ARROW_W, ARROW_H, 163, 159, 148, 255)
            end
        end

        local styleEnabled = Style.Enabled == true or Style.Enabled == nil
        if styleEnabled then
            if Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.LeftBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + SLD_LBADGE_Y + subH + itemOff, SLD_LBADGE_W, SLD_LBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
            if Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.RightBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX + SLD_RBADGE_X + widthOff, menuY + SLD_RBADGE_Y + subH + itemOff, SLD_RBADGE_W, SLD_RBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
        else
            local LockBadge = RageUI.BadgeStyle.Lock
            local badge = LockBadge(Selected)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + SLD_LBADGE_Y + subH + itemOff, SLD_LBADGE_W, SLD_LBADGE_H, 0, bc.R or 255, bc.G or 255, bc.B or 255, bc.A or 255)
        end

        -- Slider background & slider
        local sliderStep = (SLIDER_BG_W - SLIDER_W) / (ProgressMax - 1)
        RenderRectangle(menuX + SLIDER_BG_X + widthOff - RightOffset, menuY + SLIDER_BG_Y + subH + itemOff, SLIDER_BG_W, SLIDER_BG_H, 4, 32, 57, 255)
        RenderRectangle(menuX + SLIDER_X + (sliderStep * (ProgressStart - 1)) + widthOff - RightOffset, menuY + SLIDER_Y + subH + itemOff, SLIDER_W, SLIDER_H, 57, 116, 200, 255)

        if Divider then
            RenderRectangle(menuX + SLIDER_DIV_X + widthOff, menuY + SLIDER_DIV_Y + subH + itemOff, SLIDER_DIV_W, SLIDER_DIV_H, 245, 245, 245, 255)
        end

        RageUI.ItemOffset = itemOff + SLD_RECT_H
        RageUI.ItemsDescription(CurrentMenu, Description, Selected)

        local controls = CurrentMenu.Controls
        if Selected then
            local leftActive = controls.Left.Active or (controls.Click.Active and LeftArrowHovered)
            local rightActive = controls.Right.Active or (controls.Click.Active and RightArrowHovered)
            local Audio = RageUI.Settings.Audio

            if leftActive and not rightActive then
                ProgressStart = ProgressStart - 1
                if ProgressStart < 1 then ProgressStart = ProgressMax end
                if Actions.onSliderChange then Actions.onSliderChange(ProgressStart) end
                RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
            elseif rightActive and not leftActive then
                ProgressStart = ProgressStart + 1
                if ProgressStart > ProgressMax then ProgressStart = 1 end
                if Actions.onSliderChange then Actions.onSliderChange(ProgressStart) end
                RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
            end

            if controls.Select.Active or ((Hovered and controls.Click.Active) and not LeftArrowHovered and not RightArrowHovered) then
                if Actions.onSelected then Actions.onSelected(ProgressStart) end
                RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
            elseif Actions.onActive then
                Actions.onActive()
            end
        end
    end

    RageUI.Options = Option
end
