/// @function scr_camera_zoom_in(_target_scale)
/// @description Aproxima gradualmente a câmera. Executar no contexto de obj_camera.
/// @param {real} _target_scale Zoom desejado; por padrão usa zoom_in_scale.
function scr_camera_zoom_in(_target_scale = zoom_in_scale)
{
    var _fps = max(1, game_get_speed(gamespeed_fps));
    var _target = max(1, _target_scale);
    // Usa as velocidades do Create de obj_camera conforme a direção do zoom.
    var _speed = (_target < zoom) ? zoom_out_speed : zoom_in_speed;
    var _step = max(0, _speed) / _fps;
    zoom += clamp(_target - zoom, -_step, _step);
}

/// @function scr_camera_zoom_out()
/// @description Afasta gradualmente a câmera até a escala padrão (1).
///              Executar no contexto de obj_camera.
function scr_camera_zoom_out()
{
    var _fps = max(1, game_get_speed(gamespeed_fps));
    zoom = max(1, zoom - max(0, zoom_out_speed) / _fps);
}

//screen_shake
global.screen_shakex = 0;
global.screen_shakey = 0;

function screen_shake(_x = 0, _y = 0)
{
	 global.screen_shakex = choose(random(-_x),random(_x));
	 global.screen_shakey = choose(random(-_y),random(_y));
}

// Intensidade em pixels de tela. Outros objetos podem aumentá-la para iniciar a tremida.
global.shake = 0;

/// @function scr_screen_shake()
/// @description Retorna o deslocamento da tremida e reduz sua intensidade. Chamar uma vez por frame na câmera.
function scr_screen_shake()
{
    global.shake = clamp(global.shake, 0, 60);
    var _offset = [0, 0];

    if (global.shake > 0)
    {
        _offset[0] = random_range(-global.shake, global.shake);
        _offset[1] = random_range(-global.shake, global.shake);
        global.shake = max(0, global.shake - 0.5);
    }
    return _offset;
}
