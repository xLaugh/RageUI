-- Constantes pré-extraites
local SLDP_RECT_H = 38
local SLDP_TEXT_X = 8
local SLDP_TEXT_Y = 3
local SLDP_TEXT_SCALE = 0.33
local SLDP_LBADGE_Y = -2
local SLDP_LBADGE_W = 40
local SLDP_LBADGE_H = 40
local SLDP_RBADGE_X = 385
local SLDP_RBADGE_Y = -2
local SLDP_RBADGE_W = 40
local SLDP_RBADGE_H = 40
local SLDP_RTEXT_X = 420
local SLDP_RTEXT_Y = 4
local SLDP_RTEXT_SCALE = 0.35
local SLDP_SEL_DICT = "commonmenu"
local SLDP_SEL_TEX = "gradient_nav"
local SLDP_SEL_W = 431
local SLDP_SEL_H = 38

local SLDP_BG_X = 250
local SLDP_BG_Y = 14.5
local SLDP_BG_W = 150
local SLDP_BG_H = 9
local SLDP_ARROW_DICT = "commonmenutu"
local SLDP_LARROW_X = 235
local SLDP_LARROW_Y = 11.5
local SLDP_ARROW_W = 15
local SLDP_ARROW_H = 15
local SLDP_RARROW_X = 400
local SLDP_RARROW_Y = 11.5

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = SLDP_RECT_H },
    Text = { X = SLDP_TEXT_X, Y = SLDP_TEXT_Y, Scale = SLDP_TEXT_SCALE },
    LeftBadge = { Y = SLDP_LBADGE_Y, Width = SLDP_LBADGE_W, Height = SLDP_LBADGE_H },
    RightBadge = { X = SLDP_RBADGE_X, Y = SLDP_RBADGE_Y, Width = SLDP_RBADGE_W, Height = SLDP_RBADGE_H },
    RightText = { X = SLDP_RTEXT_X, Y = SLDP_RTEXT_Y, Scale = SLDP_RTEXT_SCALE },
    SelectedSprite = { Dictionary = SLDP_SEL_DICT, Texture = SLDP_SEL_TEX, Y = 0, Width = SLDP_SEL_W, Height = SLDP_SEL_H },
}

---@type table
local SettingsSlider = {
    Background = { X = SLDP_BG_X, Y = SLDP_BG_Y, Width = SLDP_BG_W, Height = SLDP_BG_H },
    Slider = { X = SLDP_BG_X, Y = SLDP_BG_Y, Width = SLDP_BG_W, Height = SLDP_BG_H },
    LeftArrow = { Dictionary = SLDP_ARROW_DICT, Texture = "arrowleft", X = SLDP_LARROW_X, Y = SLDP_LARROW_Y, Width = SLDP_ARROW_W, Height = SLDP_ARROW_H },
    RightArrow = { Dictionary = SLDP_ARROW_DICT, Texture = "arrowright", X = SLDP_RARROW_X, Y = SLDP_RARROW_Y, Width = SLDP_ARROW_W, Height = SLDP_ARROW_H },
}

function RageUI.SliderProgress(Label, ProgressStart, ProgressMax, Description, Style, Enabled, Actions)
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
            RenderSprite(SLDP_SEL_DICT, SLDP_SEL_TEX, menuX, menuY + subH + itemOff, SLDP_SEL_W + widthOff, SLDP_SEL_H)
            LeftArrowHovered = RageUI.IsMouseInBounds(menuX + SLDP_LARROW_X + safeX + widthOff, menuY + SLDP_LARROW_Y + safeY + subH + itemOff, SLDP_ARROW_W, SLDP_ARROW_H)
            RightArrowHovered = RageUI.IsMouseInBounds(menuX + SLDP_RARROW_X + safeX + widthOff, menuY + SLDP_RARROW_Y + safeY + subH + itemOff, SLDP_ARROW_W, SLDP_ARROW_H)
        end

        local isEnabled = Enabled == true or Enabled == nil
        local textColor = Selected and 0 or 245

        if isEnabled then
            if Style.RightLabel and Style.RightLabel ~= "" then
                RenderText(Style.RightLabel, menuX + SLDP_RTEXT_X - RightBadgeOffset + widthOff, menuY + SLDP_RTEXT_Y + subH + itemOff, 0, SLDP_RTEXT_SCALE, textColor, textColor, textColor, 255, 2)
                RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
            end
        end

        RightOffset = RightOffset + RightBadgeOffset

        if isEnabled then
            RenderText(Label, menuX + SLDP_TEXT_X + LeftBadgeOffset, menuY + SLDP_TEXT_Y + subH + itemOff, 0, SLDP_TEXT_SCALE, textColor, textColor, textColor, 255)
            if Selected then
                RenderSprite(SLDP_ARROW_DICT, "arrowleft", menuX + SLDP_LARROW_X + widthOff - RightOffset, menuY + SLDP_LARROW_Y + subH + itemOff, SLDP_ARROW_W, SLDP_ARROW_H, 0, 0, 0, 0, 255)
                RenderSprite(SLDP_ARROW_DICT, "arrowright", menuX + SLDP_RARROW_X + widthOff - RightOffset, menuY + SLDP_RARROW_Y + subH + itemOff, SLDP_ARROW_W, SLDP_ARROW_H, 0, 0, 0, 0, 255)
            end
        else
            RenderText(Label, menuX + SLDP_TEXT_X + LeftBadgeOffset, menuY + SLDP_TEXT_Y + subH + itemOff, 0, SLDP_TEXT_SCALE, 163, 159, 148, 255)
            if Selected then
                RenderSprite(SLDP_ARROW_DICT, "arrowleft", menuX + SLDP_LARROW_X + widthOff - RightOffset, menuY + SLDP_LARROW_Y + subH + itemOff, SLDP_ARROW_W, SLDP_ARROW_H, 163, 159, 148, 255)
                RenderSprite(SLDP_ARROW_DICT, "arrowright", menuX + SLDP_RARROW_X + widthOff - RightOffset, menuY + SLDP_RARROW_Y + subH + itemOff, SLDP_ARROW_W, SLDP_ARROW_H, 163, 159, 148, 255)
            end
        end

        local styleEnabled = Style.Enabled == true or Style.Enabled == nil
        if styleEnabled then
            if Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.LeftBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + SLDP_LBADGE_Y + subH + itemOff, SLDP_LBADGE_W, SLDP_LBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
            if Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.RightBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX + SLDP_RBADGE_X + widthOff, menuY + SLDP_RBADGE_Y + subH + itemOff, SLDP_RBADGE_W, SLDP_RBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
        else
            local LockBadge = RageUI.BadgeStyle.Lock
            local badge = LockBadge(Selected)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + SLDP_LBADGE_Y + subH + itemOff, SLDP_LBADGE_W, SLDP_LBADGE_H, 0, bc.R or 255, bc.G or 255, bc.B or 255, bc.A or 255)
        end

        -- Progress background & progress bar
        local bgColor = Style.ProgressBackgroundColor
        local pColor = Style.ProgressColor
        RenderRectangle(menuX + SLDP_BG_X + widthOff - RightOffset, menuY + SLDP_BG_Y + subH + itemOff, SLDP_BG_W, SLDP_BG_H, bgColor.R, bgColor.G, bgColor.B, bgColor.A)
        local progressW = (SLDP_BG_W / (ProgressMax - 1)) * (ProgressStart - 1)
        RenderRectangle(menuX + SLDP_BG_X + widthOff - RightOffset, menuY + SLDP_BG_Y + subH + itemOff, progressW, SLDP_BG_H, pColor.R, pColor.G, pColor.B, pColor.A)

        RageUI.ItemOffset = itemOff + SLDP_RECT_H
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
