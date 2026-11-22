// Imagens desenhadas pelo objeto, sem depender do sprite_index da instância.
// Adicione entradas para exibir outras imagens; offsets são relativos a x/y.
memoria_imagens = [
    { sprite: spr_memory_ph_2, subimagem: 0, offset_x: 0, offset_y: 30 }
];

// Mesma moldura do obj_window; use -1 para desenhar as imagens sem moldura.
memoria_moldura_sprite = spr_window_template_ph;

// Revela a memória após a transição de chegada à sala.
memoria_escala_inicial = 0.5;
memoria_escala_final = 0.7; // 70% do tamanho original do sprite.
memoria_lerp = 0.08; // Valores menores deixam a aparição mais lenta.
memoria_alpha = 0;
memoria_escala = max(0, memoria_escala_inicial);
memoria_revelando = false;

// Título acima da imagem, com a mesma fonte e sombra do botão de menu.
memoria_titulo = "Memory fragment unlocked";
memoria_titulo_margem = 24;
// Percorre as cores suavemente; 60 completa o ciclo em cerca de 4 segundos.
memoria_titulo_cor_velocidade = 60; // 0 pausa a mudança de cor.
memoria_titulo_hue = 0;
memoria_titulo_cor = make_colour_hsv(memoria_titulo_hue, 200, 255);

// Botão de retorno com o mesmo estilo do menu de pausa, em coordenadas da GUI.
menu_font = fn_UI;
menu_text_scale = 2;
menu_hover_scale = 1.2;
menu_padding = 12;
menu_margin = 16;
menu_hovered = false;
menu_scale = 1;
menu_gui_x = 0;
menu_gui_y = 0;
