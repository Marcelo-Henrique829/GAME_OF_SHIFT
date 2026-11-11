// END STEP — calcula o hover e aceita apenas a pressão inicial do clique.
is_hovered = false;
if (!visible || image_alpha <= 0 || sprite_index == -1 || global.fade_active) exit;

var _bounds = get_shortcut_bounds();

is_hovered = point_in_rectangle(mouse_x, mouse_y,
    _bounds.left, _bounds.top, _bounds.right, _bounds.bottom);
if (!is_hovered || !mouse_check_button_pressed(mb_left)) exit;
// Um filho sem destino configurado não deve iniciar uma transição.
//if (!room_exists(target_room)) exit;

instance_obj(obj_credit_arquive);
/*
var _controller = instance_find(obj_control, 0);
if (!instance_exists(_controller)) exit;
// Não reinicia nem substitui uma transição que já esteja em andamento.
if (_controller.fade_in_active || _controller.fade_out_active) exit;
_controller.fade_target_room = target_room;
_controller.fade_in_progress = 0;
_controller.fade_in_active = true;
_controller.fade_out_active = false;
global.fade_active = true;
is_hovered = false;
*/
