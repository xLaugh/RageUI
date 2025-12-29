-- Constantes pré-extraites
local HER_BG_DICT = "pause_menu_pages_char_mom_dad"
local HER_BG_TEX = "mumdadbg"
local HER_BG_W = 431
local HER_BG_H = 228
local HER_PORT_DICT = "char_creator_portraits"
local HER_MUM_X = 25
local HER_DAD_X = 195
local HER_PORT_W = 228
local HER_PORT_H = 228

function RageUI.Window.Heritage(Mum, Dad)
    local CurrentMenu = RageUI.CurrentMenu
    if not CurrentMenu or not CurrentMenu() then return end
    
    local mumTex
    if Mum < 20 then mumTex = "female_" .. (Mum-1)
    elseif Mum > 40 then mumTex = "female_" .. (Mum-40)
    else mumTex = "female_" .. (Mum-20) end
    
    local dadTex
    if Dad < 20 then dadTex = "male_" .. (Dad-1)
    elseif Dad > 40 then dadTex = "male_" .. (Dad-40)
    else dadTex = "male_" .. (Dad-20) end
    
    local menuX = CurrentMenu.X
    local menuY = CurrentMenu.Y
    local widthOff = CurrentMenu.WidthOffset
    local subH = CurrentMenu.SubtitleHeight
    local itemOff = RageUI.ItemOffset
    local halfWidth = widthOff * 0.5
    local baseY = menuY + subH + itemOff
    
    RenderSprite(HER_BG_DICT, HER_BG_TEX, menuX, baseY, HER_BG_W + widthOff, HER_BG_H)
    RenderSprite(HER_PORT_DICT, dadTex, menuX + HER_DAD_X + halfWidth, baseY, HER_PORT_W, HER_PORT_H)
    RenderSprite(HER_PORT_DICT, mumTex, menuX + HER_MUM_X + halfWidth, baseY, HER_PORT_W, HER_PORT_H)
    RageUI.ItemOffset = itemOff + HER_BG_H
end
