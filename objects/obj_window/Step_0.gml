// Soltar o botão ou ocultar/desativar a janela encerra o arraste.
if (!mouse_check_button(mb_left) || !janela_ativa || !visible
    || image_alpha <= 0 || sprite_index == -1)
{
    janela_arrastando = false;
    exit;
}

if (mouse_check_button_pressed(mb_left))
{
    // Apenas uma janela recebe o clique: prioriza a que está mais à frente.
    var _selecionada = noone;
    var _profundidade = infinity;
    for (var _i = 0; _i < instance_number(obj_window); _i++)
    {
        var _janela = instance_find(obj_window, _i);
        if (!_janela.janela_ativa || !_janela.visible || _janela.image_alpha <= 0
            || _janela.sprite_index == -1) continue;
        if (_janela.depth <= _profundidade
            && collision_point(mouse_x, mouse_y, _janela, true, false) != noone)
        {
            _selecionada = _janela;
            _profundidade = _janela.depth;
        }
    }

    janela_arrastando = (_selecionada == id);
    if (janela_arrastando)
    {
        // Preserva o ponto clicado, sem saltar o centro da janela até o mouse.
        arraste_offset_x = mouse_x - x;
        arraste_offset_y = mouse_y - y;
    }
}

if (janela_arrastando)
{
    // Coordenadas do mundo acompanham a câmera e o zoom da sala.
    var _raio = max(0, arraste_raio);
    var _alvo_x = mouse_x - arraste_offset_x;
    var _alvo_y = mouse_y - arraste_offset_y;
    var _distancia = point_distance(arraste_origem_x, arraste_origem_y, _alvo_x, _alvo_y);
    if (_distancia > _raio)
    {
        var _fator = _raio / _distancia;
        _alvo_x = arraste_origem_x + (_alvo_x - arraste_origem_x) * _fator;
        _alvo_y = arraste_origem_y + (_alvo_y - arraste_origem_y) * _fator;
    }

    x = _alvo_x;
    y = _alvo_y;
}
