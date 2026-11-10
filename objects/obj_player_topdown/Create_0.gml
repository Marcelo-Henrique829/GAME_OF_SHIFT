// Estados disponíveis para a máquina de estados do jogador.
enum PlayerState
{
    IDDLE,
    WALK,
    STOP
}
// Movimento.
move_speed = 5;
def_spd = move_speed;
spd = 0;
dir = 270;
last_key = vk_down;
hspd = 0;
vspd = 0;

// Estado e direção visual iniciais.
state = PlayerState.IDDLE;
direction = dir;
dir_state = "down";

// Cria a câmera caso ela ainda não exista na sala.
if (!instance_exists(obj_camera))
{
    instance_create_layer(x, y, "Instances", obj_camera);
}

// Compartilha o menu com o player de plataforma, sem duplicar a UI.
if (!instance_exists(obj_UI_player))
{
    instance_create_layer(x, y, "Instances", obj_UI_player);
}
