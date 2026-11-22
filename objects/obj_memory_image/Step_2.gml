menu_hovered = false;

// End Step espera o controller atualizar o fade-out neste mesmo frame.
if (!memoria_revelando)
{
    var _controller = instance_find(obj_control, 0);
    if (instance_exists(_controller))
    {
        // Evita ler o estado antigo do controller persistente ao chegar à sala.
        if (_controller.fade_current_room != room
            || _controller.fade_out_active || _controller.fade_in_active) exit;
    }
    // Sem controller, não há transição de chegada para aguardar.
    memoria_revelando = true;
}

// Mantém a suavização equivalente a 60 FPS, mesmo em outra taxa de quadros.
var _resposta = 1 - power(1 - clamp(memoria_lerp, 0, 1),
    60 / max(1, game_get_speed(gamespeed_fps)));
memoria_alpha = clamp(lerp(memoria_alpha, 1, _resposta), 0, 1);
var _escala_final = max(0, memoria_escala_final);
memoria_escala = lerp(memoria_escala, _escala_final, _resposta);
if (1 - memoria_alpha < 0.001) memoria_alpha = 1;
if (abs(_escala_final - memoria_escala) < 0.001) memoria_escala = _escala_final;

// Anima a cor uma vez por frame, com a mesma velocidade em qualquer FPS.
memoria_titulo_hue = (memoria_titulo_hue + max(0, memoria_titulo_cor_velocidade)
    / max(1, game_get_speed(gamespeed_fps))) mod 256;
memoria_titulo_cor = make_colour_hsv(memoria_titulo_hue, 200, 255);

// Botão fixo na parte inferior da GUI, independente do zoom da imagem.
if (!visible || image_alpha <= 0 || global.fade_active) exit;
var _fonte_anterior = draw_get_font();
draw_set_font(menu_font);
var _meia_largura = string_width("menu") * menu_text_scale * menu_hover_scale * 0.5 + menu_padding;
var _meia_altura = string_height("Mg") * menu_text_scale * menu_hover_scale * 0.5 + menu_padding;
draw_set_font(_fonte_anterior);
menu_gui_x = display_get_gui_width() * 0.5;
menu_gui_y = display_get_gui_height() - menu_margin - _meia_altura;
menu_hovered = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
    menu_gui_x - _meia_largura, menu_gui_y - _meia_altura,
    menu_gui_x + _meia_largura, menu_gui_y + _meia_altura);
// A área clicável usa o tamanho máximo para não oscilar durante a animação.
var _resposta_menu = 1 - exp(-14 / max(1, game_get_speed(gamespeed_fps)));
menu_scale = lerp(menu_scale, menu_hovered ? menu_hover_scale : 1, _resposta_menu);

if (menu_hovered && mouse_check_button_pressed(mb_left))
{
    var _controle_menu = instance_find(obj_control, 0);
    if (!instance_exists(_controle_menu))
    {
        room_goto(rm_main_menu);
        exit;
    }
    if (_controle_menu.fade_in_active || _controle_menu.fade_out_active
        || _controle_menu.player_dead_active) exit;
    _controle_menu.fade_target_room = rm_main_menu;
    _controle_menu.fade_restart_room = false;
    _controle_menu.fade_in_progress = 0;
    _controle_menu.fade_in_active = true;
    _controle_menu.fade_out_active = false;
    global.fade_active = true;
    menu_hovered = false;
}
