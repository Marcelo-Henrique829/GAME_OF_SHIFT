// Fala exibida ao interagir com este NPC.
dialogo = {
	texto: ["SEXTA FEIRA",
            "PLAYTV. NOIS TA COMO??? ",
            "NO RECOLHE. ",
            "AI CARALHO",
            "TA MÓ FRIO, NOSSA… TA GOSTOSO, NUM TA???",
            "AI VEM COM PIX CARALHO!!! ",
            "HOJE NOIS TA COMO?",
            "CHAMBÃO",
            "BOTANDO PRA POCAR",
            "AI CARALHO, PEGA."

            ],
	names: ["NPC"],
	// Troque noone pela sprite desejada; cada lado é opcional e independente.
	retrato: [spr_player_portrait_ph],     // Portrait do player (esquerda).
	retrato_npc: [spr_npc_portrait_test]  // Portrait do NPC (direita).
};

// Configuração da interação e do indicador (distâncias em pixels da sala).
distancia_interacao = 80;
distancia_indicador = 80;
indicador_escala_max = 0.15;
indicador_altura = 0;
indicador_lerp = 0.15; // Entre 0 e 1; valores maiores animam mais rápido.
indicador_escala = 0;
player_proximo = noone;

// Localiza o jogador mais próximo e mede a distância entre as origens.
verifica_distancia_player = function(_distancia)
{
    player_proximo = instance_nearest(x, y, obj_player_platform);
    return instance_exists(player_proximo)
        && point_distance(x, y, player_proximo.x, player_proximo.y) <= max(0, _distancia);
};

interagir_dialogo = function()
{
    if (!verifica_distancia_player(distancia_interacao)) return;
    if (!global.inputs.tec_e || global.player_in_menu || instance_exists(Obj_dialogo)) return;

    var _dialogo = instance_create_layer(x, y, "Instances", Obj_dialogo);
    _dialogo.dialogo = dialogo;
    _dialogo.player = player_proximo;
    player_proximo.dialogo_ativo = true;
};

// Executar no Draw: aproxima a escala do alvo e desenha acima da sprite visual.
desenhar_indicador = function()
{
    var _mostrar = verifica_distancia_player(distancia_indicador)
        && !global.player_in_menu && !instance_exists(Obj_dialogo);
    var _alvo = _mostrar ? max(0, indicador_escala_max) : 0;
    indicador_escala = lerp(indicador_escala, _alvo, clamp(indicador_lerp, 0, 1));
    if (abs(indicador_escala - _alvo) < 0.001) indicador_escala = _alvo;
    if (indicador_escala <= 0) return;

    // Usa a sprite visual, pois a máscara de colisão do NPC é diferente.
    var _topo = y;
    if (sprite_index != -1)
    {
        var _origem_y = sprite_get_yoffset(sprite_index);
        _topo = y + min(-_origem_y * image_yscale,
            (sprite_get_height(sprite_index) - _origem_y) * image_yscale);
    }
    var _centro_y = _topo - indicador_altura - sprite_get_height(spr_tec_e) * indicador_escala * 0.5;
    draw_sprite_ext(spr_tec_e, 0, x, _centro_y,
        indicador_escala, indicador_escala, 0, c_white, 1);
};
