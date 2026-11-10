/// @function scr_fade_in(_draw_overlay)
/// @description Executa e desenha a transição de entrada, cobrindo a tela com triângulos.
/// @param {bool} _draw_overlay false atualiza o progresso e troca de sala ao cobrir a tela;
///                            true desenha a camada visual no evento Draw GUI.
/// @returns {void}
function scr_fade_in(_draw_overlay = false)
{
	// Altere apenas esta variável para trocar o sprite do fade-in.
	var _sprite = spr_triangle;

	if (!_draw_overlay)
	{
		// Sem transição ativa, não há progresso para atualizar.
		if (!fade_in_active) return;

		// Avança a cobertura em uma velocidade independente da taxa de quadros.
		var _fps = max(1, game_get_speed(gamespeed_fps));
		if (fade_in_progress < fade_in_cover_progress)
		{
			fade_in_progress = min(fade_in_cover_progress, fade_in_progress + max(0, fade_in_speed) / _fps);
		}
		else
		{
			// A tela está coberta: troca para a sala escolhida pelo controller.
			room_goto(fade_target_room);
			fade_in_active = false;
			exit;
		}
		return;
	}

	if (!fade_in_active) return;

	// Calcula a grade no espaço da interface para cobrir toda a tela.
	var _gui_width = display_get_gui_width();
	var _gui_height = display_get_gui_height();
	var _triangle_size = max(1, min(sprite_get_width(_sprite), sprite_get_height(_sprite)));
	var _progress = clamp(fade_in_progress / max(0.001, fade_in_cover_progress), 0, 1);
	var _max_scale = max(0.1, fade_in_triangle_max_scale);
	var _scale = _max_scale * _progress;
	var _max_triangle_size = _triangle_size * _max_scale;
	var _spacing = max(1, _max_triangle_size * 0.3);
	var _start_x = -_max_triangle_size;
	var _start_y = -_max_triangle_size;
	var _end_x = _gui_width + _max_triangle_size;
	var _end_y = _gui_height + _max_triangle_size;

	// Desenha cada triângulo na escala correspondente ao progresso atual.
	for (var _draw_y = _start_y; _draw_y <= _end_y; _draw_y += _spacing)
	{
		for (var _draw_x = _start_x; _draw_x <= _end_x; _draw_x += _spacing)
		{
			draw_sprite_ext(_sprite, 0, _draw_x, _draw_y, _scale, _scale, 0, c_white, 1);
		}
	}
}
/// @function scr_fade_out(_draw_overlay)
/// @description Executa e desenha a transição de saída, revelando a sala por redução dos triângulos.
/// @param {bool} _draw_overlay false atualiza o progresso até a tela ficar visível;
///                            true desenha a camada visual no evento Draw GUI.
/// @returns {void}
function scr_fade_out(_draw_overlay = false)
{
	// Altere apenas esta variável para trocar o sprite do fade-out.
	var _sprite = spr_triangle;

	if (!_draw_overlay)
	{
		// Se o efeito já terminou, não é necessário atualizar seu estado.
		if (!fade_out_active) return;

		// Reduz a cobertura por segundo, sem depender da taxa de quadros.
		var _fps = max(1, game_get_speed(gamespeed_fps));
		fade_out_progress = max(0, fade_out_progress - max(0, fade_out_speed) / _fps);
		// Encerra o efeito quando os triângulos desaparecem.
		if (fade_out_progress <= 0)
		{
			fade_out_active = false;
			global.fade_active = fade_in_active;
		}
		return;
	}

	if (!fade_out_active) return;

	// Calcula a grade no espaço da interface para cobrir toda a tela.
	var _gui_width = display_get_gui_width();
	var _gui_height = display_get_gui_height();
	var _triangle_size = max(1, min(sprite_get_width(_sprite), sprite_get_height(_sprite)));
	var _max_scale = max(0.1, fade_out_triangle_max_scale);
	var _scale = _max_scale * clamp(fade_out_progress, 0, 1);
	var _max_triangle_size = _triangle_size * _max_scale;
	var _spacing = max(1, _max_triangle_size * 0.3);
	var _start_x = -_max_triangle_size;
	var _start_y = -_max_triangle_size;
	var _end_x = _gui_width + _max_triangle_size;
	var _end_y = _gui_height + _max_triangle_size;

	// Desenha os triângulos encolhendo conforme o progresso diminui.
	for (var _draw_y = _start_y; _draw_y <= _end_y; _draw_y += _spacing)
	{
		for (var _draw_x = _start_x; _draw_x <= _end_x; _draw_x += _spacing)
		{
			draw_sprite_ext(_sprite, 0, _draw_x, _draw_y, _scale, _scale, 0, c_white, 1);
		}
	}
}

