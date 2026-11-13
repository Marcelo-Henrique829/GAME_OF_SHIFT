// Atualiza o alvo e o tamanho base antes de aplicar o zoom.
update_camera_target();

// Foca o jogador que iniciou a conversa enquanto o diálogo existir.
var _dialogue = instance_find(Obj_dialogo, 0);
var _dialogue_active = false;
if (_dialogue != noone)
{
    if (instance_exists(_dialogue.player))
    {
        camera_target = _dialogue.player;
        _dialogue_active = true;
    }
}

// Aproxima durante o fade-in; ao entrar na sala, afasta até o enquadramento padrão.
var _controller = instance_find(obj_control, 0);
var _fade_in = false;
if (_controller != noone)
{
    // Ignora o estado da sala anterior antes do controller atualizar sua transição.
    _fade_in = (_controller.fade_current_room == room && _controller.fade_in_active);
}

if (global.player_in_menu && (instance_exists(obj_player_platform) || instance_exists(obj_player_topdown))) scr_camera_zoom_in(menu_zoom_scale);
else if (_dialogue_active) scr_camera_zoom_in(dialogue_zoom_scale);
else if (_fade_in) scr_camera_zoom_in();
else scr_camera_zoom_out();

// Redimensiona antes de centralizar para manter o player no enquadramento.
camera_set_view_size(view_camera[0], global.camera_width / zoom, global.camera_height / zoom);

var _target = camera_target;

if (_target == noone) exit;

var _view = view_camera[0];
var _view_width = camera_get_view_width(_view);
var _view_height = camera_get_view_height(_view);
var _camera_x = clamp(_target.x - _view_width * 0.5, 0, max(0, room_width - _view_width));
var _camera_y = clamp(_target.y - _view_height * 0.5, 0, max(0, room_height - _view_height));

camera_set_view_pos(_view, _camera_x, _camera_y);
