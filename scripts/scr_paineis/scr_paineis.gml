/// Desenha um painel de imagem que vai ao centro da sala ao ser selecionado.
/// Chame no Draw do obj_panel_control. O controlador fornece a seleção e o estado da passagem atual.
/// @param _painel Instância de obj_panel. Seu index identifica a seleção e xstart/ystart marcam a origem.
/// @param _imagem Sprite exibido no painel e usado para calcular sua área de hover e clique.
/// @param _texto Legenda exibida abaixo da imagem selecionada. Use "" para ocultar a legenda.
/// @param _escala_base Tamanho em repouso. Use 1 para o tamanho original do sprite.
/// @param _multiplicador_hover Fator aplicado à escala base ao passar o mouse. Use 1 para manter o tamanho.
/// @param _multiplicador_selecao Fator aplicado à escala base quando selecionado.
/// @param _velocidade_lerp Fração percorrida por quadro até a posição e escala alvo, entre 0 e 1.
/// @param _moldura Sprite ajustado às dimensões da imagem. Use -1 para exibir só a imagem.
/// @param _fonte_texto Fonte da legenda.
/// @param _escala_texto Tamanho da legenda. Use 1 para o tamanho original da fonte.
/// @param _cor_texto Cor da legenda.
/// @param _distancia_texto Espaço em pixels entre a borda inferior da imagem e a legenda.
function scr_desenhar_painel_imagem(_painel, _imagem, _texto = "",
    _escala_base = 0.1, _multiplicador_hover = 1.08, _multiplicador_selecao = 4.8, _velocidade_lerp = 0.15,
    _moldura = spr_window_template_ph, _fonte_texto = fn_UI_2, _escala_texto = 1,
    _cor_texto = c_black, _distancia_texto = 5)
{
    // Aplica a escala inicial na primeira chamada ou quando a imagem troca.
    if (!_painel.painel_imagem_ativo || _painel.sprite_index != _imagem)
    {
        _painel.sprite_index = _imagem;
        _painel.image_xscale = _escala_base;
        _painel.image_yscale = _escala_base;
        _painel.painel_imagem_ativo = true;
    }

    var _selecionado = global.selected.is_selected && global.selected.index == _painel.index;
    // Aplica o lerp só na primeira viewport. O hover volta a atuar ao chegar à origem.
    if (painel_atualizar)
    {
        _painel.painel_hover = scr_mouse_sobre_painel_imagem(_painel);
        var _escala = _escala_base;
        var _na_origem = point_distance(_painel.x, _painel.y, _painel.xstart, _painel.ystart) < 1;
        if (_selecionado) _escala *= _multiplicador_selecao;
        else if (_na_origem && _painel.painel_hover) _escala *= _multiplicador_hover;

        _painel.x = lerp(_painel.x, _selecionado ? room_width * 0.5 : _painel.xstart, _velocidade_lerp);
        _painel.y = lerp(_painel.y, _selecionado ? room_height * 0.5 : _painel.ystart, _velocidade_lerp);
        _painel.image_xscale = lerp(_painel.image_xscale, _escala, _velocidade_lerp);
        _painel.image_yscale = lerp(_painel.image_yscale, _escala, _velocidade_lerp);
    }

    if (!_painel.visible || _painel.sprite_index == -1) return;

    var _alpha = scr_opacidade_painel(_painel);

    // Desenha a imagem na escala atual e sobrepõe a moldura.
    draw_sprite_ext(_imagem, _painel.image_index, _painel.x, _painel.y,
        _painel.image_xscale, _painel.image_yscale, _painel.image_angle,
        _painel.image_blend, _alpha);
    scr_desenhar_moldura_painel(_painel, _moldura, _alpha);

    if (_texto == "" || !_selecionado) return;

    // Centraliza a legenda abaixo da imagem e restaura o estado de desenho ao terminar.
    var _fonte_anterior = draw_get_font();
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();

    draw_set_font(_fonte_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _texto_x = (_painel.bbox_left + _painel.bbox_right) * 0.5;
    var _texto_y = _painel.bbox_bottom + _distancia_texto;
    draw_text_transformed_color(_texto_x, _texto_y, _texto, _escala_texto, _escala_texto,
        0, _cor_texto, _cor_texto, _cor_texto, _cor_texto, _alpha);

    draw_set_font(_fonte_anterior);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
}

/// Desenha o fragmento bloqueado na origem do painel. O hover revela o aviso e o clique inicia o boing.
/// @param _painel Instância de obj_panel que representa a memória.
/// @param _imagem Sprite usado enquanto a memória está bloqueada.
/// @param _texto Aviso exibido acima do fragmento durante o hover.
function scr_desenhar_painel_bloqueado(_painel, _imagem, _texto)
{
    // Ao bloquear de novo, encerra a seleção e prepara a escala do fragmento.
    if (_painel.painel_imagem_ativo || _painel.sprite_index != _imagem)
    {
        _painel.painel_imagem_ativo = false;
        _painel.sprite_index = _imagem;
        _painel.image_xscale = 1;
        _painel.image_yscale = 1;
        _painel.boing_frames = 0;
        _painel.boing_escala = 0;
        _painel.escala_texto_bloqueio = 0;

        if (global.selected.index == _painel.index)
        {
            global.selected.is_selected = false;
            global.selected.index = -1;
        }
    }

    if (painel_atualizar)
    {
        var _hover = scr_mouse_sobre_painel_imagem(_painel);
        _painel.painel_hover = _hover;
        var _duracao_boing = 24;
        if (_hover && mouse_check_button_pressed(mb_left)) _painel.boing_frames = _duracao_boing;
        scr_atualizar_boing_painel(_painel, _duracao_boing, 0.22, 2.5);

        var _escala = _hover ? 1.5 : 1;
        _painel.x = lerp(_painel.x, _painel.xstart, 0.15);
        _painel.y = lerp(_painel.y, _painel.ystart, 0.15);
        _painel.image_xscale = lerp(_painel.image_xscale, _escala, 0.15);
        _painel.image_yscale = lerp(_painel.image_yscale, _escala, 0.15);
        _painel.escala_texto_bloqueio = lerp(_painel.escala_texto_bloqueio, _hover ? 0.4 : 0, 0.15);
    }

    if (!_painel.visible) return;

    var _alpha = scr_opacidade_painel(_painel);
    draw_sprite_ext(_imagem, _painel.image_index, _painel.x, _painel.y,
        _painel.image_xscale * (1 - _painel.boing_escala),
        _painel.image_yscale * (1 + _painel.boing_escala),
        _painel.image_angle, _painel.image_blend, _alpha);

    if (_painel.escala_texto_bloqueio <= 0.005) return;

    // A legenda acompanha a borda superior do fragmento enquanto sua escala muda.
    var _fonte_anterior = draw_get_font();
    var _halign_anterior = draw_get_halign();
    var _valign_anterior = draw_get_valign();
    draw_set_font(fn_UI_2);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text_transformed_color((_painel.bbox_left + _painel.bbox_right) * 0.5,
        _painel.bbox_top - 8, _texto,
        _painel.escala_texto_bloqueio, _painel.escala_texto_bloqueio, 0,
        c_black, c_black, c_black, c_black, _alpha);
    draw_set_font(_fonte_anterior);
    draw_set_halign(_halign_anterior);
    draw_set_valign(_valign_anterior);
}

/// Calcula a opacidade visual sem alterar image_alpha nem a área de clique.
function scr_opacidade_painel(_painel)
{
    var _ao_fundo = global.selected.is_selected && global.selected.index != _painel.index;
    return _painel.image_alpha * (_ao_fundo ? 0.4 : 1);
}

/// Seleciona o painel sob o mouse. Um segundo clique nele limpa global.selected.
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

/// Testa os limites da instância e ignora imagens invisíveis ou totalmente transparentes.
function scr_mouse_sobre_painel_imagem(_painel)
{
    return _painel.visible && _painel.image_alpha > 0 && _painel.sprite_index != -1
        && point_in_rectangle(mouse_x, mouse_y, _painel.bbox_left, _painel.bbox_top,
            _painel.bbox_right, _painel.bbox_bottom);
}

/// Alinha a moldura ao canto superior esquerdo do sprite, compensando sua origem e escala.
function scr_desenhar_moldura_painel(_painel, _moldura, _alpha)
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
    draw_sprite_stretched_ext(_moldura, 0, _left, _top, _width, _height, c_white, _alpha);
    _nine_slice.enabled = _nine_slice_enabled;
}

/// Desenha um botão de texto na posição do obj_panel e trata seu clique.
/// @param _painel Instância que fornece posição, rotação, opacidade e estado da animação.
/// @param _texto Rótulo exibido no centro do painel.
/// @param _fonte Fonte usada para desenhar e medir a área clicável do texto.
/// @param _destino Sala aberta após o fade. Use noone para manter somente o efeito do clique.
/// @param _atualizar Use painel_atualizar do controlador para animar apenas uma vez por quadro.
/// @param _cor Cor do texto.
/// @param _escala_base Tamanho em repouso. Use 1 para o tamanho original da fonte.
/// @param _multiplicador_hover Fator aplicado à escala base com o mouse sobre o texto.
/// @param _velocidade_lerp Fração percorrida por quadro até a escala alvo, entre 0 e 1.
/// @param _frames_boing Duração da oscilação em quadros. Use 0 para desativar o efeito.
/// @param _intensidade_boing Deformação máxima proporcional, entre 0 e 0.99.
/// @param _oscilacoes_boing Número de ciclos completos de esticar e comprimir.
/// @param _margem_clique Pixels extras em cada lado da área de hover e clique.
/// @param _contorno Pixels de espessura do contorno preto. Use 0 para desativá-lo.
function scr_desenhar_painel_texto(_painel, _texto, _fonte, _destino, _atualizar,
    _cor = c_black, _escala_base = 1, _multiplicador_hover = 1.08, _velocidade_lerp = 0.15,
    _frames_boing = 24, _intensidade_boing = 0.22, _oscilacoes_boing = 2.5, _margem_clique = 0,
    _contorno = 0)
{
    if (!_painel.visible || _painel.image_alpha <= 0) return;

    // Usa a mesma fonte para medir e desenhar. Restaura o estado ao terminar.
    var _fonte_anterior = draw_get_font();
    var _halign_anterior = draw_get_halign();
    var _valign_anterior = draw_get_valign();
    draw_set_font(_fonte);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (_atualizar)
    {
        // Mede o texto com a escala de hover. A oscilação visual não altera a área clicável.
        var _meia_largura = string_width(_texto) * _painel.image_xscale * 0.5 + _margem_clique;
        var _meia_altura = string_height(_texto) * _painel.image_yscale * 0.5 + _margem_clique;
        var _hover = point_in_rectangle(mouse_x, mouse_y,
            _painel.x - _meia_largura, _painel.y - _meia_altura,
            _painel.x + _meia_largura, _painel.y + _meia_altura);
        _painel.painel_hover = _hover;

        var _duracao = max(0, round(_frames_boing));
        if (_hover && mouse_check_button_pressed(mb_left))
        {
            _painel.boing_frames = _duracao;
            if (room_exists(_destino))
            {
                // O controlador geral desenha o fade e troca de sala quando a tela está coberta.
                var _controle = instance_find(obj_control, 0);
                if (_controle == noone || (!_controle.fade_in_active && !_controle.fade_out_active
                    && !_controle.player_dead_active))
                {
                    // A sala pode ter sido iniciada diretamente, sem seu controlador persistente.
                    if (_controle == noone) _controle = instance_create_depth(0, 0, -10000, obj_control);

                    _controle.fade_target_room = _destino;
                    _controle.fade_restart_room = false;
                    _controle.fade_in_progress = 0;
                    _controle.fade_out_active = false;
                    _controle.fade_in_active = true;
                    global.fade_active = true;
                }
            }
        }

        // Interpola a escala nos dois eixos, tanto na entrada quanto na saída do hover.
        var _escala = _escala_base * (_hover ? _multiplicador_hover : 1);
        var _resposta = clamp(_velocidade_lerp, 0, 1);
        _painel.image_xscale = lerp(_painel.image_xscale, _escala, _resposta);
        _painel.image_yscale = lerp(_painel.image_yscale, _escala, _resposta);

        scr_atualizar_boing_painel(_painel, _duracao, _intensidade_boing, _oscilacoes_boing);
    }

    // Comprime um eixo enquanto estica o outro. A posição do centro fica fixa.
    var _escala_x = _painel.image_xscale * (1 - _painel.boing_escala);
    var _escala_y = _painel.image_yscale * (1 + _painel.boing_escala);
    var _alpha = scr_opacidade_painel(_painel);

    if (_contorno > 0)
    {
        for (var _angulo = 0; _angulo < 360; _angulo += 45)
        {
            draw_text_transformed_color(_painel.x + lengthdir_x(_contorno, _angulo),
                _painel.y + lengthdir_y(_contorno, _angulo), _texto,
                _escala_x, _escala_y, _painel.image_angle, c_black, c_black, c_black, c_black, _alpha);
        }
    }
    draw_text_transformed_color(_painel.x, _painel.y, _texto,
        _escala_x, _escala_y, _painel.image_angle, _cor, _cor, _cor, _cor, _alpha);

    draw_set_font(_fonte_anterior);
    draw_set_halign(_halign_anterior);
    draw_set_valign(_valign_anterior);
}

/// Avança a deformação do painel em um quadro. Para iniciar, atribua a duração a boing_frames.
function scr_atualizar_boing_painel(_painel, _duracao, _intensidade, _oscilacoes)
{
    // O seno alterna a deformação e o lerp reduz sua amplitude até zero.
    _painel.boing_frames = min(_painel.boing_frames, _duracao);
    var _progresso = 1 - _painel.boing_frames / max(1, _duracao);
    var _amplitude = lerp(clamp(_intensidade, 0, 0.99), 0, _progresso);
    _painel.boing_escala = sin(_progresso * 2 * pi * _oscilacoes) * _amplitude;
    _painel.boing_frames = max(0, _painel.boing_frames - 1);
}
