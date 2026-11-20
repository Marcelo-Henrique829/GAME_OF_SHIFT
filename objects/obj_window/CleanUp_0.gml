if (!is_struct(janela_dados)) exit;

// A última janela remove a captura do background e libera as superfícies compartilhadas.
for (var _i = 0; _i < instance_number(obj_window); _i++)
{
    var _janela = instance_find(obj_window, _i);
    if (_janela == id || !variable_instance_exists(_janela, "janela_dados")) continue;
    if (is_struct(_janela.janela_dados) && _janela.janela_dados == janela_dados) exit;
}

if (layer_exists(janela_dados.camada))
{
    layer_script_end(janela_dados.camada, janela_dados.script_fim_anterior);
}
for (var _i = 0; _i < array_length(janela_dados.camadas_janela); _i++)
{
    var _registro = janela_dados.camadas_janela[_i];
    if (layer_exists(_registro.camada)) layer_script_begin(_registro.camada, _registro.anterior);
}
if (surface_exists(janela_dados.fundo)) surface_free(janela_dados.fundo);
if (surface_exists(janela_dados.recorte)) surface_free(janela_dados.recorte);
