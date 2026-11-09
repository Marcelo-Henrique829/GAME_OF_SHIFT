// CREATE — executado uma vez, quando esta instância da UI é criada.
// O obj_player_platform cria esta UI automaticamente caso ela ainda não exista.
// Fluxo: Begin Step lê Esc -> menu_set_open abre/fecha -> End Step calcula a UI
// e o mouse -> Draw GUI desenha as opções -> Clean Up libera o estado ao sair.
// global.player_in_menu é inicializada em scr_inputs e consultada pela câmera
// para solicitar menu_zoom_scale (3x, configurado no Create de obj_camera).

// Evita duas interfaces processando o mesmo Esc e alternando o menu duas vezes.
// Destrói somente a instância excedente e interrompe seu Create.
if (instance_number(obj_UI_player) > 1)
{
    instance_destroy();
    exit;
}

// Referência à instância do player; noone indica que ainda será procurada.
player = noone;
// Cópia do estado, velocidades e animação anteriores à abertura do menu.
saved_player = undefined;
// Lista de opções. Cada item guarda texto, ação, escala e área de interação.
menu_options = [];
// Índice da opção sob o mouse (a lista começa em 0); -1 significa nenhuma.
hovered_option = -1;

// Medidas em pixels da GUI, independentes do zoom da câmera.
// -1 usa a fonte padrão do GameMaker. Pode ser trocado por um recurso de fonte.
menu_font = fn_UI;
// Multiplicador do tamanho original da fonte: 2 = dobro do tamanho.
menu_text_scale = 2;
// Escalas relativas ao tamanho base: opção sob o mouse fica 20% maior;
// as demais ficam 15% menores enquanto alguma opção estiver selecionada.
menu_hover_scale = 1.2;
menu_other_scale = 0.85;
// Velocidade da interpolação do hover: maior = mudança de tamanho mais rápida.
menu_scale_speed = 14;
// Distância mínima entre os centros das linhas. O layout aumenta se necessário.
menu_row_height = 42;
// Espaço entre o topo da máscara do player e a parte inferior do grupo de opções.
menu_player_gap = 32;
// Folga acrescentada em cada lado da área clicável, além do tamanho do texto.
menu_padding = 12;
// Distância mínima entre o grupo de opções e as bordas da GUI.
menu_margin = 16;

// Abre (_open = true) ou fecha (_open = false) o menu.
// Centraliza a mudança de estado para Esc, resume e futuras ações usarem a mesma regra.
menu_set_open = function(_open)
{
    // Evita salvar novamente o player já parado ou restaurar um menu já fechado.
    if (_open == global.player_in_menu) return;

    if (_open)
    {
        // Procura novamente caso a referência anterior tenha sido destruída.
        // instance_find(..., 0) retorna a primeira instância do objeto.
        if (!instance_exists(player)) player = instance_find(obj_player_platform, 0);
        if (!instance_exists(player)) return;

        // with executa a verificação no contexto do player: x, y, vspd e máscara
        // passam a ser os dele. A variável local _on_ground recebe o resultado.
        // y + 1 verifica se há obj_ground um pixel abaixo. vspd >= 0 impede
        // abrir durante a subida do pulo, mesmo se ainda estiver perto do chão.
        var _on_ground = false;
        with (player)
        {
            _on_ground = (vspd >= 0 && place_meeting(x, y + 1, obj_ground));
        }
        // Recusa a abertura sem mudar a flag global nem o estado do personagem.
        if (!_on_ground) return;

        // Guarda o estado e o movimento para continuar de onde parou.
        // state: estado da máquina; spd: velocidade desejada;
        // hspd/vspd: velocidades horizontal/vertical;
        // sprite/frame: animação que estava sendo exibida.
        saved_player = {
            state: player.state,
            spd: player.spd,
            hspd: player.hspd,
            vspd: player.vspd,
            sprite: player.sprite_index,
            frame: player.image_index
        };
        // STOP mantém o player em idle e suspende movimento, pulo e gravidade.
        // As velocidades são zeradas já aqui, antes do Step do personagem.
        player.state = PlayerStatePlatformer.STOP;
        player.spd = 0;
        player.hspd = 0;
        player.vspd = 0;
        player.sprite_index = spr_player_plataformer_ph_iddleRight;
        player.image_index = 0;
    }
    else if (instance_exists(player) && is_struct(saved_player))
    {
        // Ao fechar, restaura a situação anterior se o player ainda existir.
        // is_struct confirma que há um salvamento válido para consultar.
        player.state = saved_player.state;
        player.spd = saved_player.spd;
        player.hspd = saved_player.hspd;
        player.vspd = saved_player.vspd;
        player.sprite_index = saved_player.sprite;
        player.image_index = saved_player.frame;
        // Descarta a cópia depois de restaurar, para não reaproveitar dados antigos.
        saved_player = undefined;
    }

    // Publica o estado para os demais objetos e limpa a seleção visual.
    // Ao fechar, esta flag também permite à câmera voltar ao zoom padrão.
    global.player_in_menu = _open;
    hovered_option = -1;
    for (var _i = 0; _i < array_length(menu_options); _i++)
    {
        // Toda abertura/fechamento começa com as opções no tamanho base.
        menu_options[_i].scale = 1;
    }
};

// Acrescenta uma opção no fim da lista; a ordem de inclusão é a ordem na tela.
// _label é o texto exibido; _action é a função executada ao clicar.
// Não é necessário alterar os eventos de layout, hover ou desenho para adicionar itens.
// Exemplo de expansão (descomente e implemente a ação desejada):
// menu_add_option("opções", method(id, function()
// {
//     // Coloque aqui o código que abre as configurações.
// }));
// method(id, ...) vincula a ação a esta instância da UI, permitindo acessar
// seus métodos e variáveis dentro do callback, como menu_set_open(false).
menu_add_option = function(_label, _action)
{
    array_push(menu_options, {
        // Texto e comportamento da opção.
        label: _label,
        action: _action,
        // Multiplicador animado pelo hover; 1 significa tamanho base.
        scale: 1,
        // Centro do texto na GUI, recalculado no End Step para acompanhar o player.
        gui_x: 0,
        gui_y: 0,
        // Metades da largura/altura do retângulo clicável, calculadas no End Step.
        half_width: 0,
        half_height: 0
    });
};

// Opções iniciais. "menu" ainda é apenas um ponto de expansão sem ação.
menu_add_option("menu", method(id, function()
{
    // Reservado para implementar o menu principal posteriormente.
}));
// "resume" usa a mesma função de fechamento chamada pelo Esc.
menu_add_option("resume", method(id, function()
{
    menu_set_open(false);
}));
