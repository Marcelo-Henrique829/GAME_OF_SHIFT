// O diálogo é fornecido por quem criar este objeto.
dialogo = noone;
indice = 0;
pag = 0;
player = noone;

libera_player = function()
{
	if (instance_exists(player))
	{
		with (player)
		{
			state = PlayerState.IDDLE;
		}
	}

	instance_destroy();
};

cria_dialogo = function(_dialogo)
{
	if (is_undefined(_dialogo) || _dialogo == noone) return;
	if (!variable_struct_exists(_dialogo, "texto")) return;
	if (array_length(_dialogo.texto) <= 0) return;

	var _pag_atual = clamp(pag, 0, array_length(_dialogo.texto) - 1);
	var _txt = _dialogo.texto[_pag_atual];
	var _txt_tam = string_length(_txt);
	var _txt_vel = variable_struct_exists(_dialogo, "txt_vel") ? _dialogo.txt_vel : 1;
	var _guiw = display_get_gui_width();
	var _guih = display_get_gui_height();
	var _spr_w = sprite_get_width(Spr_caixadialogo);
	var _spr_h = sprite_get_height(Spr_caixadialogo);
	var _escalax = (_guiw - 800) / _spr_w;
	var _escalay = (_guih * 0.3) / _spr_h;
	var _yy = _guih - _escalay * _spr_h;
	var _margem = string_height("I");
	var _qtp_pag = array_length(_dialogo.texto) - 1;
	var _name = "";

	if (variable_struct_exists(_dialogo, "names") && array_length(_dialogo.names) > 0)
	{
		_name = _dialogo.names[min(_pag_atual, array_length(_dialogo.names) - 1)];
	}

	var _retrato = noone;
	if (variable_struct_exists(_dialogo, "retrato") && array_length(_dialogo.retrato) > 0)
	{
		_retrato = _dialogo.retrato[min(_pag_atual, array_length(_dialogo.retrato) - 1)];
	}

	var _retrato_npc = noone;
	if (variable_struct_exists(_dialogo, "retrato_npc") && array_length(_dialogo.retrato_npc) > 0)
	{
		_retrato_npc = _dialogo.retrato_npc[min(_pag_atual, array_length(_dialogo.retrato_npc) - 1)];
	}

	var _dbox = Spr_caixadialogo;
	if (variable_struct_exists(_dialogo, "d_box") && array_length(_dialogo.d_box) > 0)
	{
		_dbox = _dialogo.d_box[min(_pag_atual, array_length(_dialogo.d_box) - 1)];
	}

	var _inputs = global.inputs;
	if (_inputs.enter)
	{
		if (indice < _txt_tam)
		{
			indice = _txt_tam;
		}
		else if (pag < _qtp_pag)
		{
			pag++;
			indice = 0;
		}
		else
		{
			libera_player();
			return;
		}
	}

	if (_inputs.attack || _inputs.fast_dialog) _txt_vel = 0.8;
	if (indice <= _txt_tam) indice = min(indice + _txt_vel, _txt_tam);

	var _yy_ret = _guih;
	var _ret_escala = 0;
	var _ret_margem = 0;
	if (_retrato != noone)
	{
		_ret_escala = (_guih * 0.5) / sprite_get_height(_retrato);
		_yy_ret = _guih - _ret_escala * sprite_get_height(_retrato) / 2;
		_ret_margem = sprite_get_width(_retrato);
		draw_sprite_ext(_retrato, 0, _ret_margem, _yy_ret, _ret_escala, _ret_escala, 0, c_white, 1);
	}

	if (_retrato_npc != noone)
	{
		var _ret_escala_npc = (_guih * 0.5) / sprite_get_height(_retrato_npc);
		var _yy_ret_npc = _guih - _ret_escala_npc * sprite_get_height(_retrato_npc) / 2;
		var _ret_margem_npc = _guiw - sprite_get_width(_retrato_npc);
		draw_sprite_ext(_retrato_npc, 0, _ret_margem_npc, _yy_ret_npc, _ret_escala_npc, _ret_escala_npc, 0, c_white, 1);
	}

	draw_sprite_ext(_dbox, 0, 500 + _margem - 180, _yy, _escalax, _escalay, 0, c_white, 1);
	draw_set_color(c_purple);
	draw_text_ext(350 + _margem * 2, _yy + _margem - 10,
		_name + ": " + string_copy(_txt, 1, floor(indice)), string_height("A"),
		(_spr_w * _escalax) - (_margem * 3));
	draw_set_color(c_white);
};
