#region Instância persistente
// Algumas salas também declaram um obj_control. A instância que veio da sala
// anterior conserva o progresso do fade e descarta a recém-criada.
if (instance_number(obj_control) > 1)
{
    instance_destroy();
    exit;
}
#endregion

#region Cursor personalizado
// O Draw GUI End desenha o cursor do jogo acima da interface.
window_set_cursor(cr_none);
cursor_sprite = -1;
#endregion

#region Estado da transição
// O Step compara a sala atual com a última registrada para detectar a chegada.
fade_current_room = room;
fade_target_room = noone;
fade_restart_room = false;
fade_animation_steps = -1; // O primeiro Step de uma transição leva o contador a zero.
shortcut_zoom_target = noone; // O atalho segura o fade-in enquanto aproxima a câmera.

// A morte passa pelo mesmo fade, mas reinicia a sala em que ocorreu.
player_dead_active = false;
player_dead_target = noone;
#endregion

#region Configuração dos fades
// Fade-in cobre a tela. O progresso começa em zero e sobe até a cobertura total.
fade_in_active = false;
fade_in_progress = 0;
fade_in_cover_progress = 1;
fade_in_speed = 1.5;
fade_in_triangle_max_scale = 3;

// Fade-out revela a sala. Na primeira entrada, a tela já começa coberta.
fade_out_active = true;
fade_out_progress = 1;
fade_out_speed = 1.5;
fade_out_triangle_max_scale = 3;

// A interface e os objetos clicáveis consultam esta flag para aguardar a transição.
global.fade_active = fade_in_active || fade_out_active;
#endregion

#region Gerenciador de áudio
// Uma única instância persistente carrega os grupos e aplica os volumes.
if (!instance_exists(obj_audio_manager))
{
    instance_create_depth(0, 0, 0, obj_audio_manager, { visible: false });
}
#endregion

#region Trilhas das salas
menu_music_sound = snd_dorfic_without_drum_music;
room_music_fade_in_ms = 750;
room_music_fade_out_ms = 450;
room_music_exit_at = -1;
room_music_playing_room = noone;
room_music_positions = {};

// Recebe a faixa desejada ou -1 para silêncio. Retorna false enquanto a
// faixa anterior baixa de volume e a troca de sala ainda precisa aguardar.
update_room_music = function(_requested_sound)
{
    var _audio = global.audio;
    var _music_id = _audio.music_id;
    var _playing = false;
    if (_music_id != -1)
    {
        _playing = audio_is_playing(_music_id);
    }

    // Mesmo se duas salas usarem a mesma faixa, cada uma guarda sua própria posição.
    if (_playing && (_requested_sound != _audio.current_music || room != room_music_playing_room))
    {
        // Inicia a rampa uma vez. O fade visual pode avançar enquanto o áudio baixa.
        if (room_music_exit_at == -1)
        {
            audio_sound_gain(_music_id, 0, room_music_fade_out_ms);
            room_music_exit_at = current_time + room_music_fade_out_ms;
        }
        if (current_time < room_music_exit_at)
        {
            return false;
        }

        // Salva a posição imediatamente antes de parar. Reiniciar a própria sala
        // zera a posição dela, sem alterar a trilha salva em outras salas.
        var _saved_position = 0;
        if (!fade_restart_room || room != room_music_playing_room)
        {
            var _track_position = audio_sound_get_track_position(_music_id);
            var _track_length = audio_sound_length(_audio.current_music);
            if (_track_position > 0 && _track_position < _track_length)
            {
                _saved_position = _track_position;
            }
        }
        var _previous_room_name = room_get_name(room_music_playing_room);
        room_music_positions[$ _previous_room_name] = _saved_position;
        audio_stop_sound(_music_id);
        _playing = false;
    }

    if (room_music_exit_at != -1)
    {
        room_music_exit_at = -1;
        // Se a saída foi cancelada, recupera o volume da mesma instância.
        if (_playing)
        {
            audio_sound_gain(_music_id, 1, room_music_fade_in_ms);
        }
    }

    if (_playing)
    {
        return true;
    }
    _audio.music_id = -1;
    _audio.current_music = -1;
    room_music_playing_room = noone;

    if (_requested_sound == -1 || !audio_group_is_loaded(ag_music))
    {
        return true;
    }

    var _room_name = room_get_name(room);
    var _resume_position = 0;
    if (variable_struct_exists(room_music_positions, _room_name))
    {
        _resume_position = room_music_positions[$ _room_name];
    }

    // A faixa entra em silêncio no ponto salvo e sobe até o volume configurado.
    // Depois de retomar, uma repetição natural começa novamente do zero.
    aud_set_volume(AUDIO_TYPE.MUSIC, _audio.volume_music);
    _music_id = aud_play_sound(_requested_sound, AUDIO_PRIORITY.MUSIC, false, 0, _resume_position);
    if (_music_id != -1)
    {
        room_music_positions[$ _room_name] = 0;
        room_music_playing_room = room;
        _audio.music_id = _music_id;
        _audio.current_music = _requested_sound;
        audio_sound_gain(_music_id, 1, room_music_fade_in_ms);
    }
    return true;
};
#endregion
