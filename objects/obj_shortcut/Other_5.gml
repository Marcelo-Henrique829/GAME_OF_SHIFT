// A tela já está coberta. Restaura o enquadramento para a próxima visita.
if (is_undefined(shortcut_zoom)) exit;

if (view_camera[0] == shortcut_zoom.camera)
{
    camera_set_view_size(shortcut_zoom.camera, shortcut_zoom.width, shortcut_zoom.height);
    camera_set_view_pos(shortcut_zoom.camera, shortcut_zoom.x, shortcut_zoom.y);
}
shortcut_zoom = undefined;
