// Mantém o desenho durante o fade-out, mesmo após sair do limite.
if (arraste_borda_alpha <= 0 || image_alpha <= 0 || sprite_index == -1) exit;
var _raio = max(0, arraste_raio);

var _cor_anterior = draw_get_colour();
var _alpha_anterior = draw_get_alpha();
draw_set_colour(c_red);
draw_set_alpha(clamp(arraste_borda_alpha, 0, 0.7));
// Um anel preenchido permite controlar a espessura sem preencher o círculo.
var _espessura = max(0, arraste_borda_espessura);
var _raio_interno = max(0, _raio - _espessura * 0.5);
var _raio_externo = _raio + _espessura * 0.5;
if (_espessura > 0)
{
    var _segmentos = 128;
    draw_primitive_begin(pr_trianglestrip);
    for (var _i = 0; _i <= _segmentos; _i++)
    {
        var _angulo = (_i mod _segmentos) * 360 / _segmentos;
        var _cos = dcos(_angulo);
        var _sin = dsin(_angulo);
        draw_vertex(arraste_origem_x + _cos * _raio_externo,
            arraste_origem_y + _sin * _raio_externo);
        draw_vertex(arraste_origem_x + _cos * _raio_interno,
            arraste_origem_y + _sin * _raio_interno);
    }
    draw_primitive_end();
}
draw_set_colour(_cor_anterior);
draw_set_alpha(_alpha_anterior);
