// Velocidade em pixels por frame.
move_speed = 4;
def_spd = move_speed;
spd = 0;
dir = 270;
last_key = vk_down;
hspd = 0;
vspd = 0;
direction = dir;

if (!instance_exists(obj_camera))
{
    instance_create_layer(x, y, "Instances", obj_camera);
}
