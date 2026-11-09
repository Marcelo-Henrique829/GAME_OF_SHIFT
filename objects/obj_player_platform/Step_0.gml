// Atualiza os controles e a direção do jogador.
scr_inputs(true);
if (dialogo_ativo && !global.player_in_menu) exit;
if (state != PlayerStatePlatformer.STOP)
{
    scr_direction();
    if (hspd != 0) image_xscale = sign(hspd);
}

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
        sprite_index = spr_player_plataformer_ph_iddleRight;
        check_jump();

        if (state != PlayerStatePlatformer.JUMP && hspd!= 0)
        {
            state = PlayerStatePlatformer.WALK;
        }
    break;

    case PlayerStatePlatformer.WALK:
        sprite_index = spr_player_plataformer_ph_WalkRight;
        check_jump();

        if (state != PlayerStatePlatformer.JUMP && hspd = 0)
        {
            state = PlayerStatePlatformer.IDDLE;
        }
    break;

    case PlayerStatePlatformer.JUMP:
        sprite_index = spr_player_plataformer_ph_Jump;

        // Mantém o último quadro da animação de pulo.
        if (image_index >= image_number - 2)
        {
            image_index = image_number - 2;
        }

        // Retorna ao estado adequado quando aterrissa.
        if (vspd >= 0 && place_meeting(x, y + 1, obj_ground))
        {
            state = (spd > 0)
                ? PlayerStatePlatformer.WALK
                : PlayerStatePlatformer.IDDLE;
        }
    break;
}

// Aplica movimento horizontal, gravidade e colisões.
direction = dir;
hspd = lengthdir_x(spd, dir);
if (state != PlayerStatePlatformer.STOP) vspd += grv;
scr_colision(obj_ground);
