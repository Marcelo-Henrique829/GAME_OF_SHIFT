// Atualiza as teclas e calcula a direção/velocidade desejadas.
scr_inputs(true);
scr_direction();

// Atualiza o estado conforme o jogador começou ou parou de se mover.
switch (state)
{
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
scr_colision(obj_test);

// Atualiza a sprite depois da resolução de colisões.
scr_anim_topdown_player();
