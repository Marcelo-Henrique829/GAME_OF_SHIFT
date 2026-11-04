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
