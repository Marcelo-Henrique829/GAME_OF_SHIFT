var _music_loaded = audio_group_is_loaded(ag_music);
var _sfx_loaded = audio_group_is_loaded(ag_SoundEffect);

var _ready = _music_loaded && _sfx_loaded;
if (_ready && !global.audio.ready) aud_update_volumes();
global.audio.ready = _ready;

if (!_music_loaded) audio_group_load(ag_music);
if (!_sfx_loaded) audio_group_load(ag_SoundEffect);
