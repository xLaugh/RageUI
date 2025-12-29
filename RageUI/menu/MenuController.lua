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
                if CurrentMenu.onIndexChange then
                    CurrentMenu.onIndexChange(CurrentMenu.Index) -- Appel direct
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
                if CurrentMenu.onIndexChange then
                    CurrentMenu.onIndexChange(CurrentMenu.Index) -- Appel direct
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
    if not ctrl.Enabled or ctrl.Pressed then return end
    
    local keys = ctrl.Keys
    local len = #keys
    for i = 1, len do
        local key = keys[i]
        if _IsDisabledControlJustPressed(key[1], key[2]) then
            ctrl.Active = true
            ctrl.Pressed = true
            Citizen.SetTimeout(1, function()
                ctrl.Active = false
                Citizen.SetTimeout(175, function()
                    if ctrl.Enabled and _IsDisabledControlPressed(key[1], key[2]) then
                        Citizen.CreateThread(function()
                            while ctrl.Enabled and _IsDisabledControlPressed(key[1], key[2]) do
                                ctrl.Active = true
                                Citizen.Wait(1)
                                ctrl.Active = false
                                Citizen.Wait(100)
                            end
                            ctrl.Pressed = false
                        end)
                    else
                        ctrl.Pressed = false
                    end
                end)
            end)
            return
        end
    end
end

function RageUI.GoActionControlSlider(Controls, Action)
    local ctrl = Controls[Action]
    if not ctrl.Enabled or ctrl.Pressed then return end
    
    local keys = ctrl.Keys
    local len = #keys
    for i = 1, len do
        local key = keys[i]
        if _IsDisabledControlJustPressed(key[1], key[2]) then
            ctrl.Active = true
            ctrl.Pressed = true
            Citizen.CreateThread(function()
                Citizen.Wait(1)
                ctrl.Active = false
                while ctrl.Enabled and _IsDisabledControlPressed(key[1], key[2]) do
                    ctrl.Active = true
                    Citizen.Wait(1)
                    ctrl.Active = false
                end
                ctrl.Pressed = false
            end)
            return
        end
    end
end

-- Cache pour éviter de recréer des tables
local cachedInputDisabled = nil
local cachedInputFrame = -1

---Controls
---@return nil
---@public
function RageUI.Controls()
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() or not CurrentMenu.Open then return end

    local Controls = CurrentMenu.Controls
    local Options = CurrentMenu.Options
    RageUI.Options = Options

    -- Optimisation: vérifier l'état des contrôles une seule fois par frame
    local currentFrame = _GetFrameCount()
    if cachedInputFrame ~= currentFrame then
        local inputDisabled = _IsInputDisabled(2)
        if cachedInputDisabled ~= inputDisabled then
            local ctrlList = inputDisabled and Controls.Enabled.Keyboard or Controls.Enabled.Controller
            local len = #ctrlList
            for i = 1, len do
                local ctrl = ctrlList[i]
                _EnableControlAction(ctrl[1], ctrl[2], true)
            end
            cachedInputDisabled = inputDisabled
        end
        cachedInputFrame = currentFrame
    end

    -- Up control
    local ctrlUp = Controls.Up
    if ctrlUp.Enabled and not ctrlUp.Pressed then
        local keys = ctrlUp.Keys
        for i = 1, #keys do
            local key = keys[i]
            if _IsDisabledControlJustPressed(key[1], key[2]) then
                ctrlUp.Pressed = true
                Citizen.CreateThread(function()
                    RageUI.GoUp(Options)
                    Citizen.Wait(175)
                    while ctrlUp.Enabled and _IsDisabledControlPressed(key[1], key[2]) do
                        RageUI.GoUp(Options)
                        Citizen.Wait(50)
                    end
                    ctrlUp.Pressed = false
                end)
                break
            end
        end
    end

    -- Down control
    local ctrlDown = Controls.Down
    if ctrlDown.Enabled and not ctrlDown.Pressed then
        local keys = ctrlDown.Keys
        for i = 1, #keys do
            local key = keys[i]
            if _IsDisabledControlJustPressed(key[1], key[2]) then
                ctrlDown.Pressed = true
                Citizen.CreateThread(function()
                    RageUI.GoDown(Options)
                    Citizen.Wait(175)
                    while ctrlDown.Enabled and _IsDisabledControlPressed(key[1], key[2]) do
                        RageUI.GoDown(Options)
                        Citizen.Wait(50)
                    end
                    ctrlDown.Pressed = false
                end)
                break
            end
        end
    end

    -- Actions (Left, Right, Select, Click) - inline pour éviter les appels de fonction
    RageUI.GoActionControl(Controls, 'Left')
    RageUI.GoActionControl(Controls, 'Right')
    RageUI.GoActionControl(Controls, 'Select')
    RageUI.GoActionControl(Controls, 'Click')
    RageUI.GoActionControlSlider(Controls, 'SliderLeft')
    RageUI.GoActionControlSlider(Controls, 'SliderRight')

    -- Back control
    local ctrlBack = Controls.Back
    if ctrlBack.Enabled and not ctrlBack.Pressed then
        local keys = ctrlBack.Keys
        for i = 1, #keys do
            local key = keys[i]
            if _IsDisabledControlJustPressed(key[1], key[2]) then
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

---Navigation
---@return nil
---@public
function RageUI.Navigation()
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() or not CurrentMenu.Display.Navigation then return end
    
    if CurrentMenu.EnableMouse then
        _SetMouseCursorActiveThisFrame()
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
