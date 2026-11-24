/// @function scr_anim_topdown_player()
/// @description Alterna entre as poses paradas e a caminhada nas quatro direções.
function scr_anim_topdown_player()
{
    scr_dir_state_4_directions();

    var _walking = (state == PlayerState.WALK && spd > 0);
    var _next_sprite = spr_player_tpd_ph_down;

    switch (dir_state)
    {
        case "up":
            _next_sprite = _walking ? spr_player_tpd_ph_walk_up : spr_player_tpd_ph_up;
        break;

        case "down":
            _next_sprite = _walking ? spr_player_tpd_ph_walk_down : spr_player_tpd_ph_down;
        break;

        case "right":
            _next_sprite = _walking ? spr_player_tpd_ph_walk_right : spr_player_tpd_ph_rigth;
        break;

        case "left":
            _next_sprite = _walking ? spr_player_tpd_ph_walk_left : spr_player_tpd_ph_left;
        break;
    }

    // Só reinicia a animação quando a sprite realmente muda.
    if (sprite_index != _next_sprite)
    {
        sprite_index = _next_sprite;
        image_index = 0;
    }

    // 1 respeita os 10 FPS definidos nas sprites de caminhada.
    // IDDLE e STOP mantêm a pose na última direção escolhida.
    image_speed = _walking ? 1 : 0;
}

/// @function scr_dir_state_4_directions()
/// @description Converte o ângulo do player em uma das quatro direções visuais.
function scr_dir_state_4_directions()
{
    if (dir >= 45 && dir < 135)
    {
        dir_state = "up";
    }
    else if (dir >= 135 && dir < 225)
    {
        dir_state = "left";
    }
    else if (dir >= 225 && dir < 315)
    {
        dir_state = "down";
    }
    else
    {
        dir_state = "right";
    }
}

/// @function scr_direction()
/// @description Atualiza a direção e a velocidade com base nos inputs do jogador.
function scr_direction()
{
    var _i = global.inputs;
    var _horizontal = _i.right - _i.left;
    var _vertical = _i.down - _i.up;

    // Guarda a última direção pressionada para resolver inputs opostos.
    if (_i.left_p) last_key = vk_left;
    if (_i.right_p) last_key = vk_right;
    if (_i.up_p) last_key = vk_up;
    if (_i.down_p) last_key = vk_down;

    if (_horizontal != 0 || _vertical != 0)
    {
        dir = point_direction(0, 0, _horizontal, _vertical);
        spd = def_spd;
    }
    else
    {
        spd = 0;
    }

    // Quando os dois lados de um eixo estão pressionados, prioriza o último.
    if (_i.left && _i.right)
    {
        dir = (last_key == vk_right) ? 0 : 180;
    }

    if (_i.down && _i.up)
    {
        dir = (last_key == vk_up) ? 90 : 270;
    }
}
