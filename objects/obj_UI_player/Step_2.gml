// END STEP — executado depois dos eventos Step do player e da câmera.
// Calcula as posições das opções, detecta o mouse, anima as escalas e executa cliques.
// O Draw GUI apenas apresenta estes resultados, sem alterar a lógica do menu.

// Não calcula a interface se o menu estiver fechado ou o player tiver desaparecido.
if (!global.player_in_menu || !instance_exists(player)) exit;
// Textos ocultos durante o fade também não recebem hover ou cliques.
if (global.fade_active)
{
    clicked_option = -1;
    menu_click_timer = 0;
    exit;
}
// Aguarda o feedback visual antes de fechar a UI ou iniciar a troca de sala.
if (clicked_option != -1)
{
    menu_click_timer = max(0, menu_click_timer - 1 / max(1, game_get_speed(gamespeed_fps)));
    if (menu_click_timer <= 0)
    {
        var _action = menu_options[clicked_option].action;
        clicked_option = -1;
        _action();
        exit;
    }
}
// Usa a câmera principal. -1 significa que não existe uma câmera atribuída à view.
var _camera = view_camera[0];
if (_camera == -1) exit;

// A quantidade é dinâmica, para suportar itens incluídos por menu_add_option.
var _count = array_length(menu_options);
if (_count == 0) exit;

// GUI é o espaço de desenho da interface; view é a área do mundo vista pela câmera.
// Durante o zoom, a view diminui, mas as medidas da GUI permanecem iguais.
var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();
var _view_width = camera_get_view_width(_camera);
var _view_height = camera_get_view_height(_camera);
// Converte mundo -> GUI: subtrai a posição da câmera, divide pela dimensão da view
// e multiplica pela dimensão da GUI. Isso mantém a UI presa ao player no zoom.
// O eixo X segue a origem do player; Y usa bbox_top, o topo da máscara de colisão.
var _anchor_x = (player.x - camera_get_view_x(_camera)) / _view_width * _gui_width;
var _anchor_y = (player.bbox_top - camera_get_view_y(_camera)) / _view_height * _gui_height;
// O mouse também precisa estar em coordenadas da GUI para acertar o texto desenhado.
// 0 identifica o dispositivo principal do mouse/toque.
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

// Usa a mesma fonte do desenho para medir corretamente e depois restaura a anterior.
var _old_font = draw_get_font();
draw_set_font(menu_font);
// "Mg" é uma amostra de altura da fonte. Reserva espaço para a maior escala do hover.
// O fator 0.5 transforma a altura total em meia altura; padding amplia a área do mouse.
var _half_height = string_height("Mg") * menu_text_scale * menu_hover_scale * 0.5 + menu_padding;
// Soma as larguras máximas e os espaços para centralizar a fileira inteira.
var _group_width = (_count - 1) * menu_option_gap;
for (var _i = 0; _i < _count; _i++)
{
    // Cada item é uma struct: alterar seus campos atualiza o item na lista.
    var _option = menu_options[_i];
    _option.half_width = string_width(_option.label) * menu_text_scale * menu_hover_scale * 0.5 + menu_padding;
    _option.half_height = _half_height;
    _group_width += _option.half_width * 2;
}
draw_set_font(_old_font);

// Todas as opções ficam na mesma altura, lado a lado.
var _group_height = _half_height * 2;
// Centraliza a fileira sobre o player e limita sua posição às bordas da GUI.
var _left = clamp(_anchor_x - _group_width * 0.5, menu_margin, max(menu_margin, _gui_width - menu_margin - _group_width));
// Posiciona todo o grupo acima do player, respeitando gap e margem das bordas.
// max evita um limite superior menor que o inferior se o grupo não couber na GUI.
var _top = clamp(_anchor_y - menu_player_gap - _group_height, menu_margin, max(menu_margin, _gui_height - menu_margin - _group_height));

// A área clicável é fixa no tamanho máximo, evitando oscilação durante o hover.
// Se o retângulo encolhesse junto do texto, o mouse poderia entrar e sair sem se mover.
// Reinicia a seleção para não manter um hover antigo quando o cursor sai do grupo.
hovered_option = -1;
var _next_x = _left;
for (var _i = 0; _i < _count; _i++)
{
    var _option = menu_options[_i];
    // Distribui em X usando a largura de cada texto e mantém o mesmo Y.
    _option.gui_x = _next_x + _option.half_width;
    _option.gui_y = _top + _half_height;
    _next_x += _option.half_width * 2 + menu_option_gap;
    // Constrói o retângulo a partir do centro e das meias dimensões.
    // A primeira opção atingida ganha prioridade caso as bordas se toquem.
    if (hovered_option == -1 && point_in_rectangle(_mouse_x, _mouse_y,
        _option.gui_x - _option.half_width, _option.gui_y - _option.half_height,
        _option.gui_x + _option.half_width, _option.gui_y + _option.half_height))
    {
        hovered_option = _i;
    }
}

// Coeficiente de suavização baseado no FPS configurado, para manter o ritmo da animação
// ao mudar a velocidade do jogo. max(1, ...) impede uma divisão por zero.
// exp produz um coeficiente gradual entre 0 e 1 para a interpolação.
var _blend = 1 - exp(-menu_scale_speed / max(1, game_get_speed(gamespeed_fps)));
for (var _i = 0; _i < _count; _i++)
{
    // Sem hover, todas voltam a 1. Com hover, a escolhida cresce e as demais diminuem.
    var _target_scale = 1;
    var _selected = (clicked_option != -1) ? clicked_option : hovered_option;
    if (_selected != -1) _target_scale = (_i == _selected) ? menu_hover_scale : menu_other_scale;
    // lerp aproxima a escala atual da desejada sem uma mudança instantânea.
    menu_options[_i].scale = lerp(menu_options[_i].scale, _target_scale, _blend);
}

// Um clique inicia o shake; cliques adicionais aguardam a ação terminar.
if (clicked_option == -1 && hovered_option != -1 && global.inputs.mouse_left_p)
{
    clicked_option = hovered_option;
    menu_click_timer = max(0.001, menu_click_duration);
}
