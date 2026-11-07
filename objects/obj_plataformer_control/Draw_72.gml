// Draw Begin desenha as três camadas antes do player e dos objetos da sala.
// Ordem do parallax: background, middleground e foreground.
parallax_draw(
    parallax_background_sprite, parallax_background_speed,
    parallax_background_offset_x, parallax_background_offset_y,
    parallax_background_repeat_x, parallax_background_repeat_y
);
parallax_draw(
    parallax_middleground_sprite, parallax_middleground_speed,
    parallax_middleground_offset_x, parallax_middleground_offset_y,
    parallax_middleground_repeat_x, parallax_middleground_repeat_y
);
parallax_draw(
    parallax_foreground_sprite, parallax_foreground_speed,
    parallax_foreground_offset_x, parallax_foreground_offset_y,
    parallax_foreground_repeat_x, parallax_foreground_repeat_y
);
