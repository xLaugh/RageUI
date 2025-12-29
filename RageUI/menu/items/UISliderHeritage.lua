-- Constantes pré-extraites
local SLDR_RECT_H = 38
local SLDR_TEXT_X = 8
local SLDR_TEXT_Y = 3
local SLDR_TEXT_SCALE = 0.33
local SLDR_SEL_DICT = "commonmenu"
local SLDR_SEL_TEX = "gradient_nav"
local SLDR_SEL_W = 431
local SLDR_SEL_H = 38
local SLDR_BG_X = 250
local SLDR_BG_Y = 14.5
local SLDR_BG_W = 150
local SLDR_BG_H = 9
local SLDR_W = 75
local SLDR_DIV_X = 323.5
local SLDR_DIV_Y = 9
local SLDR_DIV_W = 2.5
local SLDR_DIV_H = 20
local SLDR_LA_DICT = "mpleaderboard"
local SLDR_LA_TEX = "leaderboard_male_icon"
local SLDR_LA_X = 215
local SLDR_LA_Y = 0
local SLDR_LA_W = 40
local SLDR_LA_H = 40
local SLDR_RA_TEX = "leaderboard_female_icon"
local SLDR_RA_X = 395

local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = SLDR_RECT_H },
}

local ITEMS_COUNT = 10
local SLIDER_STEP = (SLDR_BG_W - SLDR_W) / ITEMS_COUNT

function RageUI.UISliderHeritage(Label, ItemIndex, Description, Actions, Value)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end

    local Option = RageUI.Options + 1
    local pagination = CurrentMenu.Pagination

    if pagination.Minimum <= Option and pagination.Maximum >= Option then
        local value = Value or 0.1
        local Selected = CurrentMenu.Index == Option
        local menuX = CurrentMenu.X
        local menuY = CurrentMenu.Y
        local subH = CurrentMenu.SubtitleHeight
        local widthOff = CurrentMenu.WidthOffset
        local itemOff = RageUI.ItemOffset

        RageUI.ItemsSafeZone(CurrentMenu)

        local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton) or false
        local LeftArrowHovered, RightArrowHovered = false, false

        local baseY = menuY + subH + itemOff

        if Selected then
            RenderSprite(SLDR_SEL_DICT, SLDR_SEL_TEX, menuX, baseY, SLDR_SEL_W + widthOff, SLDR_SEL_H)
            local safeX, safeY = CurrentMenu.SafeZoneSize.X, CurrentMenu.SafeZoneSize.Y
            LeftArrowHovered = RageUI.IsMouseInBounds(menuX + SLDR_LA_X + safeX + widthOff, baseY + SLDR_LA_Y + safeY, SLDR_LA_W, SLDR_LA_H)
            RightArrowHovered = RageUI.IsMouseInBounds(menuX + SLDR_RA_X + safeX + widthOff, baseY + SLDR_LA_Y + safeY, SLDR_LA_W, SLDR_LA_H)
        end

        local textColor = Selected and 0 or 245
        local spriteAlpha = Selected and 0 or 255
        
        RenderText(Label, menuX + SLDR_TEXT_X, baseY + SLDR_TEXT_Y, 0, SLDR_TEXT_SCALE, textColor, textColor, textColor, 255)
        RenderSprite(SLDR_LA_DICT, SLDR_LA_TEX, menuX + SLDR_LA_X + widthOff, baseY + SLDR_LA_Y, SLDR_LA_W, SLDR_LA_H, 0, spriteAlpha, spriteAlpha, spriteAlpha, 255)
        RenderSprite(SLDR_LA_DICT, SLDR_RA_TEX, menuX + SLDR_RA_X + widthOff, baseY + SLDR_LA_Y, SLDR_LA_W, SLDR_LA_H, 0, spriteAlpha, spriteAlpha, spriteAlpha, 255)

        RenderRectangle(menuX + SLDR_BG_X + widthOff, baseY + SLDR_BG_Y, SLDR_BG_W, SLDR_BG_H, 4, 32, 57, 255)
        RenderRectangle(menuX + SLDR_BG_X + (SLIDER_STEP * ItemIndex) + widthOff, baseY + SLDR_BG_Y, SLDR_W, SLDR_BG_H, 57, 116, 200, 255)
        RenderRectangle(menuX + SLDR_DIV_X + widthOff, baseY + SLDR_DIV_Y, SLDR_DIV_W, SLDR_DIV_H, 245, 245, 245, 255)

        RageUI.ItemOffset = itemOff + SLDR_RECT_H
        RageUI.ItemsDescription(CurrentMenu, Description, Selected)

        if Selected then
            local controls = CurrentMenu.Controls
            local leftActive = controls.SliderLeft.Active or (controls.Click.Active and LeftArrowHovered)
            local rightActive = controls.SliderRight.Active or (controls.Click.Active and RightArrowHovered)
            local Audio = RageUI.Settings.Audio

            if leftActive and not rightActive then
                ItemIndex = ItemIndex - value
                if ItemIndex >= 0.1 then
                    RageUI.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
                else
                    ItemIndex = 0.0
                end
                if Actions.onSliderChange then Actions.onSliderChange(ItemIndex / 10, ItemIndex) end
            elseif rightActive and not leftActive then
                ItemIndex = ItemIndex + value
                if ItemIndex <= ITEMS_COUNT then
                    RageUI.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
                else
                    ItemIndex = 10
                end
                if Actions.onSliderChange then Actions.onSliderChange(ItemIndex / 10, ItemIndex) end
            end

            if controls.Select.Active or ((Hovered and controls.Click.Active) and not LeftArrowHovered and not RightArrowHovered) then
                if Actions.onSelected then Actions.onSelected(ItemIndex / 10, ItemIndex) end
                RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef, false)
            elseif Actions.onActive then
                Actions.onActive()
            end
        end
    end

    RageUI.Options = Option
end



