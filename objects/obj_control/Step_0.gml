#region Som de clique
// A pressão inicial basta para o feedback. O grupo de efeitos carrega em segundo plano.
if ((mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right))
    && audio_group_is_loaded(ag_SoundEffect))
{
    aud_play_sound(snd_click_fx, AUDIO_PRIORITY.UI);
}
#endregion

#region Chegada a outra sala
// A instância persistente ainda guarda a sala anterior. Ao detectar a troca,
// limpa os alvos da transição e começa a revelar a nova sala com a tela coberta.
// O reinício mantém o ID da sala, então scr_fade_in prepara o fade-out nesse caso.
if (room != fade_current_room)
{
    fade_current_room = room;
    fade_restart_room = false;
    shortcut_zoom_target = noone;
    player_dead_active = false;
    player_dead_target = noone;
    fade_in_active = false;
    fade_in_progress = 0;
    fade_out_active = true;
    fade_out_progress = 1;
}
#endregion

#region Atalho entre salas de teste
// K alterna entre plataforma e top-down quando o menu está fechado e a tela pode ser coberta.
if (keyboard_check_pressed(ord("K")) && !fade_in_active
    && !player_dead_active && !global.player_in_menu)
{
    fade_target_room = (room == Rm_TopDownTest) ? Rm_platform_test : Rm_TopDownTest;
    fade_in_active = true;
    fade_in_progress = 0;
    fade_out_active = false;
}
#endregion

#region Fade sincronizado com a morte
// Converte o quadro da animação de destruição em cobertura entre os pontos
// configurados no jogador. O max mantém a cobertura que scr_fade_in já avançou.
if (player_dead_active && fade_restart_room && instance_exists(player_dead_target))
{
    var _player = player_dead_target;
    if (_player.sprite_index == spr_player_plataformer_ph_destroy)
    {
        var _fim = clamp(_player.dead_restart_progress, 0.1, 0.9);
        var _inicio = clamp(_player.dead_fade_start_progress, 0, _fim - 0.01);
        var _animacao = _player.image_index / max(1, _player.image_number - 1);
        if (_animacao >= _inicio)
        {
            fade_in_active = true;
            fade_in_progress = max(fade_in_progress,
                clamp((_animacao - _inicio) / (_fim - _inicio), 0, 1) * fade_in_cover_progress);
        }
    }
}
#endregion

#region Estado compartilhado da transição
// A morte também bloqueia a interface durante a aproximação, antes de cobrir a tela.
global.fade_active = player_dead_active || fade_in_active || fade_out_active;

// O End Step do atalho libera o fade-in ao terminar o zoom. O fade-out é independente.
var _fade_in_ready = !instance_exists(shortcut_zoom_target);
#endregion

#region Fade da trilha
// O menu tem faixa própria. Na nave e na plataforma, o controlador local escolhe a trilha.
var _room_track = -1;
var _platform_control = instance_find(obj_plataformer_control, 0);
if (room == rm_main_menu)
{
    _room_track = menu_music_sound;
}
else if (room == Rm_space_ship_test)
{
    var _ship_control = instance_find(control_rm_ship, 0);
    if (_ship_control != noone)
    {
        _room_track = _ship_control.room_music_sound;
    }
}
else
{
    if (_platform_control != noone)
    {
        _room_track = _platform_control.room_music_sound;
    }
}

// Reiniciar a fase mantém a mesma reprodução. Ao sair para outra sala, o fade
// da trilha acompanha a tela normalmente.
if (!fade_restart_room || _platform_control == noone)
{
    if (_fade_in_ready && fade_in_active)
    {
        _room_track = -1;
    }
    if (player_dead_active && fade_restart_room)
    {
        _room_track = -1;
    }
}
var _music_ready_to_leave = update_room_music(_room_track);
#endregion

#region Atualização dos fades
// Cobertura e revelação compartilham o contador para manter a animação entre as salas.
if ((_fade_in_ready && fade_in_active) || fade_out_active) fade_animation_steps++;
else fade_animation_steps = -1;

// A cobertura pode avançar durante a rampa. Quando a tela está coberta, aguarda
// o áudio chegar ao silêncio para scr_fade_in trocar ou reiniciar a sala.
if (_fade_in_ready && (_music_ready_to_leave || fade_in_progress < fade_in_cover_progress)) scr_fade_in();
scr_fade_out();
#endregion
