-- Constantes pré-extraites
local SPR_BG_Y = 4
local SPR_BG_W = 431
local SPR_BG_H = 42

function RageUI.RenderSprite(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local panelCount = RageUI.StatisticPanelCount
    
    RenderSprite(Dictionary, Texture, menuX, menuY + SPR_BG_Y + subH + itemOff + (panelCount * 42), SPR_BG_W + widthOff, SPR_BG_H + 200, 0, 255, 255, 255, 255)
    RageUI.StatisticPanelCount = panelCount + 1
end
