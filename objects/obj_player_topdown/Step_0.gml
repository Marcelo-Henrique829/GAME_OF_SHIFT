// Atualiza as teclas e calcula a direção/velocidade desejadas.
scr_inputs(true);
if (state != PlayerState.STOP) scr_direction();
// Atualiza o estado conforme o jogador começou ou parou de se mover.
switch (state)
{
    case PlayerState.STOP:
        spd = 0;
        hspd = 0;
        vspd = 0;
    break;

    case PlayerState.IDDLE:
        if (spd > 0)
        {
            state = PlayerState.WALK;
        }
    break;

    case PlayerState.WALK:
        if (spd <= 0)
        {
            state = PlayerState.IDDLE;
        }
    break;
}

// Converte direção e velocidade em movimento e resolve colisões.
direction = dir;
hspd = lengthdir_x(spd, dir);
vspd = lengthdir_y(spd, dir);
var _previous_x = x;
var _previous_y = y;
scr_colision(objetos_colisiveis);
depth = -y;

var _footstep_sound = -1;
if (state == PlayerState.WALK && (x != _previous_x || y != _previous_y)
    && !global.player_in_menu && !global.fade_active)
{
    var _floor_tile = (footstep_floor_tilemap == -1)
        ? -1 : tilemap_get_at_pixel(footstep_floor_tilemap, x, bbox_bottom);
    var _on_indoor_floor = _floor_tile != -1 && tile_get_index(_floor_tile) != 0;
    _footstep_sound = _on_indoor_floor ? snd_walk_wood_sfx : snd_walk_grass_sfx;
}
aud_update_footsteps(_footstep_sound);

// Atualiza a sprite depois da resolução de colisões.
scr_anim_topdown_player();
