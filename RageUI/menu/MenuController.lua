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

local _IsInputDisabled = IsInputDisabled
local _EnableControlAction = EnableControlAction
local _IsDisabledControlJustPressed = IsDisabledControlJustPressed
local _IsDisabledControlPressed = IsDisabledControlPressed
local _GetFrameCount = GetFrameCount
local _SetMouseCursorActiveThisFrame = SetMouseCursorActiveThisFrame

RageUI.LastControl = false

local ControlActions = {
    'Left',
    'Right',
    'Select',
    'Click',
}

---GoUp
---@param Options number
---@return nil
---@public
function RageUI.GoUp(Options)
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu ~= nil then
        Options = CurrentMenu.Options
        if CurrentMenu() then
            if (Options ~= 0) then
                if Options > CurrentMenu.Pagination.Total then
                    if CurrentMenu.Index <= CurrentMenu.Pagination.Minimum then
                        if CurrentMenu.Index == 1 then
                            CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
                            CurrentMenu.Pagination.Maximum = Options
                            CurrentMenu.Index = Options
                        else
                            CurrentMenu.Pagination.Minimum = (CurrentMenu.Pagination.Minimum - 1)
                            CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum - 1)
                            CurrentMenu.Index = CurrentMenu.Index - 1
                        end
                    else
                        CurrentMenu.Index = CurrentMenu.Index - 1
                    end
                else
                    if CurrentMenu.Index == 1 then
                        CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
                        CurrentMenu.Pagination.Maximum = Options
                        CurrentMenu.Index = Options
                    else
                        CurrentMenu.Index = CurrentMenu.Index - 1
                    end
                end

                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                RageUI.LastControl = true
                if (CurrentMenu.onIndexChange ~= nil) then
                    Citizen.CreateThread(function()
                        CurrentMenu.onIndexChange(CurrentMenu.Index)
                    end)
                end
            else
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function RageUI.GoDown(Options)
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu ~= nil then
        Options = CurrentMenu.Options
        if CurrentMenu() then
            if (Options ~= 0) then
                if Options > CurrentMenu.Pagination.Total then
                    if CurrentMenu.Index >= CurrentMenu.Pagination.Maximum then
                        if CurrentMenu.Index == Options then
                            CurrentMenu.Pagination.Minimum = 1
                            CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                            CurrentMenu.Index = 1
                        else
                            CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum + 1)
                            CurrentMenu.Pagination.Minimum = CurrentMenu.Pagination.Maximum - (CurrentMenu.Pagination.Total - 1)
                            CurrentMenu.Index = CurrentMenu.Index + 1
                        end
                    else
                        CurrentMenu.Index = CurrentMenu.Index + 1
                    end
                else
                    if CurrentMenu.Index == Options then
                        CurrentMenu.Pagination.Minimum = 1
                        CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                        CurrentMenu.Index = 1
                    else
                        CurrentMenu.Index = CurrentMenu.Index + 1
                    end
                end
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                RageUI.LastControl = false
                if (CurrentMenu.onIndexChange ~= nil) then
                    Citizen.CreateThread(function()
                        CurrentMenu.onIndexChange(CurrentMenu.Index)
                    end)
                end
            else
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function RageUI.GoActionControl(Controls, Action)
    local ctrl = Controls[Action or 'Left']
    if ctrl.Enabled then
        local keys = ctrl.Keys
        for Index = 1, #keys do
            if not ctrl.Pressed then
                if _IsDisabledControlJustPressed(keys[Index][1], keys[Index][2]) then
                    ctrl.Pressed = true
                    Citizen.CreateThread(function()
                        ctrl.Active = true
                        Citizen.Wait(0.01)
                        ctrl.Active = false
                        Citizen.Wait(175)
                        while ctrl.Enabled and _IsDisabledControlPressed(keys[Index][1], keys[Index][2]) do
                            ctrl.Active = true
                            Citizen.Wait(1)
                            ctrl.Active = false
                            Citizen.Wait(124)
                        end
                        ctrl.Pressed = false
                        if (Action ~= ControlActions[5]) then
                            Citizen.Wait(10)
                        end
                    end)
                    break
                end
            end
        end
    end
end

function RageUI.GoActionControlSlider(Controls, Action)
    local ctrl = Controls[Action]
    if ctrl.Enabled then
        local keys = ctrl.Keys
        for Index = 1, #keys do
            if not ctrl.Pressed then
                if _IsDisabledControlJustPressed(keys[Index][1], keys[Index][2]) then
                    ctrl.Pressed = true
                    Citizen.CreateThread(function()
                        ctrl.Active = true
                        Citizen.Wait(1)
                        ctrl.Active = false
                        while ctrl.Enabled and _IsDisabledControlPressed(keys[Index][1], keys[Index][2]) do
                            ctrl.Active = true
                            Citizen.Wait(1)
                            ctrl.Active = false
                        end
                        ctrl.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

---Controls
---@return nil
---@public
function RageUI.Controls()
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            if CurrentMenu.Open then

                local Controls = CurrentMenu.Controls;
                ---@type number
                local Options = CurrentMenu.Options
                RageUI.Options = CurrentMenu.Options
                if CurrentMenu.EnableMouse then
                    -- DisableAllControlActions(2)
                end

                local currentFrame = _GetFrameCount()
                local inputDisabled = _IsInputDisabled(2)
                if RageUI.Cache.InputDisabledFrame ~= currentFrame or RageUI.Cache.InputDisabled ~= inputDisabled then
                    if not inputDisabled then
                        local ctrlList = Controls.Enabled.Controller
                        for Index = 1, #ctrlList do
                            _EnableControlAction(ctrlList[Index][1], ctrlList[Index][2], true)
                        end
                    else
                        local ctrlList = Controls.Enabled.Keyboard
                        for Index = 1, #ctrlList do
                            _EnableControlAction(ctrlList[Index][1], ctrlList[Index][2], true)
                        end
                    end
                    RageUI.Cache.InputDisabled = inputDisabled
                    RageUI.Cache.InputDisabledFrame = currentFrame
                end

                local ctrlUp = Controls.Up
                if ctrlUp.Enabled then
                    local keys = ctrlUp.Keys
                    for Index = 1, #keys do
                        if not ctrlUp.Pressed then
                            if _IsDisabledControlJustPressed(keys[Index][1], keys[Index][2]) then
                                ctrlUp.Pressed = true
                                Citizen.CreateThread(function()
                                    RageUI.GoUp(Options)
                                    Citizen.Wait(175)
                                    while ctrlUp.Enabled and _IsDisabledControlPressed(keys[Index][1], keys[Index][2]) do
                                        RageUI.GoUp(Options)
                                        Citizen.Wait(50)
                                    end
                                    ctrlUp.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

                local ctrlDown = Controls.Down
                if ctrlDown.Enabled then
                    local keys = ctrlDown.Keys
                    for Index = 1, #keys do
                        if not ctrlDown.Pressed then
                            if _IsDisabledControlJustPressed(keys[Index][1], keys[Index][2]) then
                                ctrlDown.Pressed = true
                                Citizen.CreateThread(function()
                                    RageUI.GoDown(Options)
                                    Citizen.Wait(175)
                                    while ctrlDown.Enabled and _IsDisabledControlPressed(keys[Index][1], keys[Index][2]) do
                                        RageUI.GoDown(Options)
                                        Citizen.Wait(50)
                                    end
                                    ctrlDown.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

                for i = 1, #ControlActions do
                    RageUI.GoActionControl(Controls, ControlActions[i])
                end

                RageUI.GoActionControlSlider(Controls, 'SliderLeft')
                RageUI.GoActionControlSlider(Controls, 'SliderRight')

                local ctrlBack = Controls.Back
                if ctrlBack.Enabled then
                    local keys = ctrlBack.Keys
                    for Index = 1, #keys do
                        if not ctrlBack.Pressed then
                            if _IsDisabledControlJustPressed(keys[Index][1], keys[Index][2]) then
                                Controls.Back.Pressed = true
                                Citizen.CreateThread(function()
                                    Citizen.Wait(175)
                                    Controls.Down.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

            end
        end
    end
end

---Navigation
---@return nil
---@public
function RageUI.Navigation()
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() and (CurrentMenu.Display.Navigation) then
            if CurrentMenu.EnableMouse then
                _SetMouseCursorActiveThisFrame()
            end
            if RageUI.Options > CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not CurrentMenu.SafeZoneSize then
                    CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if CurrentMenu.Safezone then
                        CurrentMenu.SafeZoneSize = RageUI.GetSafeZoneBounds()

                        SetScriptGfxAlign(76, 84)
                        SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                if CurrentMenu.EnableMouse then
                    UpHovered = RageUI.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height)
                    DownHovered = RageUI.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height)

                    -- if CurrentMenu.Controls.Click.Active then
                    --     if UpHovered then
                    --         RageUI.GoUp(RageUI.Options)
                    --     elseif DownHovered then
                    --         RageUI.GoDown(RageUI.Options)
                    --     end
                    -- end

                    -- if UpHovered then
                    --     RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    -- else
                    --     RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    -- end

                    -- if DownHovered then
                    --     RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    -- else
                    --     RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    -- end
                -- else
                    --RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    --RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                --RenderSprite(RageUI.Settings.Items.Navigation.Arrows.Dictionary, RageUI.Settings.Items.Navigation.Arrows.Texture, CurrentMenu.X + RageUI.Settings.Items.Navigation.Arrows.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + RageUI.Settings.Items.Navigation.Arrows.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Arrows.Width, RageUI.Settings.Items.Navigation.Arrows.Height)
                --RageUI.ItemOffset = RageUI.ItemOffset + (RageUI.Settings.Items.Navigation.Rectangle.Height * 2)
            end
        end
    end
end

---GoBack
---@return nil
---@public
function RageUI.GoBack()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        local Audio = RageUI.Settings.Audio
        RageUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if CurrentMenu.Parent ~= nil then
            if CurrentMenu.Parent() then
                RageUI.NextMenu = CurrentMenu.Parent
            else
                RageUI.NextMenu = nil
                RageUI.Visible(CurrentMenu, false)
            end
        else
            RageUI.NextMenu = nil
            RageUI.Visible(CurrentMenu, false)
        end
    end
end
