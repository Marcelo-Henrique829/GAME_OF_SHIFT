if (!is_struct(dialogo) || !variable_struct_exists(dialogo, "texto")) exit;
var _ultima_pagina = array_length(dialogo.texto) - 1;
if (_ultima_pagina < 0) exit;

scr_inputs();
pag = clamp(pag, 0, _ultima_pagina);
var _tamanho_texto = string_length(dialogo.texto[pag]);

// Enter ou clique revela o restante do texto, avança ou fecha o balão.
if (global.inputs.enter)
{
    if (indice < _tamanho_texto)
    {
        indice = _tamanho_texto;
        exit;
    }
    if (pag == _ultima_pagina)
    {
        libera_player();
        exit;
    }

    pag++;
    indice = 0;
    _tamanho_texto = string_length(dialogo.texto[pag]);
}

var _velocidade = variable_struct_exists(dialogo, "txt_vel") ? dialogo.txt_vel : 1;
if (global.inputs.attack || global.inputs.fast_dialog) _velocidade = 0.8;
indice = min(indice + _velocidade, _tamanho_texto);
