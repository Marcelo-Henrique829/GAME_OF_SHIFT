#region Efeito subaquático na metade direita
// Defina como false para desativar o filtro de água. Pode mudar durante o jogo.
agua_filtro_ativo = false;

// Coordenada do mundo onde começa a água; acompanha a câmera e o zoom.
agua_inicio_x = room_width * 0.5;
agua_superficie_seca = -1;
agua_largura_seca = 0;

// Reaproveita o filtro configurado no editor da sala.
agua_camada_fx = layer_get_id("Effect_1");
agua_camada_fx_criada = (agua_camada_fx == -1);
agua_profundidade_original = 0;
if (agua_camada_fx_criada)
{
    agua_camada_fx = layer_create(0, "layer_underwater_right_fx");
    layer_set_fx(agua_camada_fx, fx_create("_filter_underwater"));
}
else
{
    agua_profundidade_original = layer_get_depth(agua_camada_fx);
}

// Inclui todas as camadas, inclusive a camada de bolhas criada em -1000.
var _frente = -1000;
var _camadas = layer_get_all();
for (var _i = 0; _i < array_length(_camadas); _i++)
{
    _frente = min(_frente, layer_get_depth(_camadas[_i]));
}
agua_camada_captura = layer_create(_frente - 1, "layer_underwater_capture");
layer_depth(agua_camada_fx, _frente - 2);
layer_enable_fx(agua_camada_fx, agua_filtro_ativo);
fx_set_single_layer(layer_get_fx(agua_camada_fx), false);
agua_camada_restaura = layer_create(_frente - 3, "layer_underwater_restore");

// Captura a parte seca antes de o filtro nativo processar a cena completa.
layer_script_begin(agua_camada_captura, method(id, function()
{
    if (event_type != ev_draw || event_number != ev_draw_normal) return;
    layer_enable_fx(agua_camada_fx, agua_filtro_ativo);
    agua_largura_seca = 0;
    if (!agua_filtro_ativo) return;
    var _alvo = surface_get_target();
    if (!surface_exists(_alvo)) return;

    var _largura = surface_get_width(_alvo);
    var _altura = surface_get_height(_alvo);
    var _view_x = 0;
    var _view_largura = room_width;
    if (view_enabled && view_current >= 0)
    {
        var _camera = view_camera[view_current];
        if (_camera != -1)
        {
            _view_x = camera_get_view_x(_camera);
            _view_largura = camera_get_view_width(_camera);
        }
    }
    // Converte o limite no mundo em pixels da superfície, sem fixá-lo na tela.
    var _seca = clamp(ceil((agua_inicio_x - _view_x) / _view_largura * _largura), 0, _largura);
    if (_seca <= 0) return;

    if (surface_exists(agua_superficie_seca))
    {
        if (surface_get_width(agua_superficie_seca) != _largura
            || surface_get_height(agua_superficie_seca) != _altura)
        {
            surface_free(agua_superficie_seca);
            agua_superficie_seca = -1;
        }
    }
    if (!surface_exists(agua_superficie_seca))
    {
        agua_superficie_seca = surface_create(_largura, _altura);
    }
    if (!surface_exists(agua_superficie_seca)) return;

    surface_copy_part(agua_superficie_seca, 0, 0, _alvo, 0, 0, _seca, _altura);
    // A cópia deixa a textura de origem vinculada; libera antes do filtro
    // voltar a usar essa mesma superfície como alvo de desenho.
    texture_set_stage(0, -1);
    agua_largura_seca = _seca;
}));

// Uma camada separada garante que a cópia ocorra depois do filtro.
// Copiar pixels evita alterar matrizes, transparência ou o estado de desenho.
layer_script_begin(agua_camada_restaura, method(id, function()
{
    if (event_type != ev_draw || event_number != ev_draw_normal) return;
    if (!agua_filtro_ativo) return;
    if (agua_largura_seca <= 0 || !surface_exists(agua_superficie_seca)) return;
    var _alvo = surface_get_target();
    if (!surface_exists(_alvo)) return;

    surface_copy_part(_alvo, 0, 0, agua_superficie_seca, 0, 0,
        agua_largura_seca, surface_get_height(agua_superficie_seca));
}));
#endregion

#region Geração de bolhas
// Limite de obj_buble na sala e intervalo entre novas bolhas, em Steps.
bolhas_maximo = 10;
bolhas_intervalo = 15;

// Tamanho relativo ao sprite: 1 = tamanho original, 0.5 = metade.
bolhas_escala_min = 0.05;
bolhas_escala_max = 0.30;

// Velocidade em pixels por Step e direção em graus (0 a 360 = todas).
bolhas_velocidade_min = 0.10;
bolhas_velocidade_max = 0.70;
bolhas_direcao_min = 0;
bolhas_direcao_max = 360;

// Começa gerando uma bolha no primeiro Step.
bolhas_tempo_ate_criar = 0;
#endregion
