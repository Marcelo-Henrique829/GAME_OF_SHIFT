#region Colisão

/// @function scr_colision(_colliders, _impact_target)
/// @description Move o objeto atual em cada eixo e para ao encontrar colisores.
/// @param _impact_target Alvo opcional que interrompe o movimento e retorna a instância e a normal do contato.
function scr_colision(_colliders = all, _impact_target = noone)
{
    var _remaining_x = abs(hspd);
    var _direction_x = sign(hspd);

    while (_remaining_x > 0)
    {
        var _step_x = min(1, _remaining_x) * _direction_x;
        if (place_meeting(x + _step_x, y, _colliders))
        {
            hspd = 0;
            break;
        }
        if (_impact_target != noone)
        {
            var _hit_x = instance_place(x + _step_x, y, _impact_target);
            if (_hit_x != noone) return { target: _hit_x, normal_x: -_direction_x, normal_y: 0 };
        }

        x += _step_x;
        _remaining_x -= abs(_step_x);
    }

    var _remaining_y = abs(vspd);
    var _direction_y = sign(vspd);

    while (_remaining_y > 0)
    {
        var _step_y = min(1, _remaining_y) * _direction_y;
        if (place_meeting(x, y + _step_y, _colliders))
        {
            vspd = 0;
            break;
        }
        if (_impact_target != noone)
        {
            var _hit_y = instance_place(x, y + _step_y, _impact_target);
            if (_hit_y != noone) return { target: _hit_y, normal_x: 0, normal_y: -_direction_y };
        }

        y += _step_y;
        _remaining_y -= abs(_step_y);
    }

    return undefined;
}

/// Resolve o movimento do jogador de plataforma e aplica o impulso ao tocar a bolha de pulo.
/// @returns {Bool} Indica se a velocidade vertical apontava para baixo antes da colisão final.
function scr_colisao_jogador_plataforma()
{
    var _descending_before_collision = vspd > 0;
    var _bubble_overlap = noone;
    var _impact_target = noone;
    if (state != PlayerStatePlatformer.STOP && state != PlayerStatePlatformer.DEAD
        && !global.player_in_menu && instance_exists(obj_buble_jump))
    {
        _bubble_overlap = instance_place(x, y, obj_buble_jump);
        if (_bubble_overlap == noone) _impact_target = obj_buble_jump;
    }

    var _bubble_hit = noone;
    if (_bubble_overlap != noone && _bubble_overlap != buble_jump_contact)
    {
        _bubble_hit = _bubble_overlap;
    }
    else
    {
        var _impact = scr_colision(collision_targets, _impact_target);
        if (!is_undefined(_impact)) _bubble_hit = _impact.target;
    }

    // Guarda o contato mesmo quando o primeiro impacto veio de fora da máscara.
    buble_jump_contact = (_bubble_hit != noone) ? _bubble_hit : _bubble_overlap;

    if (_bubble_hit != noone)
    {
        _bubble_hit.boing_pendente = true;

        var _dx = ((bbox_left + bbox_right) - (_bubble_hit.bbox_left + _bubble_hit.bbox_right)) * 0.5;
        var _dy = ((bbox_top + bbox_bottom) - (_bubble_hit.bbox_top + _bubble_hit.bbox_bottom)) * 0.5;
        // Usa a distância vertical para inclinar o impulso, sempre apontando para cima.
        var _angulo = clamp(point_direction(0, 0, _dx, -max(1, abs(_dy))), 45, 135);
        var _inclinacao = abs(_angulo - 90) / 45;
        var _forca = max(0, lerp(buble_jump_forca_centro, buble_jump_forca_lateral, _inclinacao));

        hspd = lengthdir_x(_forca, _angulo);
        vspd = lengthdir_y(_forca, _angulo);
        coyote_timer = 0;
        state = PlayerStatePlatformer.JUMP;

        _descending_before_collision = vspd > 0;
        scr_colision(collision_targets);
    }

    return _descending_before_collision;
}

#endregion

#region Boing

/// Inicializa o boing no evento Create da instância.
function scr_boing_create()
{
    boing_frames = 0;
    boing_escala = 0;
}

/// Atualiza o boing e desenha o sprite atual no evento Draw.
/// @param _disparar Passe true no quadro em que o efeito deve começar.
/// @param _atualizar Passe false nas viewports seguintes do mesmo quadro.
/// @param _desenhar_sprite Passe false para aplicar a deformação retornada a outro desenho.
/// @param _alpha Opacidade do sprite. Por padrão, usa image_alpha.
/// @param _duracao Duração em quadros. Use 0 para desativar o efeito.
/// @param _intensidade Deformação máxima proporcional, entre 0 e 0.99.
/// @param _oscilacoes Número de ciclos de compressão e expansão.
/// @returns {Real} Deformação proporcional do quadro.
function scr_boing_draw(_disparar = false, _atualizar = true, _desenhar_sprite = true,
    _alpha = undefined, _duracao = 24, _intensidade = 0.22, _oscilacoes = 2.5)
{
    if (_atualizar)
    {
        _duracao = max(0, round(_duracao));
        if (_disparar) boing_frames = _duracao;
        boing_frames = min(boing_frames, _duracao);

        // O seno alterna os eixos enquanto o lerp reduz a amplitude até zero.
        var _progresso = 1 - boing_frames / max(1, _duracao);
        var _amplitude = lerp(clamp(_intensidade, 0, 0.99), 0, _progresso);
        boing_escala = sin(_progresso * 2 * pi * _oscilacoes) * _amplitude;
        boing_frames = max(0, boing_frames - 1);
    }

    if (_desenhar_sprite && visible && sprite_index != -1)
    {
        if (is_undefined(_alpha)) _alpha = image_alpha;
        draw_sprite_ext(sprite_index, image_index, x, y,
            image_xscale * (1 - boing_escala), image_yscale * (1 + boing_escala),
            image_angle, image_blend, _alpha);
    }

    return boing_escala;
}

#endregion

#region Configuração do gerador

/// @function scr_bolhas_iniciar_gerador()
/// @description Define os parâmetros de geração de bolhas no Create do controlador.
function scr_bolhas_iniciar_gerador()
{
    // Capacidade da sala e intervalo de reposição em Steps.
    bolhas_maximo = 60;
    bolhas_intervalo = 15;
    bolhas_tempo_ate_criar = 0; // A primeira bolha pode nascer no primeiro Step.

    // Escala relativa ao sprite, velocidade em pixels por Step e direção em graus.
    bolhas_escala_min = 0.05;
    bolhas_escala_max = 0.30;
    bolhas_velocidade_min = 0.10;
    bolhas_velocidade_max = 0.70;
    bolhas_direcao_min = 0;
    bolhas_direcao_max = 360;
}

#endregion

#region Geração das bolhas

/// @function scr_bolhas_atualizar_gerador()
/// @description Cria no máximo uma bolha por vez no Step do controlador.
function scr_bolhas_atualizar_gerador()
{
    // O limite inclui as bolhas colocadas no editor. Ao liberar uma vaga,
    // o contador zerado permite repô-la já no próximo Step do controlador.
    var _maximo = max(0, floor(bolhas_maximo));
    var _quantidade_atual = instance_number(obj_buble);
    if (_quantidade_atual >= _maximo)
    {
        bolhas_tempo_ate_criar = 0;
        return;
    }

    bolhas_tempo_ate_criar = max(0, bolhas_tempo_ate_criar - 1);
    if (bolhas_tempo_ate_criar > 0)
    {
        return;
    }
    bolhas_tempo_ate_criar = max(1, floor(bolhas_intervalo));

    // Ordena os limites configurados antes de sortear. Escala precisa ser positiva
    // e a menor velocidade permitida é zero.
    var _escala_min = min(bolhas_escala_min, bolhas_escala_max);
    var _escala_max = max(bolhas_escala_min, bolhas_escala_max);
    _escala_min = max(0.01, _escala_min);
    _escala_max = max(_escala_min, _escala_max);

    var _velocidade_min = min(bolhas_velocidade_min, bolhas_velocidade_max);
    var _velocidade_max = max(bolhas_velocidade_min, bolhas_velocidade_max);
    _velocidade_min = max(0, _velocidade_min);
    _velocidade_max = max(_velocidade_min, _velocidade_max);

    var _direcao_min = min(bolhas_direcao_min, bolhas_direcao_max);
    var _direcao_max = max(bolhas_direcao_min, bolhas_direcao_max);
    var _escala = random_range(_escala_min, _escala_max);

    // A bolha nasce em um ponto da sala. Seu Create já a move para a camada de bolhas.
    var _bolha = instance_create_layer(random(room_width), random(room_height), layer, obj_buble);
    _bolha.image_xscale = _escala;
    _bolha.image_yscale = _escala;
    _bolha.speed = random_range(_velocidade_min, _velocidade_max);
    _bolha.direction = random_range(_direcao_min, _direcao_max);
}

#endregion

#region Comportamento de cada bolha

/// @function scr_bolha_iniciar()
/// @description Configura a instância e a ondulação compartilhada pelas bolhas.
function scr_bolha_iniciar()
{
    // Valores das bolhas do editor. O gerador ajusta as propriedades que sorteou.
    speed = 0.3;
    direction = 90;
    image_alpha = 0.55;

    // A primeira bolha cria a camada e seu filtro. As demais reaproveitam os dois.
    var _camada = layer_get_id("layer_bolhas");
    if (_camada == -1)
    {
        _camada = layer_create(-1000, "layer_bolhas");

        var _ondulacao = fx_create("_filter_ripples");
        fx_set_single_layer(_ondulacao, true);
        fx_set_parameter(_ondulacao, "g_RipplesSpeed", 2);
        fx_set_parameter(_ondulacao, "g_RipplesWidth", 64);
        fx_set_parameter(_ondulacao, "g_RipplesAmplitude", 0.5);
        layer_set_fx(_camada, _ondulacao);
    }
    layer = _camada;
}

/// @function scr_bolha_remover_fora_da_sala()
/// @description Remove a bolha no End Step quando todo o sprite estiver fora da sala.
function scr_bolha_remover_fora_da_sala()
{
    // O End Step já recebe a posição atualizada pelo movimento automático.
    if (bbox_right < 0 || bbox_left > room_width
        || bbox_bottom < 0 || bbox_top > room_height)
    {
        instance_destroy();
    }
}

#endregion
