// BEGIN STEP — executado a cada frame antes dos eventos Step normais.
// Assim, abrir o menu coloca o player em STOP antes de ele tentar se mover.
// Fechar por Esc também devolve seu estado antes de atualizar o movimento.

// Atualiza global.inputs; não lê o teclado diretamente para manter o mapa central.
scr_inputs(true);
// Recupera o player se esta UI ainda não tiver uma referência válida.
if (!instance_exists(player)) player = instance_find(obj_player_platform, 0);

if (!instance_exists(player))
{
    // Sem player, não há menu a exibir. Libera a flag global e encerra este evento.
    menu_set_open(false);
    exit;
}

// esc representa uma nova pressão; segurar a tecla não alterna a UI todo frame.
if (global.inputs.esc)
{
    // obj_control coordena o fade-in que cobre a tela antes da troca de sala.
    // Sem controller, considera que não há transição para bloquear a abertura.
    var _controller = instance_find(obj_control, 0);
    var _transitioning = false;
    if (_controller != noone) _transitioning = _controller.fade_in_active;

    // Um menu já aberto sempre pode fechar. Para abrir, exige ausência de fade-in.
    // A checagem de chão fica dentro de menu_set_open para valer para qualquer chamada.
    if (global.player_in_menu || !_transitioning)
    {
        // ! inverte o booleano: fechado vira aberto, aberto vira fechado.
        menu_set_open(!global.player_in_menu);
    }
}
