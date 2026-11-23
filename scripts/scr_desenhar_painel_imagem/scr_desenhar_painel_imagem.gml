function scr_desenhar_painel_imagem(_painel, _imagem, _texto,
    _escala_base, _multiplicador_hover, _multiplicador_selecao, _velocidade_lerp,
    _moldura, _fonte_texto, _escala_texto, _cor_texto, _distancia_texto)
{
    if (!_painel.painel_imagem_ativo || _painel.sprite_index != _imagem)
    {
        _painel.sprite_index = _imagem;
        _painel.image_xscale = _escala_base;
        _painel.image_yscale = _escala_base;
        _painel.painel_imagem_ativo = true;
    }

    if (painel_atualizar && !painel_clique_processado)
    {
        painel_clique_processado = true;
        scr_processar_clique_painel_imagem();
    }

    var _selecionado = global.selected.is_selected && global.selected.index == _painel.index;
    if (painel_atualizar)
    {
        var _escala = _escala_base;
        var _na_origem = point_distance(_painel.x, _painel.y, _painel.xstart, _painel.ystart) < 1;
        if (_selecionado) _escala *= _multiplicador_selecao;
        else if (_na_origem && scr_mouse_sobre_painel_imagem(_painel)) _escala *= _multiplicador_hover;

        _painel.x = lerp(_painel.x, _selecionado ? room_width * 0.5 : _painel.xstart, _velocidade_lerp);
        _painel.y = lerp(_painel.y, _selecionado ? room_height * 0.5 : _painel.ystart, _velocidade_lerp);
        _painel.image_xscale = lerp(_painel.image_xscale, _escala, _velocidade_lerp);
        _painel.image_yscale = lerp(_painel.image_yscale, _escala, _velocidade_lerp);
    }

    if (!_painel.visible || _painel.sprite_index == -1) return;

    draw_sprite_ext(_imagem, _painel.image_index, _painel.x, _painel.y,
        _painel.image_xscale, _painel.image_yscale, _painel.image_angle,
        _painel.image_blend, _painel.image_alpha);
    scr_desenhar_moldura_painel(_painel, _moldura);

    if (_texto == "" || !_selecionado) return;

    var _fonte_anterior = draw_get_font();
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();

    draw_set_font(_fonte_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _texto_x = (_painel.bbox_left + _painel.bbox_right) * 0.5;
    var _texto_y = _painel.bbox_bottom + _distancia_texto;
    draw_text_transformed_color(_texto_x, _texto_y, _texto, _escala_texto, _escala_texto,
        0, _cor_texto, _cor_texto, _cor_texto, _cor_texto, _painel.image_alpha);

    draw_set_font(_fonte_anterior);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
}

function scr_processar_clique_painel_imagem()
{
    if (!mouse_check_button_pressed(mb_left)) return;

    var _painel_clicado = noone;
    with (obj_panel)
    {
        if (!painel_imagem_ativo || !scr_mouse_sobre_painel_imagem(id)) continue;

        // O painel selecionado tem prioridade quando dois painéis se sobrepõem.
        if (global.selected.is_selected && global.selected.index == index)
        {
            _painel_clicado = id;
            break;
        }
        if (_painel_clicado == noone) _painel_clicado = id;
    }

    if (_painel_clicado == noone) return;

    var _index_clicado = _painel_clicado.index;
    var _ja_selecionado = global.selected.is_selected && global.selected.index == _index_clicado;
    global.selected.is_selected = !_ja_selecionado;
    global.selected.index = _ja_selecionado ? -1 : _index_clicado;
}

function scr_mouse_sobre_painel_imagem(_painel)
{
    return _painel.visible && _painel.image_alpha > 0 && _painel.sprite_index != -1
        && point_in_rectangle(mouse_x, mouse_y, _painel.bbox_left, _painel.bbox_top,
            _painel.bbox_right, _painel.bbox_bottom);
}

function scr_desenhar_moldura_painel(_painel, _moldura)
{
    if (!sprite_exists(_moldura)) return;

    var _sprite = _painel.sprite_index;
    var _left = _painel.x - sprite_get_xoffset(_sprite) * _painel.image_xscale;
    var _top = _painel.y - sprite_get_yoffset(_sprite) * _painel.image_yscale;
    var _width = sprite_get_width(_sprite) * _painel.image_xscale;
    var _height = sprite_get_height(_sprite) * _painel.image_yscale;

    // Desativa o tamanho mínimo do nine-slice apenas durante este desenho.
    var _nine_slice = sprite_get_nineslice(_moldura);
    var _nine_slice_enabled = _nine_slice.enabled;
    _nine_slice.enabled = false;
    draw_sprite_stretched_ext(_moldura, 0, _left, _top, _width, _height, c_white, _painel.image_alpha);
    _nine_slice.enabled = _nine_slice_enabled;
}
