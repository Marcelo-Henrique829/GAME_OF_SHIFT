scr_inputs(true);
scr_direction();

// A direção é armazenada no player e convertida em velocidade para colisão.
direction = dir;
hspd = lengthdir_x(spd, dir);
vspd = lengthdir_y(spd, dir);
scr_colision(all);
