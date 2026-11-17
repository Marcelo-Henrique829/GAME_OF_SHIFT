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
