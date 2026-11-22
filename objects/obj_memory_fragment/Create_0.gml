// Tremida por proximidade, consumida pela câmera com scr_screen_shake().
tremida_ativa = true;
tremida_raio = 400; // Distância em pixels do mundo; fora dela não gera tremida.
tremida_forca_max = 12; // Intensidade máxima em pixels de tela (limite: 60).

// Zoom gradual por proximidade; 1 é o enquadramento normal.
zoom_proximidade_ativo = true;
zoom_proximidade_raio = 300;
zoom_proximidade_max = 4;

// O clique direito abre este destino quando o jogador está sobre o fragmento.
target_room = rm_memory_room;
is_hovered = false;
