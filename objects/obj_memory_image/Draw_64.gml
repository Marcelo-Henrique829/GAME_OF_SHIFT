// Mesmo texto com sombra, fonte e destaque usados no menu de pausa.
if (global.fade_active || !memoria_revelando || memoria_alpha <= 0 || image_alpha <= 0) exit;

var _fonte_anterior = draw_get_font();
var _halign_anterior = draw_get_halign();
var _valign_anterior = draw_get_valign();
var _cor_anterior = draw_get_colour();
var _alpha_anterior = draw_get_alpha();
draw_set_font(menu_font);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(clamp(memoria_alpha * image_alpha, 0, 1));

// Centraliza o título no topo, acompanhando o alpha de aparição da imagem.
var _margem_titulo = max(0, memoria_titulo_margem);
var _largura_titulo = max(1, display_get_gui_width() - _margem_titulo * 2);
var _escala_titulo = min(menu_text_scale, _largura_titulo / max(1, string_width(memoria_titulo)));
var _titulo_x = display_get_gui_width() * 0.5;
var _titulo_y = _margem_titulo + string_height("Mg") * _escala_titulo * 0.5;
draw_set_colour(c_black);
draw_text_transformed(_titulo_x + 2, _titulo_y + 2, memoria_titulo, _escala_titulo, _escala_titulo, 0);
draw_set_colour(memoria_titulo_cor);
draw_text_transformed(_titulo_x, _titulo_y, memoria_titulo, _escala_titulo, _escala_titulo, 0);

var _escala = menu_text_scale * menu_scale;
draw_set_colour(c_black);
draw_text_transformed(menu_gui_x + 2, menu_gui_y + 2, "menu", _escala, _escala, 0);
draw_set_colour(menu_hovered ? c_yellow : c_white);
draw_text_transformed(menu_gui_x, menu_gui_y, "menu", _escala, _escala, 0);

draw_set_font(_fonte_anterior);
draw_set_halign(_halign_anterior);
draw_set_valign(_valign_anterior);
draw_set_colour(_cor_anterior);
draw_set_alpha(_alpha_anterior);
