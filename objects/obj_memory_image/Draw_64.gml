#region Preparação da GUI
// Os textos aparecem junto da memória, depois da transição de sala.
if (global.fade_active || !memoria_revelando || memoria_alpha <= 0 || image_alpha <= 0)
{
    exit;
}

var _fonte_anterior = draw_get_font();
var _halign_anterior = draw_get_halign();
var _valign_anterior = draw_get_valign();
var _cor_anterior = draw_get_colour();
var _alpha_anterior = draw_get_alpha();
draw_set_font(menu_font);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(clamp(memoria_alpha * image_alpha, 0, 1));
#endregion

#region Título
// Centraliza o título no topo, acompanhando o alpha de aparição da imagem.
var _margem_titulo = max(0, memoria_titulo_margem);
var _largura_titulo = max(1, display_get_gui_width() - _margem_titulo * 2);
var _escala_para_caber = _largura_titulo / max(1, string_width(memoria_titulo));
var _escala_titulo = min(memoria_titulo_escala, _escala_para_caber);
var _titulo_x = display_get_gui_width() * 0.5;
var _titulo_y = _margem_titulo + string_height("Mg") * _escala_titulo * 0.5;
draw_set_colour(memoria_sombra_cor);
draw_text_transformed(_titulo_x + memoria_sombra_offset_x, _titulo_y + memoria_sombra_offset_y,
    memoria_titulo, _escala_titulo, _escala_titulo, 0);
draw_set_colour(memoria_titulo_cor);
draw_text_transformed(_titulo_x, _titulo_y, memoria_titulo, _escala_titulo, _escala_titulo, 0);
#endregion

#region Botão de navegação
// Reaproveita a posição e o destaque calculados no End Step.
var _escala = menu_text_scale * menu_scale;
draw_set_colour(memoria_sombra_cor);
draw_text_transformed(menu_gui_x + memoria_sombra_offset_x, menu_gui_y + memoria_sombra_offset_y,
    menu_texto, _escala, _escala, 0);
if (menu_hovered)
{
    draw_set_colour(menu_cor_hover);
}
else
{
    draw_set_colour(menu_cor);
}
draw_text_transformed(menu_gui_x, menu_gui_y, menu_texto, _escala, _escala, 0);
#endregion

#region Restauração do desenho
draw_set_font(_fonte_anterior);
draw_set_halign(_halign_anterior);
draw_set_valign(_valign_anterior);
draw_set_colour(_cor_anterior);
draw_set_alpha(_alpha_anterior);
#endregion
