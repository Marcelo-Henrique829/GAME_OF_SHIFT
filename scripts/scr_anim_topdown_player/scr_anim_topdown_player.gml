/// @function scr_anim_topdown_player()
/// @description Escolhe as sprites da pasta tpd_ph conforme a direção.
function scr_anim_topdown_player()
{
    scr_dir_state_4_directions();

    var _next_sprite;

    switch (dir_state)
    {
        case "up":
            _next_sprite = spr_player_tpd_ph_up;
        break;

        case "down":
            _next_sprite = spr_player_tpd_ph_down;
        break;

        case "right":
            _next_sprite = spr_player_tpd_ph_rigth;
        break;

        case "left":
            _next_sprite = spr_player_tpd_ph_left;
        break;
    }

    // Só reinicia a animação quando a sprite realmente muda.
    if (sprite_index != _next_sprite)
    {
        sprite_index = _next_sprite;
        image_index = 0;
    }
}
