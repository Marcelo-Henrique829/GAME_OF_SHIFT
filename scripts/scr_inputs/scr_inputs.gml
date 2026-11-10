// MAPA CENTRAL DE INPUTS
// Os objetos consultam ações (global.inputs.dash, por exemplo), e este script
// concentra quais teclas/botões ativam cada ação. Para trocar uma tecla,
// altere a leitura aqui sem precisar mudar os objetos que usam a ação.
//
// COMO ADICIONAR UM INPUT — exemplo: interagir com a tecla E
// 1. Declare um campo dentro de global.inputs, junto aos demais:
//        interact: false,
//    Use vírgula entre os campos; o último campo pode ficar sem vírgula.
// 2. Dentro de scr_inputs, junto às leituras de ações, adicione:
//        _i.interact = keyboard_check_pressed(ord("E"));
// 3. No Step do objeto que usa a ação, depois da atualização dos inputs:
//        if (global.inputs.interact) { /* executar a interação */ }
//    scr_inputs(true) deve ser executado antes de consultar o mapa no frame.
//    Se outro evento já o atualizou, basta consultar global.inputs.
//
// ESCOLHA O TIPO DE LEITURA
// keyboard_check(tecla)          : true enquanto a tecla estiver segurada.
// keyboard_check_pressed(tecla)  : true apenas no frame em que foi pressionada.
// keyboard_check_released(tecla) : true apenas no frame em que foi solta.
// Para mouse, use mouse_check_button / mouse_check_button_pressed /
// mouse_check_button_released com mb_left, mb_right ou mb_middle.
// Letras usam ord("E"); teclas especiais usam vk_space, vk_enter etc.
// Combine alternativas com ||: teclado OU mouse podem ativar a mesma ação.
// Uma tecla pode ativar várias ações: E também ativa tec_e no mapa atual.
// Prefira nomes de ação (interact) a nomes da tecla para facilitar remapeamentos.

// Constantes compartilhadas pelos sistemas que usam os inputs.
#macro FLASH_MAX 0.15
#macro AXIS_DEAD_ZONE 0.25

// Compartilhado pela UI, pelo player e pela câmera.
global.player_in_menu = false;

// Estado inicial do mapa: todas as ações começam desativadas.
// Esta inicialização fica fora da função; não a repita a cada atualização.
// Ao adicionar um campo aqui, adicione também sua leitura dentro de scr_inputs.
global.inputs = {
    left: false,
    right: false,
    up: false,
    down: false,
    attack: false,
    attack_2: false,
    dash: false,
    run: false,
    aim: false,
    enter: false,
    esc: false,
    tec_e: false,
    fast_dialog: false,
    invent: false,
    tec_p: false,
    use_item: false,
    esc_hold: false,
    enter_key_p: false,
    tab_released: false,
    fade_test: false,
    qte_action: false,
    mouse_left_p: false,
    texture_filter_reset: false,
    shoulder_right: false,
    shoulder_left: false,
    left_p: false,
    right_p: false,
    up_p: false,
    down_p: false
};

/// @function scr_inputs(_enabled)
/// @description Atualiza o mapa global de inputs do jogador.
/// @param {bool} _enabled Se false, mantém o último mapa, sem ler nem zerar inputs.
function scr_inputs(_enabled = true)
{
    if (!_enabled) return;

    // Structs são referências: escrever em _i também atualiza global.inputs.
    // Cada ação deve receber um valor a cada chamada para não ficar presa em true.
    var _i = global.inputs;

    // Direcionais seguradas.
    _i.left =   keyboard_check(ord("A")) || keyboard_check(vk_left);
    _i.right =  keyboard_check(ord("D")) || keyboard_check(vk_right);
    _i.up =		keyboard_check(ord("W")) || keyboard_check(vk_up);
    _i.down =   keyboard_check(ord("S")) || keyboard_check(vk_down);

    // Ações. Adicione novas leituras aqui usando o campo declarado no mapa acima.
    // Sem sufixo, confira a função de leitura: há ações seguradas e pressionadas.
    _i.attack = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("J"));
    _i.attack_2 = mouse_check_button_pressed(mb_right) || keyboard_check_pressed(ord("K"));
    _i.dash = keyboard_check_pressed(vk_space);
    _i.run = keyboard_check(vk_shift);
    _i.aim = keyboard_check(vk_control) || mouse_check_button(mb_right);
    _i.enter = keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left);
    _i.esc = keyboard_check_pressed(vk_escape);
    _i.esc_hold = keyboard_check(vk_escape);
    _i.tec_e = keyboard_check_pressed(ord("E"));
    _i.fast_dialog = keyboard_check(ord("C"));
    _i.invent = keyboard_check(ord("I")) || keyboard_check(vk_escape);
    _i.tec_p = keyboard_check_pressed(ord("P"));
    _i.use_item = keyboard_check_pressed(ord("Q"));
    _i.enter_key_p = keyboard_check_pressed(vk_enter);
    _i.tab_released = keyboard_check_released(vk_tab);
    _i.fade_test = keyboard_check_pressed(ord("G"));
    _i.mouse_left_p = mouse_check_button_pressed(mb_left);
    _i.texture_filter_reset = keyboard_check_pressed(vk_backspace);

    // Reservados para sistemas de QTE e controle: ainda não possuem botão ligado.
    // Para habilitar um deles, substitua false pela leitura desejada nesta linha.
    _i.qte_action = false;
    _i.shoulder_right = false;
    _i.shoulder_left = false;

    // _p indica que a tecla direcional foi pressionada neste frame.
    _i.left_p = keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left);
    _i.right_p = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right);
    _i.up_p = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
    _i.down_p = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);
}
