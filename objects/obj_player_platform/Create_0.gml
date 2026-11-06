// Estados usados pelo jogador de plataforma.
enum PlayerStatePlatformer
{
    IDDLE,
    WALK,
    JUMP
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
jump_force = 15;

// Estado e direção visuais iniciais.
state = PlayerStatePlatformer.IDDLE;
dialogo_ativo = false;
direction = dir;
dir_state = "down";

// Pula quando há chão logo abaixo e o botão de pulo está pressionado.
check_jump = function()
{
    var _on_ground = place_meeting(x, y + 1, obj_ground);

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
