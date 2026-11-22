// Detecta a chegada à sala de destino e prepara o fade-out para revelá-la.
if (room != fade_current_room)
{
	fade_current_room = room;
	fade_restart_room = false;
	player_dead_active = false;
	player_dead_target = noone;
	fade_in_active = false;
	fade_in_progress = 0;
	fade_out_active = true;
	fade_out_progress = 1;
}

// Ao pressionar K, escolhe a outra sala de teste e começa a cobrir a tela.
if (keyboard_check_pressed(ord("K")) && !fade_in_active && !player_dead_active && !global.player_in_menu)
{
	fade_target_room = (room == Rm_TopDownTest) ? Rm_platform_test : Rm_TopDownTest;
	fade_in_active = true;
	fade_in_progress = 0;
	fade_out_active = false;
}

// A morte cobre a tela e reinicia antes de a animação de destruição terminar.
if (player_dead_active && fade_restart_room && instance_exists(player_dead_target))
{
    var _player = player_dead_target;
    if (_player.sprite_index == spr_player_plataformer_ph_destroy)
    {
        var _fim = clamp(_player.dead_restart_progress, 0.1, 0.9);
        var _inicio = clamp(_player.dead_fade_start_progress, 0, _fim - 0.01);
        var _animacao = _player.image_index / max(1, _player.image_number - 1);
        if (_animacao >= _inicio)
        {
            fade_in_active = true;
            fade_in_progress = max(fade_in_progress,
                clamp((_animacao - _inicio) / (_fim - _inicio), 0, 1) * fade_in_cover_progress);
        }
    }
}

// Atualiza os dois efeitos; o script inativo retorna sem alterar seu estado.
global.fade_active = player_dead_active || fade_in_active || fade_out_active;
scr_fade_in();
scr_fade_out();
