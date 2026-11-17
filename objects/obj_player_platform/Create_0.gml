// Estados usados pelo jogador de plataforma.
enum PlayerStatePlatformer
{
    IDDLE,
    WALK,
    JUMP,
    STOP
}

// Parâmetros e velocidades do movimento.
move_speed = 5;
def_spd = move_speed;
spd = 0;
hspd = 0;
vspd = 0;
dir = 270;
last_key = vk_down;
grv = 0.5;
jump_force = 10;

// Estado e direção visuais iniciais.
state = PlayerStatePlatformer.IDDLE;
dialogo_ativo = false;
direction = dir;
dir_state = "down";

// Usa os objetos de chão e o tilemap tlColision da sala atual como colisores.
collision_targets = [obj_ground];
var _collision_layer = layer_get_id("tlColision");
if (_collision_layer != -1)
{
    var _collision_tilemap = layer_tilemap_get_id(_collision_layer);
    if (_collision_tilemap != -1)
    {
        array_push(collision_targets, _collision_tilemap);
    }
}

// Pula quando há chão logo abaixo e o botão de pulo está pressionado.
check_jump = function()
{
    var _on_ground = place_meeting(x, y + 1, collision_targets);

    if (_on_ground && global.inputs.dash)
    {
        vspd -= jump_force;
        state = PlayerStatePlatformer.JUMP;
    }

    return _on_ground;
};

// Garante que a câmera exista na sala.
if (!instance_exists(obj_camera))
{
    instance_create_layer(x, y, "Instances", obj_camera);
}

// A UI acompanha o player e existe uma única vez por sala.
if (!instance_exists(obj_UI_player))
{
    instance_create_layer(x, y, "Instances", obj_UI_player);
}
