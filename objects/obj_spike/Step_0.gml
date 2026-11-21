if (!spike_ativo) exit;
var _player = instance_place(x, y, obj_player_platform);
if (_player != noone) scr_player_dead(_player);
