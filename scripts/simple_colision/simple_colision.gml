/// @function scr_colision(_colliders)
/// @description Move o objeto atual em cada eixo e para ao encontrar colisores.
function scr_colision(_colliders = all)
{
    var _remaining_x = abs(hspd);
    var _direction_x = sign(hspd);

    while (_remaining_x > 0)
    {
        var _step_x = min(1, _remaining_x) * _direction_x;
        if (place_meeting(x + _step_x, y, _colliders))
        {
            hspd = 0;
            break;
        }

        x += _step_x;
        _remaining_x -= abs(_step_x);
    }

    var _remaining_y = abs(vspd);
    var _direction_y = sign(vspd);

    while (_remaining_y > 0)
    {
        var _step_y = min(1, _remaining_y) * _direction_y;
        if (place_meeting(x, y + _step_y, _colliders))
        {
            vspd = 0;
            break;
        }

        y += _step_y;
        _remaining_y -= abs(_step_y);
    }
}
