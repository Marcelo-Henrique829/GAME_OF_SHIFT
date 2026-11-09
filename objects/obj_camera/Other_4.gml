// Cada sala começa aproximada e o Step retorna gradualmente à escala padrão.
zoom_in_scale = max(1, zoom_in_scale);
zoom = zoom_in_scale;
camera_set_view_size(view_camera[0], global.camera_width / zoom, global.camera_height / zoom);
