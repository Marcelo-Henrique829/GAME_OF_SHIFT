// Libera a cópia da cena e as camadas temporárias ao sair da sala.
if (surface_exists(agua_superficie_seca)) surface_free(agua_superficie_seca);
if (layer_exists(agua_camada_captura)) layer_destroy(agua_camada_captura);
if (layer_exists(agua_camada_restaura)) layer_destroy(agua_camada_restaura);
if (layer_exists(agua_camada_fx))
{
    if (agua_camada_fx_criada) layer_destroy(agua_camada_fx);
    else layer_depth(agua_camada_fx, agua_profundidade_original);
}
