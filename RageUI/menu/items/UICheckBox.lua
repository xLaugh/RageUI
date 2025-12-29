-- Constantes pré-extraites
local CB_RECT_H = 38
local CB_TEXT_X = 8
local CB_TEXT_Y = 3
local CB_TEXT_SCALE = 0.33
local CB_LBADGE_Y = -2
local CB_LBADGE_W = 40
local CB_LBADGE_H = 40
local CB_RBADGE_X = 385
local CB_RBADGE_Y = -2
local CB_RBADGE_W = 40
local CB_RBADGE_H = 40
local CB_RTEXT_X = 420
local CB_RTEXT_Y = 4
local CB_RTEXT_SCALE = 0.35
local CB_SEL_DICT = "commonmenu"
local CB_SEL_TEX = "gradient_nav"
local CB_SEL_W = 431
local CB_SEL_H = 38

local CHKBOX_DICT = "commonmenu"
local CHKBOX_X = 380
local CHKBOX_Y = -6
local CHKBOX_W = 50
local CHKBOX_H = 50
local CHKBOX_TEX = {
    "shop_box_blankb",
    "shop_box_tickb",
    "shop_box_blank",
    "shop_box_tick",
    "shop_box_crossb",
    "shop_box_cross",
}

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = CB_RECT_H },
    Text = { X = CB_TEXT_X, Y = CB_TEXT_Y, Scale = CB_TEXT_SCALE },
    LeftBadge = { Y = CB_LBADGE_Y, Width = CB_LBADGE_W, Height = CB_LBADGE_H },
    RightBadge = { X = CB_RBADGE_X, Y = CB_RBADGE_Y, Width = CB_RBADGE_W, Height = CB_RBADGE_H },
    RightText = { X = CB_RTEXT_X, Y = CB_RTEXT_Y, Scale = CB_RTEXT_SCALE },
    SelectedSprite = { Dictionary = CB_SEL_DICT, Texture = CB_SEL_TEX, Y = 0, Width = CB_SEL_W, Height = CB_SEL_H },
}

---@type table
local SettingsCheckbox = {
    Dictionary = CHKBOX_DICT, Textures = CHKBOX_TEX,
    X = CHKBOX_X, Y = CHKBOX_Y, Width = CHKBOX_W, Height = CHKBOX_H
}

RageUI.CheckboxStyle = {
    Tick = 1,
    Cross = 2
}

local function StyleCheckBox(Selected, Checked, Box, BoxSelect, OffSet, menuX, menuY, subH, widthOff, itemOff)
    local texIdx = Selected and (Checked and Box or 1) or (Checked and BoxSelect or 3)
    RenderSprite(CHKBOX_DICT, CHKBOX_TEX[texIdx], menuX + CHKBOX_X + widthOff - (OffSet or 0), menuY + CHKBOX_Y + subH + itemOff, CHKBOX_W, CHKBOX_H)
end

function RageUI.Checkbox(Label, Description, Checked, Style, Actions)
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

        local LeftBadgeOffset = (Style.LeftBadge == nil or Style.LeftBadge == RageUI.BadgeStyle.None) and 0 or 27
        local RightBadgeOffset = (Style.RightBadge == nil or Style.RightBadge == RageUI.BadgeStyle.None) and 0 or 32
        local BoxOffset = 0

        RageUI.ItemsSafeZone(CurrentMenu)

        local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton) or false

        if Selected then
            RenderSprite(CB_SEL_DICT, CB_SEL_TEX, menuX, menuY + subH + itemOff, CB_SEL_W + widthOff, CB_SEL_H)
        end

        local textColor = Selected and 0 or 245
        local isEnabled = Style.Enabled == true or Style.Enabled == nil

        if isEnabled then
            RenderText(Label, menuX + CB_TEXT_X + LeftBadgeOffset, menuY + CB_TEXT_Y + subH + itemOff, 0, CB_TEXT_SCALE, textColor, textColor, textColor, 255)

            if Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.LeftBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + CB_LBADGE_Y + subH + itemOff, CB_LBADGE_W, CB_LBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end
            if Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None then
                local badge = Style.RightBadge(Selected)
                local bc = badge.BadgeColour
                RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX + CB_RBADGE_X + widthOff, menuY + CB_RBADGE_Y + subH + itemOff, CB_RBADGE_W, CB_RBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
            end

            if Style.RightLabel and Style.RightLabel ~= "" then
                RenderText(Style.RightLabel, menuX + CB_RTEXT_X - RightBadgeOffset + widthOff, menuY + CB_RTEXT_Y + subH + itemOff, 0, CB_RTEXT_SCALE, textColor, textColor, textColor, 255, 2)
                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
            end
        else
            local LockBadge = RageUI.BadgeStyle.Lock
            local lockOffset = 27
            RenderText(Label, menuX + CB_TEXT_X + lockOffset, menuY + CB_TEXT_Y + subH + itemOff, 0, CB_TEXT_SCALE, Selected and 0 or 163, Selected and 0 or 159, Selected and 0 or 148, 255)
            local badge = LockBadge(Selected)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + CB_LBADGE_Y + subH + itemOff, CB_LBADGE_W, CB_LBADGE_H, 0, bc.R or 255, bc.G or 255, bc.B or 255, bc.A or 255)
        end

        BoxOffset = RightBadgeOffset + BoxOffset
        local checkStyle = Style.Style
        local box, boxSel = 2, 4
        if checkStyle == RageUI.CheckboxStyle.Cross then
            box, boxSel = 5, 6
        end
        StyleCheckBox(Selected, Checked, box, boxSel, BoxOffset, menuX, menuY, subH, widthOff, itemOff)

        if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and isEnabled then
            local Audio = RageUI.Settings.Audio
            RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
            Checked = not Checked
            if Checked then
                if Actions.onChecked then Actions.onChecked() end
            else
                if Actions.onUnChecked then Actions.onUnChecked() end
            end
        end

        RageUI.ItemOffset = itemOff + CB_RECT_H
        RageUI.ItemsDescription(CurrentMenu, Description, Selected)

        if Actions.onSelected and Selected then
            Actions.onSelected(Checked)
        end
    end

    RageUI.Options = Option
end
