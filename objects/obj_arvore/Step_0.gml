// Ordena a árvore conforme sua posição vertical na sala.
depth = -y;

var _player = instance_find(obj_player_topdown, 0);
var _player_behind = false;

// Com depth = -y, o personagem atrás da árvore tem um depth maior.
if (instance_exists(_player))
{
    _player_behind = _player.depth > depth;
}

var _target_alpha = _player_behind ? 0.5 : 1;
image_alpha = lerp(image_alpha, _target_alpha, 0.1);
