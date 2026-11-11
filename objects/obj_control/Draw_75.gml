// DRAW GUI END — mantém o cursor acima da interface e independente do zoom.
// Fora do menu principal, só aparece enquanto o menu do player estiver aberto.
if (global.fade_active) exit;
var _show_cursor = (room == rm_main_menu);
if (instance_exists(obj_UI_player) && global.player_in_menu) _show_cursor = true;
if (!_show_cursor) exit;

// Começa sempre no cursor padrão para não manter uma seleção do frame anterior.
// O Draw normal dos atalhos e o End Step da UI já atualizaram seus hovers.
var _selected = false;
with (obj_shortcut)
{
    if (visible && image_alpha > 0 && sprite_index != -1 && is_hovered) _selected = true;
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
