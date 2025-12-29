---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- RageUI Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see RageUI
---

-- Constantes pré-extraites
local SEP_RECT_H = 38
local SEP_TEXT_X = 8
local SEP_TEXT_Y = 3
local SEP_TEXT_SCALE = 0.33

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = SEP_RECT_H },
    Text = { X = SEP_TEXT_X, Y = SEP_TEXT_Y, Scale = SEP_TEXT_SCALE },
}

function RageUI.Separator(Label)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu == nil or not CurrentMenu() then return end

    local Option = RageUI.Options + 1
    local pagination = CurrentMenu.Pagination

    if pagination.Minimum <= Option and pagination.Maximum >= Option then
        if Label then
            local textX = CurrentMenu.X + SEP_TEXT_X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 200)
            RenderText(Label, textX, CurrentMenu.Y + SEP_TEXT_Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SEP_TEXT_SCALE, 245, 245, 245, 255, 1)
        end
        RageUI.ItemOffset = RageUI.ItemOffset + SEP_RECT_H
        if CurrentMenu.Index == Option then
            if RageUI.LastControl then
                CurrentMenu.Index = Option - 1
                if CurrentMenu.Index < 1 then
                    CurrentMenu.Index = RageUI.CurrentMenu.Options
                end
            else
                CurrentMenu.Index = Option + 1
            end
        end
    end
    RageUI.Options = Option
end