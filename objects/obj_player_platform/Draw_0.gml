// Desenha o jogador na posição real.
draw_self();

// Reflete a posição pelo centro da sala e desenha a cópia apenas à direita.
var _mirror_x = room_width - x;
if (espelhamento_ativo && _mirror_x > room_width * 0.5)
{
    draw_sprite_ext(
        sprite_index,
        image_index,
        _mirror_x,
        y,
        -image_xscale,
        image_yscale,
        -image_angle,
        image_blend,
        image_alpha
    );
}
