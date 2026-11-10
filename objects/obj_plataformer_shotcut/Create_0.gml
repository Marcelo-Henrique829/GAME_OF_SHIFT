text = "Plataformer";
// Distância em pixels entre a parte inferior do sprite e o topo do texto.
text_gap = 5;
text_font = fnt_shortcut;
text_color = c_white;

// Destaque ao passar o mouse sobre o conjunto (sprite + texto).
hover_enabled = true;       // false desliga o destaque.
hover_color = c_blue;       // Cor de preenchimento do quadrado.
hover_alpha = 0.25;         // 0 = invisível; 1 = totalmente opaco.
hover_padding = 8;          // Folga mínima, em pixels, ao redor do conteúdo.
// O controller consulta este estado para escolher a sprite do cursor.
is_hovered = false;
// O lado do quadrado é calculado automaticamente para caber o sprite e o texto,
// mesmo se mudar a fonte, o conteúdo, a escala do sprite ou text_gap.

// Destino do clique. O controller troca de sala somente após cobrir a tela.
target_room = Rm_platform_test;

// Compartilha a mesma área entre o clique e o desenho, sem depender do Draw
// do frame anterior. Medir o texto não deve mudar a fonte dos outros objetos.
get_shortcut_bounds = function()
{
    var _left = -sprite_get_xoffset(sprite_index) * image_xscale;
    var _right = (sprite_get_width(sprite_index) - sprite_get_xoffset(sprite_index)) * image_xscale;
    var _top = -sprite_get_yoffset(sprite_index) * image_yscale;
    var _bottom = (sprite_get_height(sprite_index) - sprite_get_yoffset(sprite_index)) * image_yscale;
    var _cos = dcos(image_angle);
    var _sin = dsin(image_angle);
    var _center_x = x + (_left + _right) * 0.5 * _cos + (_top + _bottom) * 0.5 * _sin;
    var _center_y = y - (_left + _right) * 0.5 * _sin + (_top + _bottom) * 0.5 * _cos;
    var _half_width = (abs((_right - _left) * _cos) + abs((_bottom - _top) * _sin)) * 0.5;
    var _half_height = (abs((_right - _left) * _sin) + abs((_bottom - _top) * _cos)) * 0.5;
    var _text_y = _center_y + _half_height + text_gap;

    var _old_font = draw_get_font();
    draw_set_font(text_font);
    var _content_width = max(_half_width * 2, string_width(text));
    var _content_top = min(_center_y - _half_height, _text_y);
    var _content_bottom = max(_center_y + _half_height, _text_y + string_height(text));
    draw_set_font(_old_font);

    var _half_side = max(_content_width, _content_bottom - _content_top) * 0.5 + max(0, hover_padding);
    var _hover_y = (_content_top + _content_bottom) * 0.5;
    return {
        left: _center_x - _half_side,
        right: _center_x + _half_side,
        top: _hover_y - _half_side,
        bottom: _hover_y + _half_side,
        text_x: _center_x,
        text_y: _text_y
    };
};
