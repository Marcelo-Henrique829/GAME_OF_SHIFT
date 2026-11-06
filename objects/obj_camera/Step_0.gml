var _target = noone;

// Neste projeto, o personagem de plataforma se chama obj_player_platform.
if (instance_exists(obj_player_platform)) 
{
    _target = instance_find(obj_player_platform, 0);
} 
else if (instance_exists(obj_player_topdown)) 
{
    _target = instance_find(obj_player_topdown, 0);
}

if (_target == noone) exit;

var _view = view_camera[0];
var _view_width = camera_get_view_width(_view);
var _view_height = camera_get_view_height(_view);
var _camera_x = clamp(_target.x - _view_width * 0.5, 0, max(0, room_width - _view_width));
var _camera_y = clamp(_target.y - _view_height * 0.5, 0, max(0, room_height - _view_height));

camera_set_view_pos(_view, _camera_x, _camera_y);
