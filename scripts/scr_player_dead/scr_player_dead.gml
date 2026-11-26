/// @function scr_player_dead(_player)
/// @description Aproxima a câmera, fecha a tela com fade-in e reinicia a sala.
function scr_player_dead(_player = noone)
{
    // Ajustes temporários do zoom de morte: altere estes valores para testar.
    var _zoom_velocidade = 25; // Escalas por segundo: maior = aproxima mais rápido.
    var _zoom_escala = 20; // Aproximação final: 1 = normal, 5 = cinco vezes mais perto.

    if (!instance_exists(_player)) return false;
    if (_player.object_index != obj_player_platform || _player.player_dead) return false;

    var _controller = instance_find(obj_control, 0);
    if (_controller == noone) _controller = instance_create_depth(0, 0, -10000, obj_control);
    // Não reinicia o efeito a cada contato nem interrompe uma troca de sala.
    if (_controller.player_dead_active || _controller.fade_in_active) return false;

    var _camera = instance_find(obj_camera, 0);
    if (_camera == noone) _camera = instance_create_depth(_player.x, _player.y, -10000, obj_camera);
    if (_camera != noone)
    {
        _camera.death_zoom_speed = max(0, _zoom_velocidade);
        _camera.death_zoom_scale = max(1, _zoom_escala);
    }

    // Fecha o menu antes de entrar em DEAD para não restaurar um estado vivo depois.
    with (obj_UI_player)
    {
        if (player == _player) menu_set_open(false);
    }
    global.player_in_menu = false;
    _player.player_dead = true;
    with (_player) aud_update_footsteps();
    if (audio_group_is_loaded(ag_SoundEffect))
    {
        aud_play_sound(snd_death_sfx, AUDIO_PRIORITY.IMPORTANT);
    }
    _player.hspd = 0;
    _player.spd = 0;
    _player.state = PlayerStatePlatformer.DEAD;
    _player.sprite_index = spr_player_plataformer_ph_destroy;
    _player.image_index = 0;
    _player.image_speed = 1;
    _player.dead_trail_timer = 0;
    _controller.player_dead_active = true;
    _controller.player_dead_target = _player;
    _controller.fade_restart_room = true;
    _controller.fade_target_room = room;
    _controller.fade_in_progress = 0;
    _controller.fade_out_active = false;
    // O controller sincroniza o fade com a animação, sem esperar o zoom máximo.
    _controller.fade_in_active = false;
    global.fade_active = true;
    return true;
}
