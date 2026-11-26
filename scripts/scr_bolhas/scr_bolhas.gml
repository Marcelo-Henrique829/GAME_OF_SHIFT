#region Configuração do gerador

/// @function scr_bolhas_iniciar_gerador()
/// @description Define os parâmetros de geração de bolhas no Create do controlador.
function scr_bolhas_iniciar_gerador()
{
    // Capacidade da sala e intervalo de reposição em Steps.
    bolhas_maximo = 60;
    bolhas_intervalo = 15;
    bolhas_tempo_ate_criar = 0; // A primeira bolha pode nascer no primeiro Step.

    // Escala relativa ao sprite, velocidade em pixels por Step e direção em graus.
    bolhas_escala_min = 0.05;
    bolhas_escala_max = 0.30;
    bolhas_velocidade_min = 0.10;
    bolhas_velocidade_max = 0.70;
    bolhas_direcao_min = 0;
    bolhas_direcao_max = 360;
}

#endregion

#region Geração das bolhas

/// @function scr_bolhas_atualizar_gerador()
/// @description Cria no máximo uma bolha por vez no Step do controlador.
function scr_bolhas_atualizar_gerador()
{
    // O limite inclui as bolhas colocadas no editor. Ao liberar uma vaga,
    // o contador zerado permite repô-la já no próximo Step do controlador.
    var _maximo = max(0, floor(bolhas_maximo));
    var _quantidade_atual = instance_number(obj_buble);
    if (_quantidade_atual >= _maximo)
    {
        bolhas_tempo_ate_criar = 0;
        return;
    }

    bolhas_tempo_ate_criar = max(0, bolhas_tempo_ate_criar - 1);
    if (bolhas_tempo_ate_criar > 0)
    {
        return;
    }
    bolhas_tempo_ate_criar = max(1, floor(bolhas_intervalo));

    // Ordena os limites configurados antes de sortear. Escala precisa ser positiva
    // e a menor velocidade permitida é zero.
    var _escala_min = min(bolhas_escala_min, bolhas_escala_max);
    var _escala_max = max(bolhas_escala_min, bolhas_escala_max);
    _escala_min = max(0.01, _escala_min);
    _escala_max = max(_escala_min, _escala_max);

    var _velocidade_min = min(bolhas_velocidade_min, bolhas_velocidade_max);
    var _velocidade_max = max(bolhas_velocidade_min, bolhas_velocidade_max);
    _velocidade_min = max(0, _velocidade_min);
    _velocidade_max = max(_velocidade_min, _velocidade_max);

    var _direcao_min = min(bolhas_direcao_min, bolhas_direcao_max);
    var _direcao_max = max(bolhas_direcao_min, bolhas_direcao_max);
    var _escala = random_range(_escala_min, _escala_max);

    // A bolha nasce em um ponto da sala. Seu Create já a move para a camada de bolhas.
    var _bolha = instance_create_layer(random(room_width), random(room_height), layer, obj_buble);
    _bolha.image_xscale = _escala;
    _bolha.image_yscale = _escala;
    _bolha.speed = random_range(_velocidade_min, _velocidade_max);
    _bolha.direction = random_range(_direcao_min, _direcao_max);
}

#endregion

#region Comportamento de cada bolha

/// @function scr_bolha_iniciar()
/// @description Configura a instância e a ondulação compartilhada pelas bolhas.
function scr_bolha_iniciar()
{
    // Valores das bolhas do editor. O gerador ajusta as propriedades que sorteou.
    speed = 0.3;
    direction = 90;
    image_alpha = 0.55;

    // A primeira bolha cria a camada e seu filtro. As demais reaproveitam os dois.
    var _camada = layer_get_id("layer_bolhas");
    if (_camada == -1)
    {
        _camada = layer_create(-1000, "layer_bolhas");

        var _ondulacao = fx_create("_filter_ripples");
        fx_set_single_layer(_ondulacao, true);
        fx_set_parameter(_ondulacao, "g_RipplesSpeed", 2);
        fx_set_parameter(_ondulacao, "g_RipplesWidth", 64);
        fx_set_parameter(_ondulacao, "g_RipplesAmplitude", 0.5);
        layer_set_fx(_camada, _ondulacao);
    }
    layer = _camada;
}

/// @function scr_bolha_remover_fora_da_sala()
/// @description Remove a bolha no End Step quando todo o sprite estiver fora da sala.
function scr_bolha_remover_fora_da_sala()
{
    // O End Step já recebe a posição atualizada pelo movimento automático.
    if (bbox_right < 0 || bbox_left > room_width
        || bbox_bottom < 0 || bbox_top > room_height)
    {
        instance_destroy();
    }
}

#endregion
