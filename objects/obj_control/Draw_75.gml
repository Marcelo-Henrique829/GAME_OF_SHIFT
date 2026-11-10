// DRAW GUI END — mantém o cursor acima da interface e independente do zoom.
// Fora do menu principal, só aparece enquanto o menu do player estiver aberto.
if (global.fade_active) exit;
var _show_cursor = (room == rm_main_menu);
if (instance_exists(obj_UI_player) && global.player_in_menu) _show_cursor = true;
if (!_show_cursor) exit;

draw_sprite_ext(spr_cursor_iddle_ph, 0,
    device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
    1, 1, 0, c_white, 1);
