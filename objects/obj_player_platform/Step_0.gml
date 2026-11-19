// Atualiza os controles e a direção do jogador.
scr_inputs(true);
if (dialogo_ativo && !global.player_in_menu) exit;
if (state != PlayerStatePlatformer.STOP)
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
        if (vspd >= 0 && place_meeting(x, y + 1, collision_targets))
        {
            state = _show_walk
                ? PlayerStatePlatformer.WALK
                : PlayerStatePlatformer.IDDLE;
        }
    break;
}
// Aplica a velocidade interpolada, gravidade e colisões.
direction = dir;
if (state != PlayerStatePlatformer.STOP) vspd += grv;
scr_colision(collision_targets);

// Só emite depois das colisões: aterrissar, subir ou pausar interrompe o rastro.
if (fall_trail_enabled && visible && sprite_index != -1
    && state != PlayerStatePlatformer.STOP && !global.player_in_menu && vspd > 0)
{
    fall_trail_timer--;
    if (fall_trail_timer <= 0)
    {
        create_fall_trail(x, image_xscale, image_angle);

        // Acompanha a mesma cópia espelhada desenhada no Draw do jogador.
        var _mirror_x = room_width - x;
        if (_mirror_x > room_width * 0.5)
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
