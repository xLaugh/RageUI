-- Constantes pré-extraites
local STAT_BG_Y = 4
local STAT_BG_W = 431
local STAT_BG_H = 42
local STAT_TEXT_Y = 15
local STAT_TEXT_SCALE = 0.35
local STAT_BAR_RIGHT = 8
local STAT_BAR_Y = 27
local STAT_BAR_W = 200
local STAT_BAR_H = 10
local STAT_BAR_RATIO = 0.5
local STAT_DIV_W = 2
local STAT_DIV_H = 10
local STAT_DIV_COUNT = 5
local TITLE_BG_W = 431

function RageUI.StatisticPanel(Percent, Text, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end
    if Index and CurrentMenu.Index ~= Index then return end
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local panelCount = RageUI.StatisticPanelCount
    local panelOffset = panelCount * 42
    local rowOffset = panelCount * 40
    
    local BarWidth = STAT_BAR_W + widthOff * STAT_BAR_RATIO
    local barX = menuX + TITLE_BG_W - BarWidth - STAT_BAR_RIGHT + widthOff
    local barY = rowOffset + menuY + STAT_BAR_Y + subH + itemOff
    
    RenderRectangle(menuX, menuY + STAT_BG_Y + subH + itemOff + panelOffset, STAT_BG_W + widthOff, STAT_BG_H, 0, 0, 0, 170)
    RenderText(Text or "", menuX + 8.0, rowOffset + menuY + STAT_TEXT_Y + subH + itemOff, 0, STAT_TEXT_SCALE, 245, 245, 245, 255, 0)
    RenderRectangle(barX, barY, BarWidth, STAT_BAR_H, 87, 87, 87, 255)
    RenderRectangle(barX, barY, Percent * BarWidth, STAT_BAR_H, 255, 255, 255, 255)
    
    local divStep = (BarWidth - (STAT_DIV_COUNT / STAT_DIV_W)) / (STAT_DIV_COUNT + 1)
    for i = 1, STAT_DIV_COUNT do
        RenderRectangle(barX + i * divStep, barY, STAT_DIV_W, STAT_DIV_H, 0, 0, 0, 255)
    end
    
    RageUI.StatisticPanelCount = panelCount + 1
end

function RageUI.StatisticPanelAdvanced(Text, Percent, RGBA1, Percent2, RGBA2, RGBA3, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end
    if Index and CurrentMenu.Index ~= Index then return end
    
    RGBA1 = RGBA1 or { 255, 255, 255, 255 }
    RGBA2 = RGBA2 or { 0, 153, 204, 255 }
    RGBA3 = RGBA3 or { 185, 0, 0, 255 }
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local panelCount = RageUI.StatisticPanelCount
    local panelOffset = panelCount * 42
    local rowOffset = panelCount * 40
    
    local BarWidth = STAT_BAR_W + widthOff * STAT_BAR_RATIO
    local barX = menuX + TITLE_BG_W - BarWidth - STAT_BAR_RIGHT + widthOff
    local barY = rowOffset + menuY + STAT_BAR_Y + subH + itemOff
    
    RenderRectangle(menuX, menuY + STAT_BG_Y + subH + itemOff + panelOffset, STAT_BG_W + widthOff, STAT_BG_H, 0, 0, 0, 170)
    RenderText(Text or "", menuX + 8.0, rowOffset + menuY + STAT_TEXT_Y + subH + itemOff, 0, STAT_TEXT_SCALE, 245, 245, 245, 255, 0)
    RenderRectangle(barX, barY, BarWidth, STAT_BAR_H, 87, 87, 87, 255)
    RenderRectangle(barX, barY, Percent * BarWidth, STAT_BAR_H, RGBA1[1], RGBA1[2], RGBA1[3], RGBA1[4])
    
    if Percent2 and Percent2 ~= 0 then
        local rgba = Percent2 > 0 and RGBA2 or RGBA3
        RenderRectangle(barX + Percent * BarWidth, barY, Percent2 * BarWidth, STAT_BAR_H, rgba[1], rgba[2], rgba[3], rgba[4])
    end
    
    local divStep = (BarWidth - (STAT_DIV_COUNT / STAT_DIV_W)) / (STAT_DIV_COUNT + 1)
    for i = 1, STAT_DIV_COUNT do
        RenderRectangle(barX + i * divStep, barY, STAT_DIV_W, STAT_DIV_H, 0, 0, 0, 255)
    end
    
    RageUI.StatisticPanelCount = panelCount + 1
end
