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
