// Valores para bolhas colocadas manualmente na sala.
// O controlador substitui tamanho, velocidade e direção ao gerar novas bolhas.
speed = 0.3;
direction = 90;
image_alpha = 0.55;

// O ripple nativo é aplicado em uma camada exclusiva dos obj_buble.
// Todas as bolhas compartilham um único filtro para evitar um filtro por instância.
var _camada = layer_get_id("layer_bubles_ripple");
if (_camada == -1)
{
    _camada = layer_create(-1000, "layer_bubles_ripple");

    var _ripple = fx_create("_filter_ripples");
    fx_set_single_layer(_ripple, true);
    fx_set_parameter(_ripple, "g_RipplesSpeed", 2);
    fx_set_parameter(_ripple, "g_RipplesWidth", 64);
    fx_set_parameter(_ripple, "g_RipplesAmplitude", 0.5);
    layer_set_fx(_camada, _ripple);
}

// Mover para a camada mantém o desenho automático do sprite com o ripple.
layer = _camada;
