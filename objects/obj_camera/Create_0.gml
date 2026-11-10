// Resolução de saída do jogo (viewport) e área do mundo mostrada pela câmera.
// Esses valores são independentes: a câmera enquadra uma área menor do que a tela.
global.game_resolution_width = 1366;
global.game_resolution_height = 768;

global.camera_width = 384;
global.camera_height = 216;

// Zoom: 1 é a escala padrão; 2 mostra metade da largura e da altura.
zoom_in_scale = 3;
zoom_in_speed = 6;
zoom_out_speed = 4;
menu_zoom_scale = 4;
zoom = zoom_in_scale;

view_enabled = true;
view_visible[0] = true;
view_set_wport(0, global.game_resolution_width);
view_set_hport(0, global.game_resolution_height);
display_set_gui_size(global.game_resolution_width, global.game_resolution_height);
window_set_size(global.game_resolution_width, global.game_resolution_height);
camera_set_view_size(view_camera[0], global.camera_width / zoom, global.camera_height / zoom);
