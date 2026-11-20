// A abertura é aplicada antes de desenhar esta camada, preservando o jogador
// e os demais elementos que estão nela. O sprite serve apenas como máscara.
if (!janela_ativa || sprite_index == -1) exit;

// Ajusta a moldura ao tamanho exato da máscara.
var _moldura = spr_window_template_ph;
var _scale_x = sprite_get_width(sprite_index) / sprite_get_width(_moldura) * image_xscale;
var _scale_y = sprite_get_height(sprite_index) / sprite_get_height(_moldura) * image_yscale;

// Alinha as origens dos sprites, inclusive com rotação ou escala negativa.
var _offset_x = sprite_get_xoffset(_moldura) * _scale_x
    - sprite_get_xoffset(sprite_index) * image_xscale;
var _offset_y = sprite_get_yoffset(_moldura) * _scale_y
    - sprite_get_yoffset(sprite_index) * image_yscale;
var _draw_x = x + lengthdir_x(_offset_x, image_angle)
    + lengthdir_x(_offset_y, image_angle - 90);
var _draw_y = y + lengthdir_y(_offset_x, image_angle)
    + lengthdir_y(_offset_y, image_angle - 90);

// As margens do template não devem impor um tamanho mínimo à janela.
var _nine_slice = sprite_get_nineslice(_moldura);
var _nine_slice_ativo = _nine_slice.enabled;
_nine_slice.enabled = false;
draw_sprite_ext(_moldura, 0, _draw_x, _draw_y, _scale_x, _scale_y,
    image_angle, image_blend, image_alpha);
_nine_slice.enabled = _nine_slice_ativo;
