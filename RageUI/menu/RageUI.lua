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

-- Localisation des fonctions pour performances
local _GetFrameCount = GetFrameCount
local _GetSafeZoneSize = GetSafeZoneSize
local _GetControlNormal = GetControlNormal
local _IsInputDisabled = IsInputDisabled
local _SetScriptGfxAlign = SetScriptGfxAlign
local _SetScriptGfxAlignParams = SetScriptGfxAlignParams
local _ResetScriptGfxAlign = ResetScriptGfxAlign
local _DrawScaleformMovieFullscreen = DrawScaleformMovieFullscreen
local _IsDisabledControlJustPressed = IsDisabledControlJustPressed
local _IsDisabledControlPressed = IsDisabledControlPressed
local _EnableControlAction = EnableControlAction
local _floor = math.floor

function math.round(num, numDecimalPlaces)
    if not numDecimalPlaces or numDecimalPlaces == 0 then
        return _floor(num + 0.5)
    end
    local mult = 10 ^ numDecimalPlaces
    return _floor(num * mult + 0.5) / mult
end

function string.starts(String, Start)
    return string.sub(String, 1, #Start) == Start
end

---@class RageUIMenus
RageUI.Menus = setmetatable({}, RageUI.Menus)

---@type table
---@return boolean
RageUI.Menus.__call = function()
    return true
end

---@type table
RageUI.Menus.__index = RageUI.Menus

---@type table
RageUI.CurrentMenu = nil

---@type table
RageUI.NextMenu = nil

---@type number
RageUI.Options = 0

---@type number
RageUI.ItemOffset = 0

---@type number
RageUI.StatisticPanelCount = 0

--- Cache pour optimisations
RageUI.Cache = {
    SafeZoneBounds = nil,
    SafeZoneFrame = 0,
    MousePosition = { X = 0, Y = 0 },
    MouseFrame = 0,
    InputDisabled = nil,
    InputDisabledFrame = 0,
    KeyboardState = nil,
    KeyboardStateFrame = 0,
}

---@class UISize
RageUI.UI = {
    Current = "NativeUI",
    Style = {
        RageUI = {
            Width = 0
        },
        NativeUI = {
            Width = 0
        }
    }
}

---@class Settings
RageUI.Settings = {
    Debug = false,
    Controls = {
        Up = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 172 },
                { 1, 172 },
                { 2, 172 },
                { 0, 241 },
                { 1, 241 },
                { 2, 241 },
            },
        },
        Down = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 173 },
                { 1, 173 },
                { 2, 173 },
                { 0, 242 },
                { 1, 242 },
                { 2, 242 },
            },
        },
        Left = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 174 },
                { 1, 174 },
                { 2, 174 },
            },
        },
        Right = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 175 },
                { 1, 175 },
                { 2, 175 },
            },
        },
        SliderLeft = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 174 },
                { 1, 174 },
                { 2, 174 },
            },
        },
        SliderRight = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 175 },
                { 1, 175 },
                { 2, 175 },
            },
        },
        Select = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 201 },
                { 1, 201 },
                { 2, 201 },
            },
        },
        Back = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 177 },
                { 1, 177 },
                { 2, 177 },
                { 0, 199 },
                { 1, 199 },
                { 2, 199 },
            },
        },
        Click = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 24 },
            },
        },
        Enabled = {
            Controller = {
                { 0, 2 }, -- Look Up and Down
                { 0, 1 }, -- Look Left and Right
                { 0, 25 }, -- Aim
                { 0, 24 }, -- Attack
            },
            Keyboard = {
                { 0, 201 }, -- Select
                { 0, 195 }, -- X axis
                { 0, 196 }, -- Y axis
                { 0, 187 }, -- Down
                { 0, 188 }, -- Up
                { 0, 189 }, -- Left
                { 0, 190 }, -- Right
                { 0, 202 }, -- Back
                { 0, 217 }, -- Select
                { 0, 242 }, -- Scroll down
                { 0, 241 }, -- Scroll up
                { 0, 239 }, -- Cursor X
                { 0, 240 }, -- Cursor Y
                { 0, 31 }, -- Move Up and Down
                { 0, 30 }, -- Move Left and Right
                { 0, 21 }, -- Sprint
                { 0, 22 }, -- Jump
                { 0, 23 }, -- Enter
                { 0, 75 }, -- Exit Vehicle
                { 0, 71 }, -- Accelerate Vehicle
                { 0, 72 }, -- Vehicle Brake
                { 0, 59 }, -- Move Vehicle Left and Right
                { 0, 89 }, -- Fly Yaw Left
                { 0, 9 }, -- Fly Left and Right
                { 0, 8 }, -- Fly Up and Down
                { 0, 90 }, -- Fly Yaw Right
                { 0, 76 }, -- Vehicle Handbrake
            },
        },
    },
    Audio = {
        Id = nil,
        Use = "NativeUI",
        RageUI = {
            UpDown = {
                audioName = "HUD_FREEMODE_SOUNDSET",
                audioRef = "NAV_UP_DOWN",
            },
            LeftRight = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_LEFT_RIGHT",
            },
            Select = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "SELECT",
            },
            Back = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "BACK",
            },
            Error = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "ERROR",
            },
            Slider = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "CONTINUOUS_SLIDER",
                Id = nil
            },
        },
        NativeUI = {
            UpDown = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_UP_DOWN",
            },
            LeftRight = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_LEFT_RIGHT",
            },
            Select = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "SELECT",
            },
            Back = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "BACK",
            },
            Error = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "ERROR",
            },
            Slider = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "CONTINUOUS_SLIDER",
                Id = nil
            },
        }
    },
    Items = {
        Title = {
            Background = { Width = 431, Height = 107 },
            Text = { X = 215, Y = 20, Scale = 1.15 },
        },
        Subtitle = {
            Background = { Width = 431, Height = 37 },
            Text = { X = 8, Y = 3, Scale = 0.35 },
            PreText = { X = 425, Y = 3, Scale = 0.35 },
        },
        Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 0, Width = 431 },
        Navigation = {
            Rectangle = { Width = 431, Height = 18 },
            Offset = 5,
            Arrows = { Dictionary = "commonmenu", Texture = "shop_arrows_upanddown", X = 190, Y = -6, Width = 50, Height = 50 },
        },
        Description = {
            Bar = { Y = 4, Width = 431, Height = 4 },
            Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 30 },
            Text = { X = 8, Y = 10, Scale = 0.35 },
        },
    },
    Panels = {
        Grid = {
            Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 275 },
            Grid = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "nose_grid", X = 115.5, Y = 47.5, Width = 200, Height = 200 },
            Circle = { Dictionary = "mpinventory", Texture = "in_world_circle", X = 115.5, Y = 47.5, Width = 20, Height = 20 },
            Text = {
                Top = { X = 215.5, Y = 15, Scale = 0.35 },
                Bottom = { X = 215.5, Y = 250, Scale = 0.35 },
                Left = { X = 57.75, Y = 130, Scale = 0.35 },
                Right = { X = 373.25, Y = 130, Scale = 0.35 },
            },
        },
        Percentage = {
            Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76 },
            Bar = { X = 9, Y = 50, Width = 413, Height = 10 },
            Text = {
                Left = { X = 25, Y = 15, Scale = 0.35 },
                Middle = { X = 215.5, Y = 15, Scale = 0.35 },
                Right = { X = 398, Y = 15, Scale = 0.35 },
            },
        },
    },
}

function RageUI.SetScaleformParams(scaleform, data)
    data = data or {}
    for k, v in pairs(data) do
        PushScaleformMovieFunction(scaleform, v.name)
        if v.param then
            for _, par in pairs(v.param) do
                if math.type(par) == "integer" then
                    PushScaleformMovieFunctionParameterInt(par)
                elseif type(par) == "boolean" then
                    PushScaleformMovieFunctionParameterBool(par)
                elseif math.type(par) == "float" then
                    PushScaleformMovieFunctionParameterFloat(par)
                elseif type(par) == "string" then
                    PushScaleformMovieFunctionParameterString(par)
                end
            end
        end
        if v.func then
            v.func()
        end
        PopScaleformMovieFunctionVoid()
    end
end

function RageUI.IsMouseInBounds(X, Y, Width, Height)
    local currentFrame = _GetFrameCount()
    if RageUI.Cache.MouseFrame ~= currentFrame then
        RageUI.Cache.MousePosition.X = math.round(_GetControlNormal(2, 239) * 1920) / 1920
        RageUI.Cache.MousePosition.Y = math.round(_GetControlNormal(2, 240) * 1080) / 1080
        RageUI.Cache.MouseFrame = currentFrame
    end
    local MX, MY = RageUI.Cache.MousePosition.X, RageUI.Cache.MousePosition.Y
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

function RageUI.GetSafeZoneBounds()
    local currentFrame = _GetFrameCount()
    if not RageUI.Cache.SafeZoneBounds or (currentFrame - RageUI.Cache.SafeZoneFrame) > 60 then
        local SafeSize = _GetSafeZoneSize()
        SafeSize = math.round(SafeSize, 2)
        SafeSize = (SafeSize * 100) - 90
        SafeSize = 10 - SafeSize

        local W, H = 1920, 1080

        RageUI.Cache.SafeZoneBounds = { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
        RageUI.Cache.SafeZoneFrame = currentFrame
    end
    return RageUI.Cache.SafeZoneBounds
end

function RageUI.Visible(Menu, Value)
    if Menu ~= nil and Menu() then
        if Value == true or Value == false then
            if Value then
                if RageUI.CurrentMenu ~= nil then
                    if RageUI.CurrentMenu.Closed ~= nil then
                        RageUI.CurrentMenu.Closed()
                    end
                    RageUI.CurrentMenu.Open = not Value
                    Menu:UpdateInstructionalButtons(Value);
                    Menu:UpdateCursorStyle();

                end
                RageUI.CurrentMenu = Menu
            else
                RageUI.CurrentMenu = nil
            end
            Menu.Open = Value
            RageUI.Options = 0
            RageUI.ItemOffset = 0
            RageUI.LastControl = false
        else
            return Menu.Open
        end
    end
end

function RageUI.CloseAll()
    if RageUI.CurrentMenu ~= nil then
        local parent = RageUI.CurrentMenu.Parent
        while parent ~= nil do
            parent.Index = 1
            parent.Pagination.Minimum = 1
            parent.Pagination.Maximum = parent.Pagination.Total
            parent = parent.Parent
        end
        RageUI.CurrentMenu.Index = 1
        RageUI.CurrentMenu.Pagination.Minimum = 1
        RageUI.CurrentMenu.Pagination.Maximum = RageUI.CurrentMenu.Pagination.Total
        RageUI.CurrentMenu.Open = false
        RageUI.CurrentMenu = nil
    end
    RageUI.Options = 0
    RageUI.ItemOffset = 0
    ResetScriptGfxAlign()
end

-- Cache pour le scaleform du glare
local glareScaleform = nil
local _RequestScaleformMovie = RequestScaleformMovie
local _HasScaleformMovieLoaded = HasScaleformMovieLoaded
local _DrawScaleformMovie = DrawScaleformMovie
local _GetGameplayCamRelativeHeading = GetGameplayCamRelativeHeading

-- Constantes pré-calculées pour Banner
local TITLE_BG_W = 431
local TITLE_BG_H = 107
local TITLE_TEXT_X = 215
local TITLE_TEXT_Y = 20

function RageUI.Banner()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu == nil or not CurrentMenu() or not CurrentMenu.Display.Header then return end

    RageUI.ItemsSafeZone(CurrentMenu)
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local bgW = TITLE_BG_W + widthOff

    local sprite = CurrentMenu.Sprite
    if sprite and sprite.Dictionary then
        if sprite.Dictionary == "commonmenu" then
            local c = sprite.Color
            RenderSprite(sprite.Dictionary, sprite.Texture, menuX, menuY, bgW, TITLE_BG_H, c.R, c.G, c.B, c.A)
        else
            RenderSprite(sprite.Dictionary, sprite.Texture, menuX, menuY, bgW, TITLE_BG_H, nil)
        end
    else
        local rect = CurrentMenu.Rectangle
        RenderRectangle(menuX, menuY, bgW, TITLE_BG_H, rect.R, rect.G, rect.B, rect.A)
    end

    if CurrentMenu.Display.Glare then
        if not glareScaleform or not _HasScaleformMovieLoaded(glareScaleform) then
            glareScaleform = _RequestScaleformMovie("MP_MENU_GLARE")
        end
        if _HasScaleformMovieLoaded(glareScaleform) then
            local szX = CurrentMenu.SafeZoneSize.X
            local GlareX = menuX / 1920 + (szX / (64.399 - (widthOff * 0.065731)))
            local GlareY = menuY / 1080 + CurrentMenu.SafeZoneSize.Y / 33.195020746888
            RageUI.SetScaleformParams(glareScaleform, {
                { name = "SET_DATA_SLOT", param = { _GetGameplayCamRelativeHeading() } }
            })
            _DrawScaleformMovie(glareScaleform, GlareX, GlareY, TITLE_BG_W / 430, TITLE_BG_H / 100, 255, 255, 255, 255, 0)
        end
    end

    RenderText(CurrentMenu.Title, menuX + TITLE_TEXT_X + (widthOff / 2), menuY + TITLE_TEXT_Y, CurrentMenu.TitleFont, CurrentMenu.TitleScale, 255, 255, 255, 255, 1)
    RageUI.ItemOffset = RageUI.ItemOffset + TITLE_BG_H
end

-- Constantes Subtitle
local SUB_BG_W = 431
local SUB_BG_H = 37
local SUB_TEXT_X = 8
local SUB_TEXT_Y = 3
local SUB_TEXT_SCALE = 0.35
local SUB_PRETEXT_X = 425
local SUB_PRETEXT_Y = 3
local SUB_PRETEXT_SCALE = 0.35

function RageUI.Subtitle()
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() or not CurrentMenu.Display.Subtitle then return end
    if CurrentMenu.Subtitle == "" then return end

    RageUI.ItemsSafeZone(CurrentMenu)
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local itemOff = RageUI.ItemOffset
    
    RenderRectangle(menuX, menuY + itemOff, SUB_BG_W + widthOff, SUB_BG_H + CurrentMenu.SubtitleHeight, 0, 0, 0, 255)
    RenderText(CurrentMenu.PageCounterColour .. CurrentMenu.Subtitle, menuX + SUB_TEXT_X, menuY + SUB_TEXT_Y + itemOff, 0, SUB_TEXT_SCALE, 245, 245, 245, 255, nil, false, false, SUB_BG_W + widthOff)
    
    local idx = CurrentMenu.Index
    local opts = CurrentMenu.Options
    if idx > opts or idx < 0 then
        CurrentMenu.Index = 1
        idx = 1
    end
    
    local pagination = CurrentMenu.Pagination
    if idx > pagination.Total then
        local offset = idx - pagination.Total
        pagination.Minimum = 1 + offset
        pagination.Maximum = pagination.Total + offset
    else
        pagination.Minimum = 1
        pagination.Maximum = pagination.Total
    end
    
    if CurrentMenu.Display.PageCounter then
        local pageText = CurrentMenu.PageCounter or (CurrentMenu.PageCounterColour .. idx .. " / " .. opts)
        RenderText(pageText, menuX + SUB_PRETEXT_X + widthOff, menuY + SUB_PRETEXT_Y + itemOff, 0, SUB_PRETEXT_SCALE, 245, 245, 245, 255, 2)
    end
    
    RageUI.ItemOffset = itemOff + SUB_BG_H
end

-- Constantes Background
local BG_DICT = "commonmenu"
local BG_TEX = "gradient_bgd"
local BG_Y = 0
local BG_W = 431

-- Constantes Description
local DESC_BAR_Y = 4
local DESC_BAR_W = 431
local DESC_BAR_H = 4
local DESC_BG_Y = 4
local DESC_BG_W = 431
local DESC_BG_H = 30
local DESC_TEXT_X = 8
local DESC_TEXT_Y = 10
local DESC_TEXT_SCALE = 0.35

local _SetScriptGfxDrawOrder = SetScriptGfxDrawOrder

function RageUI.Background()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu == nil or not CurrentMenu() or not CurrentMenu.Display.Background then return end

    RageUI.ItemsSafeZone(CurrentMenu)
    _SetScriptGfxDrawOrder(0)
    RenderSprite(BG_DICT, BG_TEX, CurrentMenu.X, CurrentMenu.Y + BG_Y + CurrentMenu.SubtitleHeight, BG_W + CurrentMenu.WidthOffset, RageUI.ItemOffset, 0, 0, 0, 0, 255)
    _SetScriptGfxDrawOrder(1)
end

function RageUI.Description()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu == nil or CurrentMenu.Description == nil or not CurrentMenu() then return end

    RageUI.ItemsSafeZone(CurrentMenu)
    local menuX = CurrentMenu.X
    local baseY = CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset
    local widthOff = CurrentMenu.WidthOffset

    RenderRectangle(menuX, baseY + DESC_BAR_Y, DESC_BAR_W + widthOff, DESC_BAR_H, 0, 0, 0, 255)
    RenderSprite(BG_DICT, BG_TEX, menuX, baseY + DESC_BG_Y, DESC_BG_W + widthOff, CurrentMenu.DescriptionHeight, 0, 0, 0, 255)
    RenderText(CurrentMenu.Description, menuX + DESC_TEXT_X, baseY + DESC_TEXT_Y, 0, DESC_TEXT_SCALE, 255, 255, 255, 255, nil, false, false, DESC_BG_W + widthOff - 8.0)
    RageUI.ItemOffset = RageUI.ItemOffset + CurrentMenu.DescriptionHeight + DESC_BAR_Y
end

local _DrawScaleformMovieFullscreenRender = DrawScaleformMovieFullscreen

function RageUI.Render()
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end

    if CurrentMenu.Safezone then
        _ResetScriptGfxAlign()
    end

    if CurrentMenu.Display.InstructionalButton then
        if not CurrentMenu.InitScaleform then
            CurrentMenu:UpdateInstructionalButtons(true)
            CurrentMenu.InitScaleform = true
        end
        _DrawScaleformMovieFullscreenRender(CurrentMenu.InstructionalScaleform, 255, 255, 255, 255, 0)
    end

    CurrentMenu.Options = RageUI.Options
    CurrentMenu.SafeZoneSize = nil
    RageUI.Controls()
    RageUI.Options = 0
    RageUI.StatisticPanelCount = 0
    RageUI.ItemOffset = 0

    local Controls = CurrentMenu.Controls
    if Controls.Back.Enabled and Controls.Back.Pressed then
        Controls.Back.Pressed = false
        if CurrentMenu.Closable then
            local Audio = RageUI.Settings.Audio
            RageUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)

            if CurrentMenu.Closed then
                CurrentMenu.Closed()
            end

            local parent = CurrentMenu.Parent
            if parent and parent() then
                RageUI.NextMenu = parent
                CurrentMenu:UpdateCursorStyle()
            else
                RageUI.NextMenu = nil
                RageUI.Visible(CurrentMenu, false)
            end
        end
    end

    local nextMenu = RageUI.NextMenu
    if nextMenu and nextMenu() then
        RageUI.Visible(CurrentMenu, false)
        RageUI.Visible(nextMenu, true)
        Controls.Select.Active = false
        RageUI.NextMenu = nil
        RageUI.LastControl = false
    end
end

-- Constantes description
local DESC_SETTINGS_TEXT_X = 8
local DESC_SETTINGS_TEXT_Y = 10
local DESC_SETTINGS_TEXT_SCALE = 0.35
local DESC_SETTINGS_BG_H = 30

function RageUI.ItemsDescription(CurrentMenu, Description, Selected)
    if not Selected or not Description or Description == "" then return end
    if CurrentMenu.Description == Description then return end
    
    CurrentMenu.Description = Description
    local DescriptionLineCount = GetLineCount(
        Description, 
        CurrentMenu.X + DESC_SETTINGS_TEXT_X, 
        CurrentMenu.Y + DESC_SETTINGS_TEXT_Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 
        0, 
        DESC_SETTINGS_TEXT_SCALE, 
        255, 255, 255, 255, 
        nil, false, false, 
        431 + (CurrentMenu.WidthOffset - 5.0)
    )
    CurrentMenu.DescriptionHeight = DescriptionLineCount > 1 and (DESC_SETTINGS_BG_H * DescriptionLineCount) or (DESC_SETTINGS_BG_H + 7)
end

function RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton)
    if not CurrentMenu.EnableMouse then return false end
    
    local safeZone = CurrentMenu.SafeZoneSize
    local rectY = SettingsButton.Rectangle.Y
    local baseY = CurrentMenu.Y + rectY + CurrentMenu.SubtitleHeight + RageUI.ItemOffset
    
    local Hovered = RageUI.IsMouseInBounds(
        CurrentMenu.X + safeZone.X, 
        baseY + safeZone.Y, 
        SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, 
        SettingsButton.Rectangle.Height
    )
    
    if Hovered and not Selected then
        RenderRectangle(CurrentMenu.X, baseY, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height, 255, 255, 255, 20)
        if CurrentMenu.Controls.Click.Active then
            CurrentMenu.Index = Option
            local Audio = RageUI.Settings.Audio
            RageUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
        end
    end
    return Hovered
end

-- Cache local pour éviter les recalculs
local _safeZoneInitialized = false

function RageUI.ItemsSafeZone(CurrentMenu)
    if CurrentMenu.SafeZoneSize then return end
    
    CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }
    if CurrentMenu.Safezone then
        CurrentMenu.SafeZoneSize = RageUI.GetSafeZoneBounds()
        _SetScriptGfxAlign(76, 84)
        _SetScriptGfxAlignParams(0, 0, 0, 0)
    end
end

function RageUI.CurrentIsEqualTo(Current, To, Style, DefaultStyle)
    return Current == To and Style or DefaultStyle or {};
end

local _UpdateOnscreenKeyboard = UpdateOnscreenKeyboard

function RageUI.IsVisible(Menu, Items, Panels)
    if not RageUI.Visible(Menu) then return end
    
    local keyboardState = _UpdateOnscreenKeyboard()
    if keyboardState == 0 or keyboardState == 3 then return end
    
    RageUI.Banner()
    RageUI.Subtitle()
    if Items then Items() end
    RageUI.Background()
    RageUI.Navigation()
    RageUI.Description()
    if Panels then Panels() end
    RageUI.Render()
end

---SetStyleAudio
---@param StyleAudio string
---@return void
---@public
function RageUI.SetStyleAudio(StyleAudio)
    RageUI.Settings.Audio.Use = StyleAudio or "RageUI"
end

function RageUI.GetStyleAudio()
    return RageUI.Settings.Audio.Use or "RageUI"
end