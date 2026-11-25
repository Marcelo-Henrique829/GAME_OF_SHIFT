/// @function scr_create_dialogue(_texto)
/// @description Abre um balão de texto. Retorna noone se já houver um diálogo ou se o texto for inválido.
/// @param {string} _texto Texto exibido no balão.
function scr_create_dialogue(_texto)
{
    if (!is_string(_texto) || _texto == "" || instance_exists(Obj_dialogo)) return noone;

    var _dialogo = instance_create_depth(0, 0, -1000, Obj_dialogo);
    _dialogo.dialogo = { texto: [_texto] };
    return _dialogo;
}
