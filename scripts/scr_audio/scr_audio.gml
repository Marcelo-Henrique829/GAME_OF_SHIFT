enum AUDIO_PRIORITY
{
    AMBIENT = 10,
    FOOTSTEP = 20,
    ENEMY = 30,
    PLAYER = 50,
    IMPORTANT = 70,
    UI = 80,
    MUSIC = 100
}

enum AUDIO_TYPE
{
    MASTER,
    MUSIC,
    SOUND_EFFECT
}

/// @function aud_update_volumes()
/// @description Aplica os volumes de global.audio ao áudio do jogo.
function aud_update_volumes()
{
    aud_set_volume(AUDIO_TYPE.MASTER, global.audio.volume_master);
    aud_set_volume(AUDIO_TYPE.MUSIC, global.audio.volume_music);
    aud_set_volume(AUDIO_TYPE.SOUND_EFFECT, global.audio.volume_sfx);
}

/// @function aud_set_volume(_type, _volume)
/// @description Atualiza o volume da categoria indicada por AUDIO_TYPE.
function aud_set_volume(_type, _volume)
{
    var _gain = clamp(_volume, 0, 1);

    switch (_type)
    {
        case AUDIO_TYPE.MASTER:
            global.audio.volume_master = _gain;
            audio_set_master_gain(0, _gain);
            break;

        case AUDIO_TYPE.MUSIC:
            global.audio.volume_music = _gain;
            if (audio_group_is_loaded(ag_music)) audio_group_set_gain(ag_music, _gain);
            break;

        case AUDIO_TYPE.SOUND_EFFECT:
            global.audio.volume_sfx = _gain;
            if (audio_group_is_loaded(ag_SoundEffect)) audio_group_set_gain(ag_SoundEffect, _gain);
            break;
    }
}

/// @function aud_play_sound(_sound, _priority, _loop, _gain, _offset, _pitch, _listener_mask)
/// @description Toca um som usando o volume do grupo e retorna o ID da instância de áudio, ou -1.
function aud_play_sound(_sound, _priority = AUDIO_PRIORITY.AMBIENT, _loop = false,
    _gain = 1, _offset = undefined, _pitch = 1, _listener_mask = undefined)
{
    if (is_undefined(_sound) || _sound == noone || _sound == -1) return -1;

    var _params = {
        sound: _sound,
        priority: _priority,
        loop: _loop,
        gain: _gain,
        pitch: _pitch
    };

    if (!is_undefined(_offset)) _params.offset = _offset;
    if (!is_undefined(_listener_mask)) _params.listener_mask = _listener_mask;

    return audio_play_sound_ext(_params);
}

/// @function aud_update_footsteps(_sound)
/// @description Mantém o ciclo de passos do jogador na superfície atual. Use -1 para parar.
function aud_update_footsteps(_sound = -1)
{
    if (footstep_sound != _sound)
    {
        if (footstep_audio_id != -1 && audio_is_playing(footstep_audio_id))
        {
            if (footstep_sound == snd_walk_grass_sfx)
            {
                audio_sound_gain(footstep_audio_id, 0, 120);
                audio_sound_loop(footstep_audio_id, false);
            }
            else
            {
                audio_stop_sound(footstep_audio_id);
            }
        }
        footstep_audio_id = -1;
        footstep_sound = _sound;
    }

    if (_sound == -1 || !audio_group_is_loaded(ag_SoundEffect)) return;
    if (footstep_audio_id != -1 && audio_is_playing(footstep_audio_id)) return;

    footstep_audio_id = aud_play_sound(_sound, AUDIO_PRIORITY.FOOTSTEP, true);
}
