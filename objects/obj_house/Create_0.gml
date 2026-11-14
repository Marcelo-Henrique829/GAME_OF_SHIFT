// Destino e distâncias da interação, em pixels da sala.
target_room = Rm_TopDownTest;
distancia_interacao = 80;
distancia_indicador = 80;

// Mesmo indicador animado usado pelo NPC.
indicador_sprite = spr_tec_e;
// Posições: top, top_right, right, bottom_right, bottom, bottom_left,
// left, top_left e center. Também aceita espaços: "top left".
indicador_posicao = "center";
indicador_escala_max = 0.15;
indicador_margem = 0; // Afastamento das bordas da casa, em pixels da sala.
indicador_lerp = 0.15;
indicador_escala = 0;
player_proximo = noone;

verifica_distancia_player = function(_distancia)
{
    player_proximo = instance_nearest(x, y, obj_player_platform);
    return instance_exists(player_proximo)
        && point_distance(x, y, player_proximo.x, player_proximo.y) <= max(0, _distancia);
};

entrar_na_casa = function()
{
    if (!verifica_distancia_player(distancia_interacao)) return;
    if (!global.inputs.tec_e || global.player_in_menu
        || instance_exists(Obj_dialogo) || global.fade_active) return;
    if (!room_exists(target_room)) return;

    var _controller = instance_find(obj_control, 0);
    if (!instance_exists(_controller)) return;
    // O controller cobre a tela antes de trocar de sala e a revela na chegada.
    if (_controller.fade_in_active || _controller.fade_out_active) return;
    _controller.fade_target_room = target_room;
    _controller.fade_in_progress = 0;
    _controller.fade_in_active = true;
    _controller.fade_out_active = false;
    global.fade_active = true;
};

// Executar no Draw: anima o indicador na posição configurada no Create.
desenhar_indicador = function()
{
    if (!sprite_exists(indicador_sprite)) return;
    var _mostrar = verifica_distancia_player(distancia_indicador)
        && !global.player_in_menu && !instance_exists(Obj_dialogo) && !global.fade_active;
    var _alvo = _mostrar ? max(0, indicador_escala_max) : 0;
    indicador_escala = lerp(indicador_escala, _alvo, clamp(indicador_lerp, 0, 1));
    if (abs(indicador_escala - _alvo) < 0.001) indicador_escala = _alvo;
    if (indicador_escala <= 0) return;

    // Compensa a origem e a escala definidas para a instância na sala.
    var _esquerda = x;
    var _direita = x;
    var _topo = y;
    var _base = y;
    if (sprite_index != -1)
    {
        var _origem_x = sprite_get_xoffset(sprite_index);
        var _origem_y = sprite_get_yoffset(sprite_index);
        var _largura = sprite_get_width(sprite_index);
        var _altura = sprite_get_height(sprite_index);
        _esquerda = x + min(-_origem_x * image_xscale,
            (_largura - _origem_x) * image_xscale);
        _direita = x + max(-_origem_x * image_xscale,
            (_largura - _origem_x) * image_xscale);
        _topo = y + min(-_origem_y * image_yscale,
            (_altura - _origem_y) * image_yscale);
        _base = y + max(-_origem_y * image_yscale,
            (_altura - _origem_y) * image_yscale);
    }

    var _lado_x = 0;
    var _lado_y = -1;
    var _posicao = string_replace_all(string_lower(indicador_posicao), " ", "_");
    switch (_posicao)
    {
        case "top_left":     _lado_x = -1; _lado_y = -1; break;
        case "top_right":    _lado_x =  1; _lado_y = -1; break;
        case "left":         _lado_x = -1; _lado_y =  0; break;
        case "rigth": // Aceita também esta grafia de right.
        case "right":        _lado_x =  1; _lado_y =  0; break;
        case "bottom_left":  _lado_x = -1; _lado_y =  1; break;
        case "bottom":       _lado_x =  0; _lado_y =  1; break;
        case "bottom_right": _lado_x =  1; _lado_y =  1; break;
        case "center":       _lado_x =  0; _lado_y =  0; break;
        // top e valores desconhecidos mantêm o indicador acima da casa.
    }

    var _indicador_largura = sprite_get_width(indicador_sprite);
    var _indicador_altura = sprite_get_height(indicador_sprite);
    var _margem = max(0, indicador_margem);
    var _centro_x = lerp(_esquerda, _direita, (_lado_x + 1) * 0.5)
        + _lado_x * (_margem + _indicador_largura * indicador_escala * 0.5);
    var _centro_y = lerp(_topo, _base, (_lado_y + 1) * 0.5)
        + _lado_y * (_margem + _indicador_altura * indicador_escala * 0.5);

    // Centraliza a arte mesmo se o sprite do indicador tiver outra origem.
    var _draw_x = _centro_x + (sprite_get_xoffset(indicador_sprite) - _indicador_largura * 0.5) * indicador_escala;
    var _draw_y = _centro_y + (sprite_get_yoffset(indicador_sprite) - _indicador_altura * 0.5) * indicador_escala;
    draw_sprite_ext(indicador_sprite, 0, _draw_x, _draw_y,
        indicador_escala, indicador_escala, 0, c_white, 1);
};
