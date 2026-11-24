// Este controlador desenha os painéis do Palácio da Memória.
if (room == rm_memory_palace)
{
    var _total_paineis = instance_number(obj_panel);
    if (_total_paineis == 0) exit;

    // O Draw roda por viewport. Só a primeira passagem atualiza os painéis.
    painel_atualizar = true;
    for (var _vista = 0; view_enabled && _vista < view_current; ++_vista)
    {
        if (!view_visible[_vista]) continue;
        painel_atualizar = false;
        break;
    }
    if (painel_atualizar) scr_processar_clique_painel_imagem();

    // Resolve a seleção antes de montar a ordem. O painel selecionado é desenhado por último.
    var _ordem = array_create(_total_paineis);
    var _fundo = 0;
    var _frente = _total_paineis - 1;
    for (var _i = 0; _i < _total_paineis; ++_i)
    {
        var _painel = instance_find(obj_panel, _i);
        if (global.selected.is_selected && global.selected.index == _painel.index)
        {
            _ordem[_frente] = _painel;
            --_frente;
        }
        else
        {
            _ordem[_fundo] = _painel;
            ++_fundo;
        }
    }

    for (var _i = 0; _i < _total_paineis; ++_i)
    {
        var _painel = _ordem[_i];
        // O cursor usa o hover calculado pelos scripts neste quadro.
        if (painel_atualizar) _painel.painel_hover = false;
        switch (_painel.index)
        {
            case 0:
                // A primeira memória abre após a coleta de um fragmento.
                if (global.memory_fragment.total > 0)
                {
                    scr_desenhar_painel_imagem(_painel, spr_memory_ph_2, "Memória");
                }
                else
                {
                    scr_desenhar_painel_bloqueado(_painel, spr_memory_fragment, "memory blocked");
                }
                break;

            case 1:
                scr_desenhar_painel_texto(_painel, "Menu", fn_UI_1, rm_main_menu, painel_atualizar,
                    c_white, 1, 1.08, 0.15, 24, 0.22, 2.5, 0, 2);
                break;

            case 2:
                // O segundo painel exige dois fragmentos.
                if (global.memory_fragment.total > 1)
                {
                    scr_desenhar_painel_imagem(_painel, spr_memory_ph_2, "Memória");
                }
                else
                {
                    scr_desenhar_painel_bloqueado(_painel, spr_memory_fragment, "memory blocked");
                }
                break;

            case 3:
                scr_desenhar_painel_texto(_painel, "palace of memories", fn_UI_1, noone, painel_atualizar,
                    c_white, 1, 1, 0.15, 24, 0.22, 2.5, 0, 2);
                break;

            default:
                if (_painel.visible && _painel.sprite_index != -1)
                {
                    draw_sprite_ext(_painel.sprite_index, _painel.image_index, _painel.x, _painel.y,
                        _painel.image_xscale, _painel.image_yscale, _painel.image_angle,
                        _painel.image_blend, scr_opacidade_painel(_painel));
                }
                break;
        }
    }
}
