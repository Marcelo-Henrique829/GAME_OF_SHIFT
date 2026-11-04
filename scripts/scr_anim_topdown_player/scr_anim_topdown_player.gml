/// @function scr_anim_nalu()
/// @description Escolhe as sprites placeholder conforme direção e movimento.
function scr_anim_topdown_player()
{
    scr_dir_state_4_directions();

    var _moving = (abs(hspd) > 0 || abs(vspd) > 0);
    var _next_sprite;

    switch (dir_state)
    {
        case "up":
            // Ainda não existe sprite de caminhada para cima; usa o placeholder parado.
            _next_sprite = _moving ? spr_topdown_player_walk_up : spr_topdown_player_up;
        break;

        case "down":
            _next_sprite = _moving ? spr_topdown_player_walk_down : spr_topdown_player_down;
        break;

        case "right":
            _next_sprite = _moving ? spr_topdown_player_walk_rigth : spr_topdown_player_rigth;
        break;

        case "left":
            _next_sprite = _moving ? spr_topdown_player_walk_left : spr_topdown_player_left;
        break;
    }

    // Só reinicia a animação quando a sprite realmente muda.
    if (sprite_index != _next_sprite)
    {
        sprite_index = _next_sprite;
        image_index = 0;
    }
}
