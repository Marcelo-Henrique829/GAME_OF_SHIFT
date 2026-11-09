// DRAW GUI — desenha na resolução da interface, sem ser ampliado pelo zoom do mundo.
// As posições e escalas já foram preparadas pelo End Step.
// Nada é desenhado quando o menu está fechado ou o player não existe mais.
if (!global.player_in_menu || !instance_exists(player)) exit;

// Guarda o estado de desenho para não afetar outras interfaces desenhadas depois.
var _old_font = draw_get_font();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();
var _old_color = draw_get_color();
var _old_alpha = draw_get_alpha();
// O centro de cada texto coincide com gui_x/gui_y e com a área clicável calculada.
// Alpha 1 deixa o texto completamente visível, mesmo se outro desenho usou transparência.
draw_set_font(menu_font);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1);

// Percorre todas as opções; novos itens entram automaticamente neste desenho.
for (var _i = 0; _i < array_length(menu_options); _i++)
{
    var _option = menu_options[_i];
    // Escala final = tamanho base da fonte multiplicado pela animação do hover.
    var _scale = menu_text_scale * _option.scale;
    // Sombra preta deslocada 2 pixels ajuda na leitura sobre o cenário.
    draw_set_color(c_black);
    draw_text_transformed(_option.gui_x + 2, _option.gui_y + 2, _option.label, _scale, _scale, 0);
    // O item sob o mouse recebe amarelo; os demais usam branco.
    // draw_text_transformed aplica a mesma escala nos dois eixos e rotação zero.
    draw_set_color((_i == hovered_option) ? c_yellow : c_white);
    draw_text_transformed(_option.gui_x, _option.gui_y, _option.label, _scale, _scale, 0);
}

// Restaura fonte, alinhamentos, cor e transparência exatamente como estavam antes.
draw_set_font(_old_font);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
