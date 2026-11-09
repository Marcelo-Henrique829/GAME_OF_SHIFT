// Detecta a chegada à sala de destino e prepara o fade-out para revelá-la.
if (room != fade_current_room)
{
	fade_current_room = room;
	fade_in_active = false;
	fade_in_progress = 0;
	fade_out_active = true;
	fade_out_progress = 1;
}

// Ao pressionar K, escolhe a outra sala de teste e começa a cobrir a tela.
if (keyboard_check_pressed(ord("K")) && !fade_in_active && !global.player_in_menu)
{
	fade_target_room = (room == Rm_TopDownTest) ? Rm_platform_test : Rm_TopDownTest;
	fade_in_active = true;
	fade_in_progress = 0;
	fade_out_active = false;
}

// Atualiza os dois efeitos; o script inativo retorna sem alterar seu estado.
scr_fade_in();
scr_fade_out();
