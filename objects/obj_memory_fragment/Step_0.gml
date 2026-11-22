if (!tremida_ativa || tremida_raio <= 0) exit;

var _player = instance_nearest(x, y, obj_player_platform);
if (_player == noone) exit;

var _distancia = point_distance(x, y, _player.x, _player.y);
if (_distancia >= tremida_raio) exit;

// A força cresce de zero na borda do raio até o máximo junto ao fragmento.
var _proximidade = clamp(1 - _distancia / tremida_raio, 0, 1);
var _forca = lerp(0, clamp(tremida_forca_max, 0, 60), _proximidade);
// Não soma a força de vários fragmentos nem reduz tremidas de outros efeitos.
global.shake = max(global.shake, _forca);
