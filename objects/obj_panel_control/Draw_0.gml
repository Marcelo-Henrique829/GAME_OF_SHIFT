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
painel_clique_processado = false;

for (var _i = 0; _i < _total_paineis; ++_i)
{
    var _painel = instance_find(obj_panel, _i);
    switch (_painel.index)
    {
        case 0:
            scr_desenhar_painel_imagem(_painel, spr_memory_ph_2, "Memória");
            
        break;

        case 1:
            
            scr_desenhar_painel_texto(_painel, "Menu", fn_UI_1, rm_main_menu, painel_atualizar);
            
        break;

        default:
        with (_painel)
        {
            if (visible) draw_self();
        }
        break;
    }
}
