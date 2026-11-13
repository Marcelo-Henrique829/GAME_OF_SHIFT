// Resolução de saída do jogo (viewport) e área do mundo mostrada pela câmera.
// Esses valores são independentes: a câmera enquadra uma área menor do que a tela.
global.game_resolution_width = 1366;
global.game_resolution_height = 768;

// Área do mundo exibida em cada modo, antes de aplicar o zoom.
camera_platform_width = 384;
camera_platform_height = 216;

camera_topdown_width = 1920;
camera_topdown_height = 1080;

// Mantém o tamanho base e o alvo sincronizados com o jogador presente na sala.
update_camera_target = function()
{
    camera_target = instance_find(obj_player_platform, 0);
    if (camera_target != noone)
    {
        global.camera_width = max(1, camera_platform_width);
        global.camera_height = max(1, camera_platform_height);
    }
    else
    {
        camera_target = instance_find(obj_player_topdown, 0);
        global.camera_width = max(1, camera_topdown_width);
        global.camera_height = max(1, camera_topdown_height);
    }
};
update_camera_target();

// Zoom: 1 é a escala padrão; 2 mostra metade da largura e da altura.
zoom_in_scale = 3;
zoom_in_speed = 6;
zoom_out_speed = 4;
menu_zoom_scale = 4;
zoom = zoom_in_scale;

// Ativa o visor mesmo quando estiver desabilitado nas configurações da room.
if (!view_enabled) view_enabled = true;
if (!view_visible[0]) view_visible[0] = true;
// Rooms sem câmera configurada precisam de uma câmera para o visor principal.
if (view_camera[0] == -1)
{
    view_camera[0] = camera_create_view(0, 0, global.camera_width, global.camera_height);
}
view_set_wport(0, global.game_resolution_width);
view_set_hport(0, global.game_resolution_height);
display_set_gui_size(global.game_resolution_width, global.game_resolution_height);
window_set_size(global.game_resolution_width, global.game_resolution_height);
camera_set_view_size(view_camera[0], global.camera_width / zoom, global.camera_height / zoom);
