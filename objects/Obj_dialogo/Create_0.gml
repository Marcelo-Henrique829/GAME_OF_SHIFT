// Dados preenchidos por quem inicia o diálogo.
dialogo = noone;
player = noone;
pag = 0;       // Página atual.
indice = 0;    // Quantidade de caracteres já exibidos.

// Tamanho da caixa como porcentagem da resolução da GUI.
caixa_largura_percentual = 80;
caixa_altura_percentual = 20 ;

// Margens entre a caixa e as bordas da GUI, em porcentagem da tela.
margem_lateral_percentual = 3;
margem_superior_percentual = 3;
margem_inferior_percentual = 3;

// Fecha a conversa e libera o jogador para se mover novamente.
libera_player = function()
{
	if (instance_exists(player)) player.dialogo_ativo = false;
	instance_destroy();
};

// Atualiza a página, recebe a entrada do jogador e desenha a interface.
cria_dialogo = function(_dados)
{
	// Verifica se existe pelo menos uma página de texto.
	if (is_undefined(_dados) || _dados == noone) return;
	if (!variable_struct_exists(_dados, "texto")) return;
	if (array_length(_dados.texto) <= 0) return;

	// Lê o texto e os dados opcionais da página atual.
	var _ultima_pagina = array_length(_dados.texto) - 1;
	pag = clamp(pag, 0, _ultima_pagina);
	var _texto_pagina = _dados.texto[pag];
	var _tamanho_texto = string_length(_texto_pagina);
	var _velocidade = variable_struct_exists(_dados, "txt_vel") ? _dados.txt_vel : 1;

	var _nome = "";
	if (variable_struct_exists(_dados, "names") && array_length(_dados.names) > 0)
		_nome = _dados.names[min(pag, array_length(_dados.names) - 1)];

	var _retrato_jogador = noone;
	if (variable_struct_exists(_dados, "retrato") && array_length(_dados.retrato) > 0)
		_retrato_jogador = _dados.retrato[min(pag, array_length(_dados.retrato) - 1)];

	var _retrato_npc = noone;
	if (variable_struct_exists(_dados, "retrato_npc") && array_length(_dados.retrato_npc) > 0)
		_retrato_npc = _dados.retrato_npc[min(pag, array_length(_dados.retrato_npc) - 1)];

	var _caixa = Spr_caixadialogo;
	if (variable_struct_exists(_dados, "d_box") && array_length(_dados.d_box) > 0)
		_caixa = _dados.d_box[min(pag, array_length(_dados.d_box) - 1)];

	// Enter revela o restante do texto, avança de página ou fecha a conversa.
	if (global.inputs.enter)
	{
		if (indice < _tamanho_texto)
		{
			indice = _tamanho_texto;
		}
		else if (pag < _ultima_pagina)
		{
			pag++;
			indice = 0;
			return; // A próxima página começa a ser desenhada no próximo frame.
		}
		else
		{
			libera_player();
			return;
		}
	}

	// C ou ataque acelera a exibição dos caracteres.
	if (global.inputs.attack || global.inputs.fast_dialog) _velocidade = 0.8;
	indice = min(indice + _velocidade, _tamanho_texto);

	// Usa as porcentagens definidas no começo deste Create.
	var _gui_largura = display_get_gui_width();
	var _gui_altura = display_get_gui_height();
	var _caixa_largura = sprite_get_width(Spr_caixadialogo);
	var _caixa_altura = sprite_get_height(Spr_caixadialogo);
	var _largura_percentual = clamp(caixa_largura_percentual, 1, 100);
	var _altura_percentual = clamp(caixa_altura_percentual, 1, 100);

	// Converte as margens em pixels da GUI.
	var _margem_lateral = _gui_largura * clamp(margem_lateral_percentual, 0, 49) / 100;
	var _margem_superior = _gui_altura * clamp(margem_superior_percentual, 0, 49) / 100;
	var _margem_inferior = _gui_altura * clamp(margem_inferior_percentual, 0, 49) / 100;

	// Calcula o espaço disponível entre as margens e limita a caixa a essa área.
	var _largura_disponivel = max(1, _gui_largura - _margem_lateral * 2);
	var _altura_disponivel = max(1, _gui_altura - _margem_superior - _margem_inferior);
	var _largura_caixa_px = min(_gui_largura * _largura_percentual / 100, _largura_disponivel);
	var _altura_caixa_px = min(_gui_altura * _altura_percentual / 100, _altura_disponivel);
	var _escala_x = _largura_caixa_px / _caixa_largura;
	var _escala_y = _altura_caixa_px / _caixa_altura;
	var _caixa_x = (_gui_largura - _caixa_largura * _escala_x) / 2;
	var _caixa_y = _gui_altura - _margem_inferior - _caixa_altura * _escala_y;

	// Desenha retratos opcionais alinhados à parte inferior da tela.
	if (_retrato_jogador != noone)
	{
		var _escala_retrato = (_gui_altura * 0.5) / sprite_get_height(_retrato_jogador);
		var _retrato_y = _gui_altura - sprite_get_height(_retrato_jogador) * _escala_retrato / 2;
		draw_sprite_ext(_retrato_jogador, 0, sprite_get_width(_retrato_jogador), _retrato_y,
			_escala_retrato, _escala_retrato, 0, c_white, 1);
	}

	if (_retrato_npc != noone)
	{
		var _escala_retrato_npc = (_gui_altura * 0.5) / sprite_get_height(_retrato_npc);
		var _retrato_npc_y = _gui_altura - sprite_get_height(_retrato_npc) * _escala_retrato_npc / 2;
		var _retrato_npc_x = _gui_largura - sprite_get_width(_retrato_npc);
		draw_sprite_ext(_retrato_npc, 0, _retrato_npc_x, _retrato_npc_y,
			_escala_retrato_npc, _escala_retrato_npc, 0, c_white, 1);
	}

	// Desenha a caixa e calcula sua área interna para o texto.
	draw_sprite_ext(_caixa, 0, _caixa_x, _caixa_y, _escala_x, _escala_y, 0, c_white, 1);
	var _margem_x = max(12, _caixa_largura * _escala_x * 0.08);
	var _margem_y = max(8, _caixa_altura * _escala_y * 0.12);
	var _texto_x = _caixa_x + _margem_x;
	var _texto_y = _caixa_y + _margem_y;
	var _texto_largura = max(1, _caixa_largura * _escala_x - _margem_x * 2);
	var _texto_altura = max(1, _caixa_altura * _escala_y - _margem_y * 2);
	var _texto_visivel = _nome + ": " + string_copy(_texto_pagina, 1, floor(indice));
	var _espaco_linha = string_height("A");

	// Se houver muitas linhas, reduz o texto para caber na altura disponível.
	var _altura_texto = string_height_ext(_texto_visivel, _espaco_linha, _texto_largura);
	var _escala_texto = min(1, _texto_altura / max(1, _altura_texto));
	draw_set_color(c_purple);
	draw_text_ext_transformed(_texto_x, _texto_y, _texto_visivel, _espaco_linha,
		_texto_largura, _escala_texto, _escala_texto, 0);
	draw_set_color(c_white);
};
