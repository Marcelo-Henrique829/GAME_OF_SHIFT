#region Sobreposição de transição
// true desenha o estado calculado no Step. A revelação vem primeiro para que
// a cobertura fique por cima caso as duas fases estejam ativas no mesmo frame.
scr_fade_out(true);

// O zoom do atalho precisa terminar antes de a cobertura aparecer na GUI.
if (!instance_exists(shortcut_zoom_target)) scr_fade_in(true);
#endregion
