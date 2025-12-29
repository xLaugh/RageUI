-- Constantes pré-extraites
local BTN_BG_Y = 4
local BTN_BG_W = 431
local BTN_BG_H = 42
local BTN_TEXT_X = 8
local BTN_TEXT_Y = 10
local BTN_TEXT_SCALE = 0.35

function RageUI.BoutonPanel(LeftText, RightText, Index)
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
    
    local leftTextSize = MeasureStringWidth(LeftText or "")
    
    RenderRectangle(menuX, menuY + BTN_BG_Y + subH + itemOff + panelOffset, BTN_BG_W + widthOff, BTN_BG_H, 0, 0, 0, 170)
    RenderText(LeftText or "", menuX + BTN_TEXT_X, rowOffset + menuY + BTN_TEXT_Y + subH + itemOff, 0, BTN_TEXT_SCALE, 245, 245, 245, 255, 0)
    RenderText(RightText or "", menuX + BTN_BG_W + widthOff - leftTextSize, rowOffset + menuY + BTN_TEXT_Y + subH + itemOff, 0, BTN_TEXT_SCALE, 245, 245, 245, 255, 2)
    
    RageUI.StatisticPanelCount = panelCount + 1
end
