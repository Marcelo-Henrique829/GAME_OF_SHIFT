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
function scr_desenhar_painel_texto(_painel, _texto, _fonte, _destino, _atualizar,
    _cor = c_black, _escala_base = 1, _multiplicador_hover = 1.08, _velocidade_lerp = 0.15,
    _frames_boing = 24, _intensidade_boing = 0.22, _oscilacoes_boing = 2.5, _margem_clique = 0)
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

        // O seno alterna a deformação e o lerp reduz sua amplitude até zero.
        _painel.boing_frames = min(_painel.boing_frames, _duracao);
        var _progresso = 1 - _painel.boing_frames / max(1, _duracao);
        var _amplitude = lerp(clamp(_intensidade_boing, 0, 0.99), 0, _progresso);
        _painel.boing_escala = sin(_progresso * 2 * pi * _oscilacoes_boing) * _amplitude;
        _painel.boing_frames = max(0, _painel.boing_frames - 1);
    }

    // Comprime um eixo enquanto estica o outro. A posição do centro fica fixa.
    draw_text_transformed_color(_painel.x, _painel.y, _texto,
        _painel.image_xscale * (1 - _painel.boing_escala),
        _painel.image_yscale * (1 + _painel.boing_escala), _painel.image_angle,
        _cor, _cor, _cor, _cor, _painel.image_alpha);

    draw_set_font(_fonte_anterior);
    draw_set_halign(_halign_anterior);
    draw_set_valign(_valign_anterior);
}
