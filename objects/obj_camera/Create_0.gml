// Resolução de saída do jogo (viewport) e área do mundo mostrada pela câmera.
// Esses valores são independentes: a câmera enquadra uma área menor do que a tela.
global.game_resolution_width = 1366;
global.game_resolution_height = 768;

global.camera_width = 384/2;
global.camera_height = 216/2;

view_enabled = true;
view_visible[0] = true;
view_set_wport(0, global.game_resolution_width);
view_set_hport(0, global.game_resolution_height);
display_set_gui_size(global.game_resolution_width, global.game_resolution_height);
window_set_size(global.game_resolution_width, global.game_resolution_height);
camera_set_view_size(view_camera[0], global.camera_width, global.camera_height);
