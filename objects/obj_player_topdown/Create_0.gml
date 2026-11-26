// Estados disponíveis para a máquina de estados do jogador.
enum PlayerState
{
    IDDLE,
    WALK,
    STOP
}
// Movimento.
move_speed = 15;
def_spd = move_speed;
spd = 0;
dir = 270;
last_key = vk_down;
hspd = 0;
vspd = 0;

footstep_sound = -1;
footstep_audio_id = -1;
var _floor_layer = layer_get_id("Tile_floor");
footstep_floor_tilemap = (_floor_layer == -1) ? -1 : layer_tilemap_get_id(_floor_layer);

// Objetos colidíveis. Os filhos dos objetos pais também entram na colisão.
objetos_colisiveis = [obj_arvore, obj_construct_ph];

image_xscale = 0.5
image_yscale = 0.5
// Estado e direção visual iniciais.
state = PlayerState.IDDLE;
direction = dir;
dir_state = "down";
image_speed = 0;

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
