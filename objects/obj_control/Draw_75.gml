// DRAW GUI END — mantém o cursor acima da interface e independente do zoom.
// Mostra o cursor no menu principal e nas salas de plataforma, mesmo com a UI fechada.
if (global.fade_active) exit;
var _show_cursor = (room == rm_main_menu)
    || instance_exists(obj_plataformer_control) || instance_exists(obj_player_platform)
    || instance_exists(obj_memory_image);
if (instance_exists(obj_UI_player) && global.player_in_menu ) _show_cursor = true;
if (!_show_cursor) exit;

// Começa sempre no cursor padrão para não manter uma seleção do frame anterior.
// O Draw normal dos atalhos e o End Step da UI já atualizaram seus hovers.
var _selected = false;
// As janelas estão no mundo da sala; usa o mouse em coordenadas da câmera.
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
if (global.player_in_menu)
{
    with (obj_UI_player)
    {
        if (visible && instance_exists(player) && (hovered_option != -1 || clicked_option != -1)) _selected = true;
    }
}
var _cursor = _selected ? spr_cursor_selected_ph : spr_cursor_iddle_ph;
draw_sprite_ext(_cursor, 0,
    device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
    1, 1, 0, c_white, 1);
