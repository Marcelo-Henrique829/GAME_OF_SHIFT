// Desenha primeiro a revelação da sala e, por último, a cobertura da transição ativa.
// O argumento true seleciona o desenho; o progresso é atualizado no evento Step.
scr_fade_out(true);
if (!instance_exists(shortcut_zoom_target)) scr_fade_in(true);
