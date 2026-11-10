// Garante o visor ativo após as configurações de entrada da room.
if (!view_enabled) view_enabled = true;
if (!view_visible[0]) view_visible[0] = true;
if (view_camera[0] == -1)
{
    view_camera[0] = camera_create_view(0, 0, global.camera_width, global.camera_height);
}
view_set_wport(0, global.game_resolution_width);
view_set_hport(0, global.game_resolution_height);

// Cada sala começa aproximada e o Step retorna gradualmente à escala padrão.
zoom_in_scale = max(1, zoom_in_scale);
zoom = zoom_in_scale;
camera_set_view_size(view_camera[0], global.camera_width / zoom, global.camera_height / zoom);
