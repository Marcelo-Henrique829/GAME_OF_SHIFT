// Evita manter uma segunda instância quando a sala de destino também contém o controller.
// A instância original é persistente e continua responsável pela transição.
if (instance_number(obj_control) > 1)
{
	instance_destroy();
	exit;
}

// Sala atual e destino da próxima transição.
fade_current_room = room;
fade_target_room = noone;

// Estado e velocidade do fade-in: fecha a tela antes de trocar de sala.
fade_in_active = false;
fade_in_progress = 0;
fade_in_cover_progress = 1;
fade_in_speed = 1.5;
fade_in_triangle_max_scale = 3;

// Estado e velocidade do fade-out: abre a tela ao entrar em uma sala.
fade_out_active = true;
fade_out_progress = 1;
fade_out_speed = 1.5;
fade_out_triangle_max_scale = 3;
