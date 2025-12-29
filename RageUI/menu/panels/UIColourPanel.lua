-- Constantes pré-extraites
local CLR_BG_DICT = "commonmenu"
local CLR_BG_TEX = "gradient_bgd"
local CLR_BG_Y = 4
local CLR_BG_W = 431
local CLR_BG_H = 112
local CLR_LA_X = 7.5
local CLR_LA_Y = 15
local CLR_ARR_W = 30
local CLR_ARR_H = 30
local CLR_RA_X = 393.5
local CLR_HDR_X = 215.5
local CLR_HDR_Y = 15
local CLR_HDR_SCALE = 0.35
local CLR_BOX_X = 15
local CLR_BOX_Y = 55
local CLR_BOX_W = 44.5
local CLR_BOX_H = 44.5
local CLR_SEL_X = 15
local CLR_SEL_Y = 47
local CLR_SEL_W = 44.5
local CLR_SEL_H = 8

local _unpack = table.unpack

function RageUI.ColourPanel(Title, Colours, MinimumIndex, CurrentIndex, Action, Index, Style)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() or CurrentMenu.Index ~= Index then return end
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local safeX = CurrentMenu.SafeZoneSize.X
    local safeY = CurrentMenu.SafeZoneSize.Y
    local halfWidth = widthOff * 0.5
    local baseY = menuY + subH + itemOff
    
    local Maximum = (#Colours > 9) and 9 or #Colours
    
    local boxBaseX = menuX + CLR_BOX_X + halfWidth
    local boxBaseY = baseY + CLR_BOX_Y
    
    local Hovered = RageUI.IsMouseInBounds(boxBaseX + safeX, boxBaseY + safeY, CLR_BOX_W * Maximum, CLR_BOX_H)
    local LeftArrowHovered = RageUI.IsMouseInBounds(menuX + CLR_LA_X + safeX + halfWidth, baseY + CLR_LA_Y + safeY, CLR_ARR_W, CLR_ARR_H)
    local RightArrowHovered = RageUI.IsMouseInBounds(menuX + CLR_RA_X + safeX + halfWidth, baseY + CLR_LA_Y + safeY, CLR_ARR_W, CLR_ARR_H)
    
    RenderSprite(CLR_BG_DICT, CLR_BG_TEX, menuX, baseY + CLR_BG_Y, CLR_BG_W + widthOff, CLR_BG_H)
    RenderSprite(CLR_BG_DICT, "arrowleft", menuX + CLR_LA_X + halfWidth, baseY + CLR_LA_Y, CLR_ARR_W, CLR_ARR_H)
    RenderSprite(CLR_BG_DICT, "arrowright", menuX + CLR_RA_X + halfWidth, baseY + CLR_LA_Y, CLR_ARR_W, CLR_ARR_H)
    
    RenderRectangle(menuX + CLR_SEL_X + (CLR_BOX_W * (CurrentIndex - MinimumIndex)) + halfWidth, baseY + CLR_SEL_Y, CLR_SEL_W, CLR_SEL_H, 245, 245, 245, 255)
    
    for i = 1, Maximum do
        RenderRectangle(boxBaseX + (CLR_BOX_W * (i - 1)), boxBaseY, CLR_BOX_W, CLR_BOX_H, _unpack(Colours[MinimumIndex + i - 1]))
    end
    
    local sepText = (type(Style) == "table" and type(Style.Seperator) == "table") and Style.Seperator.Text or "of"
    RenderText((Title or "") .. " (" .. CurrentIndex .. " " .. sepText .. " " .. #Colours .. ")", menuX + CLR_HDR_X + halfWidth, baseY + CLR_HDR_Y, 0, CLR_HDR_SCALE, 245, 245, 245, 255, 1)
    
    if (Hovered or LeftArrowHovered or RightArrowHovered) and RageUI.Settings.Controls.Click.Active then
        if LeftArrowHovered then
            CurrentIndex = CurrentIndex - 1
            if CurrentIndex < 1 then
                CurrentIndex = #Colours
                MinimumIndex = #Colours - Maximum + 1
            elseif CurrentIndex < MinimumIndex then
                MinimumIndex = MinimumIndex - 1
            end
        elseif RightArrowHovered then
            CurrentIndex = CurrentIndex + 1
            if CurrentIndex > #Colours then
                CurrentIndex = 1
                MinimumIndex = 1
            elseif CurrentIndex > MinimumIndex + Maximum - 1 then
                MinimumIndex = MinimumIndex + 1
            end
        elseif Hovered then
            for i = 1, Maximum do
                if RageUI.IsMouseInBounds(boxBaseX + (CLR_BOX_W * (i - 1)) + safeX, boxBaseY + safeY, CLR_BOX_W, CLR_BOX_H) then
                    CurrentIndex = MinimumIndex + i - 1
                    break
                end
            end
        end
        
        if Action.onColorChange then
            Action.onColorChange(MinimumIndex, CurrentIndex)
        end
        
        local Audio = RageUI.Settings.Audio
        RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
    end
    
    RageUI.ItemOffset = itemOff + CLR_BG_H + CLR_BG_Y
end
