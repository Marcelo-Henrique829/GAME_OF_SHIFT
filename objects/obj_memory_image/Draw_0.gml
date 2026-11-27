#region Transformação da memória
if (memoria_alpha <= 0 || image_alpha <= 0)
{
    exit;
}

// Aplica a escala da aparição ao conjunto de imagens usando draw_sprite().
var _matriz_anterior = matrix_get(matrix_world);
var _alpha_anterior = draw_get_alpha();
var _matriz_memoria = matrix_build(x, y, 0, 0, 0, image_angle,
    image_xscale * memoria_escala, image_yscale * memoria_escala,
    1);
matrix_set(matrix_world, matrix_multiply(_matriz_memoria, _matriz_anterior));
var _alpha_memoria = clamp(image_alpha * memoria_alpha, 0, 1);
draw_set_alpha(_alpha_memoria);
#endregion

#region Imagens e moldura
var _moldura = memoria_moldura_sprite;
var _tem_moldura = sprite_exists(_moldura);
if (_tem_moldura)
{
    // Como no obj_window, evita que as margens imponham um tamanho mínimo.
    var _nine_slice = sprite_get_nineslice(_moldura);
    var _nine_slice_ativo = _nine_slice.enabled;
    _nine_slice.enabled = false;
}

for (var _i = 0; _i < array_length(memoria_imagens); _i++)
{
    var _imagem = memoria_imagens[_i];
    if (!sprite_exists(_imagem.sprite))
    {
        continue;
    }
    draw_sprite(_imagem.sprite, _imagem.subimagem, _imagem.offset_x, _imagem.offset_y);

    if (_tem_moldura)
    {
        // Ajusta a moldura a cada imagem, compensando as origens dos sprites.
        var _scale_x = sprite_get_width(_imagem.sprite) / sprite_get_width(_moldura);
        var _scale_y = sprite_get_height(_imagem.sprite) / sprite_get_height(_moldura);
        var _draw_x = _imagem.offset_x - sprite_get_xoffset(_imagem.sprite)
            + sprite_get_xoffset(_moldura) * _scale_x;
        var _draw_y = _imagem.offset_y - sprite_get_yoffset(_imagem.sprite)
            + sprite_get_yoffset(_moldura) * _scale_y;
        draw_sprite_ext(_moldura, 0, _draw_x, _draw_y,
            _scale_x, _scale_y, 0, c_white, _alpha_memoria);
    }
}
#endregion

#region Restauração do desenho
// Restaura o estado de desenho para os outros objetos da sala.
if (_tem_moldura)
{
    _nine_slice.enabled = _nine_slice_ativo;
}
matrix_set(matrix_world, _matriz_anterior);
draw_set_alpha(_alpha_anterior);
#endregion
