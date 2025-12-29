-- Constantes pré-extraites pour éviter les accès répétés aux tables
local BTN_RECT_Y = 0
local BTN_RECT_W = 431
local BTN_RECT_H = 38
local BTN_TEXT_X = 8
local BTN_TEXT_Y = 3
local BTN_TEXT_SCALE = 0.33
local BTN_LBADGE_Y = -2
local BTN_LBADGE_W = 40
local BTN_LBADGE_H = 40
local BTN_RBADGE_X = 385
local BTN_RBADGE_Y = -2
local BTN_RBADGE_W = 40
local BTN_RBADGE_H = 40
local BTN_RTEXT_X = 420
local BTN_RTEXT_Y = 4
local BTN_RTEXT_SCALE = 0.35
local BTN_SEL_DICT = "commonmenu"
local BTN_SEL_TEX = "gradient_nav"

local _IsControlJustPressed = IsControlJustPressed

---@type table
local SettingsButton = {
    Rectangle = { Y = BTN_RECT_Y, Width = BTN_RECT_W, Height = BTN_RECT_H },
    Text = { X = BTN_TEXT_X, Y = BTN_TEXT_Y, Scale = BTN_TEXT_SCALE },
    LeftBadge = { Y = BTN_LBADGE_Y, Width = BTN_LBADGE_W, Height = BTN_LBADGE_H },
    RightBadge = { X = BTN_RBADGE_X, Y = BTN_RBADGE_Y, Width = BTN_RBADGE_W, Height = BTN_RBADGE_H },
    RightText = { X = BTN_RTEXT_X, Y = BTN_RTEXT_Y, Scale = BTN_RTEXT_SCALE },
    SelectedSprite = { Dictionary = BTN_SEL_DICT, Texture = BTN_SEL_TEX, Y = BTN_RECT_Y, Width = BTN_RECT_W, Height = BTN_RECT_H },
}

function RageUI.ResetFiltre()
    resultFiltre = nil
end

-- Fonction interne pour le rendu d'un bouton (évite la duplication de code)
local function RenderButtonItem(CurrentMenu, Label, Description, Style, Enabled, Action, Submenu, Option, Active)
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local subH = CurrentMenu.SubtitleHeight
    local widthOff = CurrentMenu.WidthOffset
    local itemOff = RageUI.ItemOffset
    local baseY = menuY + BTN_RECT_Y + subH + itemOff

    RageUI.ItemsSafeZone(CurrentMenu)

    local haveLeftBadge = Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None
    local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None) or (not Enabled and Style.LockBadge ~= RageUI.BadgeStyle.None)
    local LeftBadgeOffset = haveLeftBadge and 27 or 0
    local RightBadgeOffset = haveRightBadge and 32 or 0
    local spriteW = BTN_RECT_W + widthOff

    if Style.Color and Style.Color.BackgroundColor then
        local bg = Style.Color.BackgroundColor
        RenderRectangle(menuX, baseY, spriteW, BTN_RECT_H, bg[1], bg[2], bg[3], bg[4])
    end

    if Active then
        if Style.Color and Style.Color.HightLightColor then
            local hl = Style.Color.HightLightColor
            RenderRectangle(menuX, baseY, spriteW, BTN_RECT_H, hl[1], hl[2], hl[3], hl[4])
        else
            RenderSprite(BTN_SEL_DICT, BTN_SEL_TEX, menuX, baseY, spriteW, BTN_RECT_H)
        end
    end

    local textColor = Active and 0 or 245

    if Enabled then
        if haveLeftBadge and Style.LeftBadge then
            local badge = Style.LeftBadge(Active)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX, menuY + BTN_LBADGE_Y + subH + itemOff, BTN_LBADGE_W, BTN_LBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
        end
        if haveRightBadge and Style.RightBadge then
            local badge = Style.RightBadge(Active)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX + BTN_RBADGE_X + widthOff, menuY + BTN_RBADGE_Y + subH + itemOff, BTN_RBADGE_W, BTN_RBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
        end
        if Style.RightLabel then
            RenderText(Style.RightLabel, menuX + BTN_RTEXT_X - RightBadgeOffset + widthOff, menuY + BTN_RTEXT_Y + subH + itemOff, 0, BTN_RTEXT_SCALE, textColor, textColor, textColor, 255, 2)
        end
        RenderText(Label, menuX + BTN_TEXT_X + LeftBadgeOffset, menuY + BTN_TEXT_Y + subH + itemOff, 0, BTN_TEXT_SCALE, textColor, textColor, textColor, 255)
    else
        if haveRightBadge then
            local badge = RageUI.BadgeStyle.Lock(Active)
            local bc = badge.BadgeColour
            RenderSprite(badge.BadgeDictionary or "commonmenu", badge.BadgeTexture or "", menuX + BTN_RBADGE_X + widthOff, menuY + BTN_RBADGE_Y + subH + itemOff, BTN_RBADGE_W, BTN_RBADGE_H, 0, bc and bc.R or 255, bc and bc.G or 255, bc and bc.B or 255, bc and bc.A or 255)
        end
        RenderText(Label, menuX + BTN_TEXT_X + LeftBadgeOffset, menuY + BTN_TEXT_Y + subH + itemOff, 0, BTN_TEXT_SCALE, 163, 159, 148, 255)
    end

    RageUI.ItemOffset = itemOff + BTN_RECT_H
    RageUI.ItemsDescription(CurrentMenu, Description, Active)

    if Enabled then
        local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUI.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton)
        local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active

        if Action.onHovered and Hovered then
            Action.onHovered()
        end
        if Action.onActive and Active then
            Action.onActive()
        end
        if Selected then
            local Audio = RageUI.Settings.Audio
            RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
            if Action.onSelected then
                Action.onSelected() -- Appel direct sans thread
            end
            if Submenu and Submenu() then
                RageUI.NextMenu = Submenu
            end
        end
    end
end

function RageUI.Button(Label, Description, Style, Enabled, Action, Submenu)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu == nil or not CurrentMenu() then return end

    if _IsControlJustPressed(1, 23) and CurrentMenu.Display.AcceptFilter then
        resultFiltre = AddFiltre()
    end

    local acceptFilter = CurrentMenu.Display.AcceptFilter
    if acceptFilter and not isAcceptByFiltre(Label) then
        return
    end

    local Option = RageUI.Options + 1
    local pagination = CurrentMenu.Pagination

    if pagination.Minimum <= Option and pagination.Maximum >= Option then
        local Active = CurrentMenu.Index == Option
        RenderButtonItem(CurrentMenu, Label, Description, Style, Enabled, Action, Submenu, Option, Active)
    end

    RageUI.Options = Option
end

function AddFiltre()
    local resultFiltre = KeyboardInput("Filtre", 30)
    if resultFiltre ~= nil then
        if not string.match(resultFiltre, "%w") then
            resultFiltre = nil
        else
            return resultFiltre
        end
    else
        resultFiltre = nil
    end
end

function isAcceptByFiltre(label)
    if resultFiltre == nil then
        return true
    end

    valueFiltre = string.find(label:lower(), resultFiltre:lower())
    
    if valueFiltre ~= nil then
        return true
    end

    return false
end