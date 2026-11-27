#region Imagens e moldura
// Adicione uma entrada por imagem. Os offsets são relativos à posição do objeto.
memoria_imagens = [
    {
        sprite: spr_memory_ph_2,
        subimagem: 0,
        offset_x: 0,
        offset_y: 30
    }
];

// A moldura acompanha o tamanho de cada imagem. Use -1 para ocultá-la.
memoria_moldura_sprite = spr_window_template_ph;
#endregion

#region Animação de revelação
// Escala 1 corresponde ao tamanho original. Valores menores no lerp suavizam a entrada.
memoria_escala_inicial = 0.5;
memoria_escala_final = 0.7;
memoria_lerp = 0.08;
#endregion

#region Título
// A escala é o tamanho máximo. O título encolhe se ultrapassar a margem da GUI.
memoria_titulo = "Memory fragment unlocked";
memoria_titulo_escala = 2;
memoria_titulo_margem = 24;

// As cores usam HSV de 0 a 255. Velocidade 0 mantém a cor inicial.
memoria_titulo_hue_inicial = 0;
memoria_titulo_saturacao = 200;
memoria_titulo_brilho = 255;
memoria_titulo_cor_velocidade = 60;
#endregion

#region Estilo dos textos
// O título e o botão compartilham a fonte e a sombra.
menu_font = fn_UI;
memoria_sombra_cor = c_black;
memoria_sombra_offset_x = 2;
memoria_sombra_offset_y = 2;
#endregion

#region Botão de navegação
menu_texto = "Next";
menu_destino = rm_memory_palace;
menu_text_scale = 2;
menu_hover_scale = 1.2;
menu_animacao_velocidade = 14;
menu_cor = c_white;
menu_cor_hover = c_yellow;
menu_padding = 12; // Espaço extra ao redor do texto, em pixels da GUI, para o clique.
menu_margin = 16; // Distância entre o botão e a borda inferior da GUI.
#endregion

#region Estado em execução
// O End Step atualiza estes valores conforme a memória aparece e o mouse se move.
memoria_alpha = 0;
memoria_escala = max(0, memoria_escala_inicial);
memoria_revelando = false;

memoria_titulo_hue = memoria_titulo_hue_inicial;
memoria_titulo_cor = make_colour_hsv(memoria_titulo_hue, memoria_titulo_saturacao, memoria_titulo_brilho);

menu_hovered = false;
menu_scale = 1;
menu_gui_x = 0;
menu_gui_y = 0;
#endregion
