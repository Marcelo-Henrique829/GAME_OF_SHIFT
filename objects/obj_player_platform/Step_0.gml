// Atualiza os controles e a direção do jogador.
if (player_dead) state = PlayerStatePlatformer.DEAD;
if (state != PlayerStatePlatformer.DEAD)
{
    scr_inputs(true);
    if (dialogo_ativo && !global.player_in_menu)
    {
        aud_update_footsteps();
        exit;
    }
}
if (state != PlayerStatePlatformer.STOP && state != PlayerStatePlatformer.DEAD)
{
    scr_direction();

    // Aproxima a velocidade atual da desejada, freando também ao inverter o lado.
    var _target_hspd = lengthdir_x(spd, dir);
    var _slowing_down = abs(_target_hspd) < abs(hspd) || hspd * _target_hspd < 0;
    var _response = _slowing_down ? deceleration_lerp : acceleration_lerp;
    hspd = lerp(hspd, _target_hspd, clamp(_response, 0, 1));
    if (abs(hspd - _target_hspd) <= movement_epsilon) hspd = _target_hspd;

    if (hspd != 0) image_xscale = sign(hspd);
}

// A animação pode parar antes do movimento; o lerp continua até zerar a velocidade.
var _show_walk = abs(hspd) > max(0, idle_speed_deadzone);

// Executa o comportamento do estado atual.
switch (state)
{
    case PlayerStatePlatformer.DEAD:
        // Bloqueia o controle horizontal e o pulo, mantendo a gravidade abaixo.
        spd = 0;
        hspd = 0;
        if (sprite_index != spr_player_plataformer_ph_destroy)
        {
            sprite_index = spr_player_plataformer_ph_destroy;
            image_index = 0;
            image_speed = 1;
        }
    break;

    case PlayerStatePlatformer.STOP:
        sprite_index = spr_player_plataformer_ph_iddleRight;
        spd = 0;
        hspd = 0;
        vspd = 0;
    break;

    case PlayerStatePlatformer.IDDLE:
    case PlayerStatePlatformer.WALK:
        state = _show_walk ? PlayerStatePlatformer.WALK : PlayerStatePlatformer.IDDLE;
        sprite_index = _show_walk
            ? spr_player_plataformer_ph_WalkRight
            : spr_player_plataformer_ph_iddleRight;
        check_jump();
    break;

    case PlayerStatePlatformer.JUMP:
        sprite_index = spr_player_plataformer_ph_Jump;

        // Mantém o último quadro da animação de pulo.
        if (image_index >= image_number - 2)
        {
            image_index = image_number - 2;
        }

        // Retorna ao estado adequado quando aterrissa.
        if (is_on_ground())
        {
            state = _show_walk
                ? PlayerStatePlatformer.WALK
                : PlayerStatePlatformer.IDDLE;
        }
    break;
}
// Alterna os alvos do lerp para crescer e encolher suavemente enquanto está morto.
if (state == PlayerStatePlatformer.DEAD && dead_pulse_enabled)
{
    var _pulse_min = max(0.01, min(dead_pulse_min, dead_pulse_max));
    var _pulse_max = max(_pulse_min, max(dead_pulse_min, dead_pulse_max));
    var _pulse_target = dead_pulse_growing ? _pulse_max : _pulse_min;
    var _pulse_response = 1 - power(1 - clamp(dead_pulse_lerp, 0, 1),
        60 / max(1, game_get_speed(gamespeed_fps)));
    dead_pulse_scale = lerp(dead_pulse_scale, _pulse_target, _pulse_response);
    if (abs(dead_pulse_scale - _pulse_target) <= 0.005)
    {
        dead_pulse_growing = !dead_pulse_growing;
    }
}
else
{
    dead_pulse_scale = 1;
    dead_pulse_growing = true;
}

// Aplica a velocidade interpolada, gravidade e colisões.
direction = dir;
if (state != PlayerStatePlatformer.STOP) vspd += grv;
var _previous_x = x;
var _descending_before_collision = scr_colisao_jogador_plataforma();

var _footstep_sound = -1;
if (state == PlayerStatePlatformer.WALK && abs(x - _previous_x) > idle_speed_deadzone
    && !global.player_in_menu && !global.fade_active && is_on_ground())
{
    _footstep_sound = place_meeting(x, y + 1, obj_box) ? snd_walk_wood_sfx : snd_walk_grass_sfx;
}
aud_update_footsteps(_footstep_sound);

// Acumula a queda no ar e só dispara quando uma colisão para a descida sobre o chão.
if (state != PlayerStatePlatformer.STOP && !global.player_in_menu)
{
    if (vspd > 0)
    {
        fall_shake_elapsed += 1 / max(1, game_get_speed(gamespeed_fps));
    }
    else
    {
        // Exige queda anterior e apoio abaixo: paredes, tetos e repouso não disparam.
        var _landed = _descending_before_collision && fall_shake_elapsed > 0
            && is_on_ground();
        if (_landed)
        {
            fall_shake_elapsed += 1 / max(1, game_get_speed(gamespeed_fps));
            if (fall_shake_elapsed >= max(0, fall_shake_delay))
            {
                var _shake_time = fall_shake_elapsed - max(0, fall_shake_delay);
                var _strength = max(0, fall_shake_strength) + _shake_time * max(0, fall_shake_growth);
                var _limit = clamp(fall_shake_max_strength, 0, 60);
                global.shake = max(global.shake, clamp(_strength, 0, _limit));
            }
        }
        fall_shake_elapsed = 0;
    }
}

// Só emite depois das colisões: aterrissar, subir ou pausar interrompe o rastro.
if (fall_trail_enabled && visible && sprite_index != -1 && state != PlayerStatePlatformer.DEAD
    && state != PlayerStatePlatformer.STOP && !global.player_in_menu && vspd > 0)
{
    fall_trail_timer--;
    if (fall_trail_timer <= 0)
    {
        create_fall_trail(x, image_xscale, image_angle);

        // Acompanha a mesma cópia espelhada desenhada no Draw do jogador.
        var _mirror_x = room_width - x;
        if (espelhamento_ativo && _mirror_x > room_width * 0.5)
        {
            create_fall_trail(_mirror_x, -image_xscale, -image_angle);
        }

        fall_trail_timer = max(1, fall_trail_interval);
    }
}
else
{
    fall_trail_timer = 0;
}

// Emite mesmo parado no chão; o obj_disapear move e apaga cada silhueta.
if (state == PlayerStatePlatformer.DEAD && dead_trail_enabled && visible && sprite_index != -1)
{
    dead_trail_timer--;
    if (dead_trail_timer <= 0)
    {
        for (var _i = 0; _i < max(0, floor(dead_trail_count)); _i++)
        {
            var _trail = create_fall_trail(x, image_xscale, image_angle);
            _trail.direction = random(360);
            _trail.speed = random_range(max(0, min(dead_trail_speed_min, dead_trail_speed_max)),
                max(0, max(dead_trail_speed_min, dead_trail_speed_max)));
        }
        dead_trail_timer = max(1, dead_trail_interval);
    }
}
