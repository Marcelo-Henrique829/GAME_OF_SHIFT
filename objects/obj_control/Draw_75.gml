#region Visibilidade do cursor
// A transição oculta o cursor. Fora dela, as salas e interfaces abaixo o habilitam.
if (global.fade_active) exit;
var _show_cursor = (room == rm_main_menu || room == rm_memory_palace)
    || instance_exists(obj_plataformer_control) || instance_exists(obj_player_platform)
    || instance_exists(obj_memory_image);
if (instance_exists(obj_UI_player) && global.player_in_menu) _show_cursor = true;
if (!_show_cursor) exit;
#endregion

#region Objetos arrastáveis
// A seleção é recalculada a cada frame. Janelas e caixas usam as coordenadas
// da sala e mantêm o cursor selecionado durante todo o arraste.
var _selected = false;
with (obj_window)
{
    if (janela_ativa && visible && image_alpha > 0 && sprite_index != -1
        && (janela_arrastando || collision_point(mouse_x, mouse_y, id, true, false) != noone))
    {
        _selected = true;
    }
}
with (obj_box)
{
    if (caixa_ativa && visible && image_alpha > 0 && sprite_index != -1
        && (caixa_arrastando || collision_point(mouse_x, mouse_y, id, true, false) != noone))
    {
        _selected = true;
    }
}
#endregion

#region Atalhos, fragmentos e memória
// Reaproveita as áreas de interação calculadas no End Step pelos próprios objetos.
with (obj_shortcut)
{
    if (visible && image_alpha > 0 && sprite_index != -1 && is_hovered) _selected = true;
}
with (obj_memory_fragment)
{
    if (visible && image_alpha > 0 && sprite_index != -1 && is_hovered) _selected = true;
}
with (obj_memory_image)
{
    if (visible && image_alpha > 0 && memoria_revelando && memoria_alpha > 0
        && menu_hovered) _selected = true;
}
#endregion

#region Painéis e menu do jogador
// Os painéis atualizam o hover no fluxo de desenho. O menu do jogador também
// mantém a seleção enquanto a animação de clique da opção está em andamento.
if (room == rm_memory_palace)
{
    with (obj_panel)
    {
        if (visible && image_alpha > 0 && painel_hover) _selected = true;
    }
}
if (global.player_in_menu)
{
    with (obj_UI_player)
    {
        if (visible && instance_exists(player)
            && (hovered_option != -1 || clicked_option != -1)) _selected = true;
    }
}
#endregion

#region Desenho na GUI
// As coordenadas da GUI mantêm o cursor alinhado ao mouse durante o zoom da câmera.
var _cursor = _selected ? spr_cursor_selected_ph : spr_cursor_iddle_ph;
draw_sprite_ext(_cursor, 0,
    device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
    1, 1, 0, c_white, 1);
#endregion
