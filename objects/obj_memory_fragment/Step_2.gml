// A interação funciona independentemente de a tremida estar ativada.
is_hovered = false;
if (!visible || image_alpha <= 0 || sprite_index == -1 || global.fade_active
    || global.player_in_menu || instance_exists(Obj_dialogo)) exit;

is_hovered = collision_point(mouse_x, mouse_y, id, true, false) != noone;
if (!is_hovered || !mouse_check_button_pressed(mb_right)) exit;

// Exige contato real do jogador com o fragmento para entrar na memória.
var _player = instance_place(x, y, obj_player_platform);
if (_player == noone || _player.player_dead || !room_exists(target_room)) exit;

var _controller = instance_find(obj_control, 0);
if (!instance_exists(_controller)) exit;
if (_controller.player_dead_active || _controller.fade_in_active || _controller.fade_out_active) exit;

// O controller cobre a tela, troca de sala e revela a memória na chegada.
_controller.fade_target_room = target_room;
_controller.fade_restart_room = false;
_controller.fade_in_progress = 0;
_controller.fade_in_active = true;
_controller.fade_out_active = false;
global.fade_active = true;
is_hovered = false;
