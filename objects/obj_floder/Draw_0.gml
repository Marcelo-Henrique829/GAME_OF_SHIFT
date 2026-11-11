if (sprite_index == -1) exit;
// Todos os filhos usam a mesma medição no desenho e no End Step.
var _bounds = get_shortcut_bounds();

// Preserva o estado de desenho para os demais objetos.
var _font = draw_get_font();
var _halign = draw_get_halign();
var _valign = draw_get_valign();
var _color = draw_get_color();
var _alpha = draw_get_alpha();

// O fundo vem primeiro, ficando atrás do sprite e do texto.
if (hover_enabled && is_hovered && !global.fade_active)
{
    draw_set_color(hover_color);
    draw_set_alpha(clamp(hover_alpha, 0, 1) * image_alpha);
    draw_rectangle(_bounds.left, _bounds.top, _bounds.right, _bounds.bottom, false);
}
draw_set_color(_color);
draw_set_alpha(_alpha);
draw_self();

draw_set_font(text_font);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(text_color);
draw_set_alpha(image_alpha);
draw_text(_bounds.text_x, _bounds.text_y, text);

draw_set_font(_font);
draw_set_halign(_halign);
draw_set_valign(_valign);
draw_set_color(_color);
draw_set_alpha(_alpha);
