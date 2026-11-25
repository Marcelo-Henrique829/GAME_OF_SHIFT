// A interação funciona independentemente de a tremida estar ativada.
is_hovered = false;
if (!visible || image_alpha <= 0 || sprite_index == -1 || global.fade_active
    || global.player_in_menu || instance_exists(Obj_dialogo)) exit;

is_hovered = collision_point(mouse_x, mouse_y, id, true, false) != noone;
if (!is_hovered || !mouse_check_button_pressed(mb_right)) exit;

// Confirma que há um jogador vivo na sala, a qualquer distância do fragmento.
var _player = instance_find(obj_player_platform, 0);
if (_player == noone || _player.player_dead || !room_exists(target_room)) exit;

var _controller = instance_find(obj_control, 0);
if (!instance_exists(_controller)) exit;
if (_controller.player_dead_active || _controller.fade_in_active || _controller.fade_out_active) exit;

// Registra a sala onde o fragmento foi encontrado, mesmo se ela for visitada de novo.
var _sala_origem = room_get_name(room);
var _coletados = global.memory_fragment.coletados_por_sala;
if (!variable_struct_exists(_coletados, _sala_origem))
{
    _coletados[$ _sala_origem] = true;
    global.memory_fragment.total += 1;
}

// O controller cobre a tela, troca de sala e revela a memória na chegada.
_controller.fade_target_room = target_room;
_controller.fade_restart_room = false;
_controller.fade_in_progress = 0;
_controller.fade_in_active = true;
_controller.fade_out_active = false;
global.fade_active = true;
is_hovered = false;
