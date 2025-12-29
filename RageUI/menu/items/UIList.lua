-- Constantes pré-extraites
local LST_RECT_H = 38
local LST_TEXT_X = 8
local LST_TEXT_Y = 3
local LST_TEXT_SCALE = 0.33
local LST_LBADGE_Y = -2
local LST_LBADGE_W = 40
local LST_LBADGE_H = 40
local LST_RBADGE_X = 385
local LST_RBADGE_Y = -2
local LST_RBADGE_W = 40
local LST_RBADGE_H = 40
local LST_RTEXT_X = 420
local LST_RTEXT_Y = 4
local LST_RTEXT_SCALE = 0.35
local LST_SEL_DICT = "commonmenu"
local LST_SEL_TEX = "gradient_nav"
local LST_SEL_W = 431
local LST_SEL_H = 38
local LST_LIST_X = 403
local LST_LIST_Y = 3
local LST_LIST_SCALE = 0.35

local _strfmt = string.format

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = LST_RECT_H },
    Text = { X = LST_TEXT_X, Y = LST_TEXT_Y, Scale = LST_TEXT_SCALE },
    LeftBadge = { Y = LST_LBADGE_Y, Width = LST_LBADGE_W, Height = LST_LBADGE_H },
    RightBadge = { X = LST_RBADGE_X, Y = LST_RBADGE_Y, Width = LST_RBADGE_W, Height = LST_RBADGE_H },
    RightText = { X = LST_RTEXT_X, Y = LST_RTEXT_Y, Scale = LST_RTEXT_SCALE },
    SelectedSprite = { Dictionary = LST_SEL_DICT, Texture = LST_SEL_TEX, Y = 0, Width = LST_SEL_W, Height = LST_SEL_H },
}

---@type table
local SettingsList = {
    LeftArrow = { Dictionary = "commonmenu", Texture = "arrowleft", X = 378, Y = 3, Width = 30, Height = 30 },
    RightArrow = { Dictionary = "commonmenu", Texture = "arrowright", X = 400, Y = 3, Width = 30, Height = 30 },
    Text = { X = LST_LIST_X, Y = LST_LIST_Y, Scale = LST_LIST_SCALE },
}

function RageUI.List(Label, Items, Index, Description, Style, Enabled, Actions, Submenu)
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

        local item = Items[Index]
        local ListText = (type(item) == "table") and _strfmt("← %s →", item.Name) or _strfmt("← %s →", item) or "NIL"

        if Selected then
            RenderSprite(LST_SEL_DICT, LST_SEL_TEX, menuX, menuY + subH + itemOff, LST_SEL_W + widthOff, LST_SEL_H)
        end

        local isEnabled = Enabled == true or Enabled == nil
        local textColor = Selected and 0 or 245
        local disabledColor = 163

        if isEnabled then
            if Style.RightLabel and Style.RightLabel ~= "" then
                RenderText(Style.RightLabel, menuX + LST_RTEXT_X - RightBadgeOffset + widthOff, menuY + LST_RTEXT_Y + subH + itemOff, 0, LST_RTEXT_SCALE, textColor, textColor, textColor, 255, 2)
                RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
            end
        end

        RightOffset = RightBadgeOffset * 1.3 + RightOffset

        if isEnabled then
            RenderText(Label, menuX + LST_TEXT_X + LeftBadgeOffset, menuY + LST_TEXT_Y + subH + itemOff, 0, LST_TEXT_SCALE, textColor, textColor, textColor, 255)
            RenderText(ListText, menuX + LST_LIST_X + 15 + widthOff - RightOffset, menuY + LST_LIST_Y + subH + itemOff, 0, LST_LIST_SCALE, textColor, textColor, textColor, 255, 2)
        else
            RenderText(Label, menuX + LST_TEXT_X + LeftBadgeOffset, menuY + LST_TEXT_Y + subH + itemOff, 0, LST_TEXT_SCALE, disabledColor, 159, 148, 255)
            local listX = Selected and (menuX + LST_LIST_X + widthOff) or (menuX + LST_LIST_X + 15 + widthOff)
            RenderText(ListText, listX, menuY + LST_LIST_Y + subH + itemOff, 0, LST_LIST_SCALE, disabledColor, 159, 148, 255, 2)
        end

        local styleEnabled = Style.Enabled == true or Style.Enabled == nil
        if styleEnabled then
            if Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.LeftBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + LST_LBADGE_Y + subH + itemOff, LST_LBADGE_W, LST_LBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
            if Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.RightBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX + LST_RBADGE_X + widthOff, menuY + LST_RBADGE_Y + subH + itemOff, LST_RBADGE_W, LST_RBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
        else
            local LockBadge = RageUI.BadgeStyle.Lock
            local badge = LockBadge(Selected)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + LST_LBADGE_Y + subH + itemOff, LST_LBADGE_W, LST_LBADGE_H, 0, bc.R or 255, bc.G or 255, bc.B or 255, bc.A or 255)
        end

        local listTextWidth = MeasureStringWidth(ListText, 0, LST_LIST_SCALE)
        local LeftArrowHovered = RageUI.IsMouseInBounds(menuX + LST_LIST_X + widthOff - RightOffset + safeX, menuY + LST_LIST_Y + subH + itemOff + 2.5 + safeY, 15, 22.5)
        local RightArrowHovered = RageUI.IsMouseInBounds(menuX + LST_LIST_X + widthOff + safeX - RightOffset - listTextWidth, menuY + LST_LIST_Y + subH + itemOff + 2.5 + safeY, 15, 22.5)

        RageUI.ItemOffset = itemOff + LST_RECT_H
        RageUI.ItemsDescription(CurrentMenu, Description, Selected)

        local controls = CurrentMenu.Controls
        if Selected then
            local leftActive = controls.Left.Active or (controls.Click.Active and LeftArrowHovered)
            local rightActive = controls.Right.Active or (controls.Click.Active and RightArrowHovered)

            if leftActive and not rightActive then
                Index = Index - 1
                if Index < 1 then Index = #Items end
                if Actions.onListChange then Actions.onListChange(Index, Items[Index]) end
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
            elseif rightActive and not leftActive then
                Index = Index + 1
                if Index > #Items then Index = 1 end
                if Actions.onListChange then Actions.onListChange(Index, Items[Index]) end
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
            end

            if controls.Select.Active or ((Hovered and controls.Click.Active) and not LeftArrowHovered and not RightArrowHovered) then
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                if Actions.onSelected then Actions.onSelected(Index, Items[Index]) end
                if Submenu and type(Submenu) == "table" then
                    RageUI.NextMenu = Submenu[Index]
                end
            elseif Actions.onActive then
                Actions.onActive()
            end
        end
    end

    RageUI.Options = Option
end
