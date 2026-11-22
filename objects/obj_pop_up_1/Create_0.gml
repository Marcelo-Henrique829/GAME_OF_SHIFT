// Herda vida, interação, reposicionamento e funções do popup base.
event_inherited();

// Cada filho pode escolher suas animações e ajustar as configurações herdadas.
popup_sprite_aparecer = spr_popup_maps_apear;
popup_sprite_parado = spr_pop_up_maps;
popup_sprite_hit = spr_popup_maps_hit;
popup_sprite_morrer = spr_popup_maps_destroy;
popup_set_state("apear");
