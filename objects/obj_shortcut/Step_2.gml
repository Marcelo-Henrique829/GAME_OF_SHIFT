// END STEP — calcula o hover e aceita apenas a pressão inicial do clique.
is_hovered = false;

if (!is_undefined(shortcut_zoom))
{
    var _zoom = shortcut_zoom;
    if (_zoom.progress < 1)
    {
        if (view_enabled && view_camera[0] == _zoom.camera)
        {
            var _fps = max(1, game_get_speed(gamespeed_fps));
            var _resposta = 1 - power(0.8, 60 / _fps);
            _zoom.progress = lerp(_zoom.progress, 1, _resposta);
            if (_zoom.progress >= 0.99) _zoom.progress = 1;

            camera_set_view_size(_zoom.camera, lerp(_zoom.width, _zoom.target_width, _zoom.progress),
                lerp(_zoom.height, _zoom.target_height, _zoom.progress));
            camera_set_view_pos(_zoom.camera, lerp(_zoom.x, _zoom.target_x, _zoom.progress),
                lerp(_zoom.y, _zoom.target_y, _zoom.progress));
        }
        else _zoom.progress = 1;

        // Libera o fade quando a aproximação termina.
        if (_zoom.progress == 1 && instance_exists(_zoom.controller)
            && _zoom.controller.shortcut_zoom_target == id)
        {
            _zoom.controller.shortcut_zoom_target = noone;
        }
    }
    exit;
}

if (!visible || image_alpha <= 0 || sprite_index == -1 || global.fade_active) exit;

var _bounds = get_shortcut_bounds();
is_hovered = point_in_rectangle(mouse_x, mouse_y,
    _bounds.left, _bounds.top, _bounds.right, _bounds.bottom);
if (!is_hovered || !mouse_check_button_pressed(mb_left)) exit;
// Um filho sem destino configurado não deve iniciar uma transição.
if (!room_exists(target_room)) exit;

var _controller = instance_find(obj_control, 0);
if (!instance_exists(_controller)) exit;
// Não reinicia nem substitui uma transição que já esteja em andamento.
if (_controller.fade_in_active || _controller.fade_out_active) exit;

// Enquadra o ícone dentro da sala para evitar bordas vazias no zoom.
if (view_enabled && view_visible[0] && view_camera[0] != -1)
{
    var _camera = view_camera[0];
    var _largura = camera_get_view_width(_camera);
    var _altura = camera_get_view_height(_camera);
    var _largura_alvo = _largura / 2.5;
    var _altura_alvo = _altura / 2.5;
    shortcut_zoom = {
        controller: _controller,
        camera: _camera,
        progress: 0,
        x: camera_get_view_x(_camera),
        y: camera_get_view_y(_camera),
        width: _largura,
        height: _altura,
        target_x: clamp(_bounds.icon_x - _largura_alvo * 0.5, 0, max(0, room_width - _largura_alvo)),
        target_y: clamp(_bounds.icon_y - _altura_alvo * 0.5, 0, max(0, room_height - _altura_alvo)),
        target_width: _largura_alvo,
        target_height: _altura_alvo
    };
    _controller.shortcut_zoom_target = id;
}

_controller.fade_target_room = target_room;
_controller.fade_in_progress = 0;
_controller.fade_in_active = true;
_controller.fade_out_active = false;
global.fade_active = true;
is_hovered = false;
