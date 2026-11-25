// Dados preenchidos por quem inicia o diálogo.
dialogo = noone;
player = noone;
pag = 0;       // Página atual.
indice = 0;    // Quantidade de caracteres já exibidos.

// Fonte do texto: -1 usa a padrão do GameMaker; pode trocar por fn_UI, por exemplo.
fonte_dialogo = fnt_dialogue;

// Tamanho da caixa como porcentagem da resolução da GUI.
caixa_largura_percentual = 60;
caixa_altura_percentual = 30 ;

// Margens entre a caixa e as bordas da GUI, em porcentagem da tela.
margem_lateral_percentual = 3;
margem_superior_percentual = 3;
margem_inferior_percentual = 3;

// Cada retrato aceita uma sprite fixa ou um array de sprites por página.
// Campo ausente, noone, -1, undefined ou array vazio deixam o lado sem retrato.
obter_retrato = function(_dados, _campo)
{
	if (!variable_struct_exists(_dados, _campo)) return noone;
	var _retrato = variable_struct_get(_dados, _campo);
	if (is_array(_retrato))
	{
		if (array_length(_retrato) == 0) return noone;
		_retrato = _retrato[min(pag, array_length(_retrato) - 1)];
	}

	if (is_undefined(_retrato) || is_string(_retrato)) return noone;
	if (_retrato == noone || _retrato == -1) return noone;
	if (!sprite_exists(_retrato)) return noone;
	return _retrato;
};

// Encosta o retrato na borda horizontal da GUI, respeitando a origem da sprite.
desenhar_retrato = function(_retrato, _direita, _gui_largura, _gui_altura)
{
	if (_retrato == noone) return;
	var _largura = sprite_get_width(_retrato);
	var _altura = sprite_get_height(_retrato);
	var _escala = min((_gui_altura * 0.5) / max(1, _altura),
		max(1, _gui_largura * 0.5) / max(1, _largura));
	var _esquerda = _direita ? _gui_largura - _largura * _escala : 0;
	var _topo = _gui_altura - _altura * _escala;
	var _retrato_x = _esquerda + sprite_get_xoffset(_retrato) * _escala;
	var _retrato_y = _topo + sprite_get_yoffset(_retrato) * _escala;
	draw_sprite_ext(_retrato, 0, _retrato_x, _retrato_y, _escala, _escala, 0, c_white, 1);
};

// Fecha a conversa e libera o jogador para se mover novamente.
libera_player = function()
{
	if (instance_exists(player)) player.dialogo_ativo = false;
	instance_destroy();
};

// Desenha a página atual na interface.
desenhar_dialogo = function(_dados)
{
	if (!is_struct(_dados) || !variable_struct_exists(_dados, "texto")) return;
	if (array_length(_dados.texto) == 0) return;

	var _texto_pagina = _dados.texto[pag];
	var _nome = "";
	if (variable_struct_exists(_dados, "names") && array_length(_dados.names) > 0)
		_nome = _dados.names[min(pag, array_length(_dados.names) - 1)];

	var _retrato_jogador = obter_retrato(_dados, "retrato");
	var _retrato_npc = obter_retrato(_dados, "retrato_npc");

	var _caixa = Spr_caixadialogo;
	if (variable_struct_exists(_dados, "d_box") && array_length(_dados.d_box) > 0)
		_caixa = _dados.d_box[min(pag, array_length(_dados.d_box) - 1)];

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
	desenhar_retrato(_retrato_jogador, false, _gui_largura, _gui_altura);
	desenhar_retrato(_retrato_npc, true, _gui_largura, _gui_altura);

	// Desenha a caixa e calcula sua área interna para o texto.
	draw_sprite_ext(_caixa, 0, _caixa_x, _caixa_y, _escala_x, _escala_y, 0, c_white, 1);
	var _margem_x = max(12, _caixa_largura * _escala_x * 0.08);
	var _margem_y = max(8, _caixa_altura * _escala_y * 0.12);
	var _texto_x = _caixa_x + _margem_x;
	var _texto_y = _caixa_y + _margem_y;
	var _texto_largura = max(1, _caixa_largura * _escala_x - _margem_x * 2);
	var _texto_altura = max(1, _caixa_altura * _escala_y - _margem_y * 2);
	var _prefixo = _nome == "" ? "" : _nome + ": ";
	var _texto_visivel = _prefixo + string_copy(_texto_pagina, 1, floor(indice));
	var _fonte_anterior = draw_get_font();
	var _cor_anterior = draw_get_color();
	var _alpha_anterior = draw_get_alpha();
	var _halign_anterior = draw_get_halign();
	var _valign_anterior = draw_get_valign();
	draw_set_font(fonte_dialogo);
	var _espaco_linha = string_height("A");

	// Mede a página completa para manter a escala enquanto o texto aparece.
	var _texto_completo = _prefixo + _texto_pagina;
	var _altura_texto = string_height_ext(_texto_completo, _espaco_linha, _texto_largura);
	var _largura_texto = string_width_ext(_texto_completo, _espaco_linha, _texto_largura);
	var _escala_texto = min(1, _texto_altura / max(1, _altura_texto),
		_texto_largura / max(1, _largura_texto));
	draw_set_color(c_purple);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text_ext_transformed(_texto_x, _texto_y, _texto_visivel, _espaco_linha,
		_texto_largura, _escala_texto, _escala_texto, 0);
	draw_set_valign(_valign_anterior);
	draw_set_halign(_halign_anterior);
	draw_set_alpha(_alpha_anterior);
	draw_set_color(_cor_anterior);
	draw_set_font(_fonte_anterior);
};
