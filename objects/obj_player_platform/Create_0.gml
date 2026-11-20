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
// Resposta do movimento horizontal (0 a 1): valores maiores respondem mais rápido.
acceleration_lerp = 0.18;
deceleration_lerp = 0.25;
movement_epsilon = 0.05; // Encerra a interpolação para evitar deslize residual.
idle_speed_deadzone = 0.5; // Usa o sprite parado abaixo desta velocidade, sem cortar o movimento.
spd = 0;
hspd = 0;
vspd = 0;
dir = 270;
last_key = vk_down;
grv = 0.5;
jump_force = 12;

// Coyote time: permite pular por mais 6 frames após sair da borda (0,1 s a 60 FPS).
coyote_frames = 6;
coyote_timer = 0;

// Tempo mínimo de queda para tremer ao aterrissar; a força cresce com a duração da queda.
fall_shake_delay = 0.35;
fall_shake_strength = 6; // Intensidade inicial em pixels de tela.
fall_shake_growth = 8; // Intensidade adicional por segundo além do tempo mínimo.
fall_shake_max_strength = 24; // Limite de intensidade, de 0 a 60.
fall_shake_elapsed = 0;

// Rastro de silhuetas durante a queda. Intervalo e duração são medidos em frames.
fall_trail_enabled = true;
fall_trail_interval = 2;
fall_trail_timer = 0;
fall_trail_alpha = 0.5;
fall_trail_fade = 0.035;
fall_trail_growth = 0.012;
fall_trail_colour = make_colour_rgb(110, 205, 255);

// Guarda o quadro atual em uma cópia independente, atrás do personagem.
create_fall_trail = function(_x, _xscale, _angle)
{
    var _trail = instance_create_depth(_x, y, depth + 1, obj_disapear);
    _trail.sprite_index = sprite_index;
    _trail.image_index = floor(image_index);
    _trail.image_speed = 0;
    _trail.image_xscale = _xscale;
    _trail.image_yscale = image_yscale;
    _trail.image_angle = _angle;
    _trail.image_blend = merge_colour(image_blend, fall_trail_colour, 0.7);
    _trail.image_alpha = image_alpha * clamp(fall_trail_alpha, 0, 1);
    _trail.disapear_spd = max(0.001, fall_trail_fade);
    _trail.disapear_scale_spd = fall_trail_growth;
};

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

// Pula no chão ou dentro da pequena tolerância após sair da borda.
check_jump = function()
{
    var _on_ground = vspd >= 0 && place_meeting(x, y + 1, collision_targets);
    var _can_jump = _on_ground || coyote_timer > 0;

    if (_on_ground)
    {
        coyote_timer = max(0, coyote_frames);
    }
    else
    {
        coyote_timer = max(0, coyote_timer - 1);
    }

    if (_can_jump && global.inputs.dash)
    {
        // Mantém a força completa mesmo se já começou a cair e consome a tolerância.
        vspd = -jump_force;
        coyote_timer = 0;
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
