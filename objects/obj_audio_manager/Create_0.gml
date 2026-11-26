// Configurações iniciais
global.audio = {
    volume_master: 1,
    volume_music: 0.6,
    volume_sfx: 0.8,

    music_id: -1,
    current_music: -1,
    requested_music: -1,

    ready: false
};

// Carregar configurações salvas

// Carregar grupos
audio_group_load(ag_music);
audio_group_load(ag_SoundEffect)

aud_update_volumes();
