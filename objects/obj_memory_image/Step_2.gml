#region Espera pela transição de chegada
menu_hovered = false;

// End Step espera o controller atualizar o fade-out neste mesmo frame.
if (!memoria_revelando)
{
    var _controller = instance_find(obj_control, 0);
    if (instance_exists(_controller))
    {
        // Evita ler o estado antigo do controller persistente ao chegar à sala.
        if (_controller.fade_current_room != room
            || _controller.fade_out_active || _controller.fade_in_active)
        {
            exit;
        }
    }
    // Sem controller, não há transição de chegada para aguardar.
    memoria_revelando = true;
}
#endregion

#region Animação da imagem e do título
// Mantém a suavização equivalente a 60 FPS, mesmo em outra taxa de quadros.
var _fps = max(1, game_get_speed(gamespeed_fps));
var _velocidade_memoria = clamp(memoria_lerp, 0, 1);
var _resposta = 1 - power(1 - _velocidade_memoria, 60 / _fps);
memoria_alpha = clamp(lerp(memoria_alpha, 1, _resposta), 0, 1);
var _escala_final = max(0, memoria_escala_final);
memoria_escala = lerp(memoria_escala, _escala_final, _resposta);
if (1 - memoria_alpha < 0.001)
{
    memoria_alpha = 1;
}
if (abs(_escala_final - memoria_escala) < 0.001)
{
    memoria_escala = _escala_final;
}

// Avança o tom em unidades por segundo e volta ao início ao completar o ciclo.
var _passo_cor = max(0, memoria_titulo_cor_velocidade) / _fps;
memoria_titulo_hue = (memoria_titulo_hue + _passo_cor) mod 256;
memoria_titulo_cor = make_colour_hsv(memoria_titulo_hue, memoria_titulo_saturacao, memoria_titulo_brilho);
#endregion

#region Área clicável e destaque do botão
// O botão fica no rodapé da GUI, independente do zoom da imagem.
if (!visible || image_alpha <= 0 || global.fade_active)
{
    exit;
}

// Mede o maior tamanho do texto para a área clicável ficar estável durante a animação.
var _escala_maxima = menu_text_scale * max(1, menu_hover_scale);
var _fonte_anterior = draw_get_font();
draw_set_font(menu_font);
var _meia_largura = string_width(menu_texto) * _escala_maxima * 0.5 + menu_padding;
var _meia_altura = string_height("Mg") * _escala_maxima * 0.5 + menu_padding;
draw_set_font(_fonte_anterior);

menu_gui_x = display_get_gui_width() * 0.5;
menu_gui_y = display_get_gui_height() - menu_margin - _meia_altura;
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
menu_hovered = point_in_rectangle(_mouse_gui_x, _mouse_gui_y,
    menu_gui_x - _meia_largura, menu_gui_y - _meia_altura,
    menu_gui_x + _meia_largura, menu_gui_y + _meia_altura);

var _escala_alvo = 1;
if (menu_hovered)
{
    _escala_alvo = menu_hover_scale;
}
var _velocidade_menu = max(0, menu_animacao_velocidade);
var _resposta_menu = 1 - exp(-_velocidade_menu / _fps);
menu_scale = lerp(menu_scale, _escala_alvo, _resposta_menu);
#endregion

#region Clique e troca de sala
if (!menu_hovered || !mouse_check_button_pressed(mb_left))
{
    exit;
}
if (!room_exists(menu_destino))
{
    exit;
}

var _controle_menu = instance_find(obj_control, 0);
if (!instance_exists(_controle_menu))
{
    room_goto(menu_destino);
    exit;
}

// O controlador cobre a tela antes de abrir a sala configurada no Create.
if (_controle_menu.fade_in_active || _controle_menu.fade_out_active || _controle_menu.player_dead_active)
{
    exit;
}
_controle_menu.fade_target_room = menu_destino;
_controle_menu.fade_restart_room = false;
_controle_menu.fade_in_progress = 0;
_controle_menu.fade_in_active = true;
_controle_menu.fade_out_active = false;
global.fade_active = true;
menu_hovered = false;
#endregion
