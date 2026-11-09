/// @function scr_camera_zoom_in(_target_scale)
/// @description Aproxima gradualmente a câmera. Executar no contexto de obj_camera.
/// @param {real} _target_scale Zoom desejado; por padrão usa zoom_in_scale.
function scr_camera_zoom_in(_target_scale = zoom_in_scale)
{
    var _fps = max(1, game_get_speed(gamespeed_fps));
    var _step = max(0, zoom_in_speed) / _fps;
    zoom += clamp(max(1, _target_scale) - zoom, -_step, _step);
}

/// @function scr_camera_zoom_out()
/// @description Afasta gradualmente a câmera até a escala padrão (1).
///              Executar no contexto de obj_camera.
function scr_camera_zoom_out()
{
    var _fps = max(1, game_get_speed(gamespeed_fps));
    zoom = max(1, zoom - max(0, zoom_out_speed) / _fps);
}
