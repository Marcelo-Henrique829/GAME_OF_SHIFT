// Pulsa apenas o desenho, sem aumentar ou reduzir a máscara usada nas colisões.
var _pulse = (state == PlayerStatePlatformer.DEAD && dead_pulse_enabled) ? dead_pulse_scale : 1;
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _pulse,
    image_yscale * _pulse, image_angle, image_blend, image_alpha);

// Reflete a posição pelo centro da sala e desenha a cópia apenas à direita.
var _mirror_x = room_width - x;
if (espelhamento_ativo && _mirror_x > room_width * 0.5)
{
    draw_sprite_ext(
        sprite_index,
        image_index,
        _mirror_x,
        y,
        -image_xscale * _pulse,
        image_yscale * _pulse,
        -image_angle,
        image_blend,
        image_alpha
    );
}
