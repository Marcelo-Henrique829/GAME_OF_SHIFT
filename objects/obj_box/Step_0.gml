// Atualiza uma vez por Step, inclusive quando o arraste termina.
var _borda_no_limite = abs(point_distance(arraste_origem_x, arraste_origem_y, x, y)
    - max(0, arraste_raio)) <= 0.5;
var _borda_alvo = (caixa_arrastando && mouse_check_button(mb_left)
    && caixa_ativa && visible && image_alpha > 0
    && sprite_index != -1 && arraste_borda_espessura > 0 && _borda_no_limite) ? 0.7 : 0;
arraste_borda_alpha = clamp(lerp(arraste_borda_alpha, _borda_alvo,
    clamp(arraste_borda_lerp, 0, 1)), 0, 0.7);
if (_borda_alvo == 0 && arraste_borda_alpha < 0.001) arraste_borda_alpha = 0;

// Soltar o botão ou ocultar/desativar a caixa encerra o arraste.
if (!mouse_check_button(mb_left) || !caixa_ativa || !visible
    || image_alpha <= 0 || sprite_index == -1)
{
    // Ao soltar, começa a cair sem transformar o deslocamento do mouse em impulso.
    if (caixa_arrastando)
    {
        hspd = 0;
        vspd = 0;
    }
    caixa_arrastando = false;
}
else if (mouse_check_button_pressed(mb_left))
{
    // Apenas uma caixa recebe o clique: prioriza a que está mais à frente.
    var _selecionada = noone;
    var _profundidade = infinity;
    for (var _i = 0; _i < instance_number(obj_box); _i++)
    {
        var _caixa = instance_find(obj_box, _i);
        if (!_caixa.caixa_ativa || !_caixa.visible || _caixa.image_alpha <= 0
            || _caixa.sprite_index == -1) continue;
        if (_caixa.depth <= _profundidade
            && collision_point(mouse_x, mouse_y, _caixa, true, false) != noone)
        {
            _selecionada = _caixa;
            _profundidade = _caixa.depth;
        }
    }

    caixa_arrastando = (_selecionada == id);
    if (caixa_arrastando)
    {
        // Preserva o ponto clicado, sem saltar o centro da caixa até o mouse.
        arraste_offset_x = mouse_x - x;
        arraste_offset_y = mouse_y - y;
    }
}

if (caixa_arrastando)
{
    // Coordenadas do mundo acompanham a câmera e o zoom da sala.
    // Move com colisão também durante o arraste, sem atravessar chão ou jogador.
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

    // Limita também o movimento por eixo para respeitar o raio nas colisões.
    var _dy = y - arraste_origem_y;
    var _alcance_x = sqrt(max(0, _raio * _raio - _dy * _dy));
    hspd = clamp(_alvo_x, arraste_origem_x - _alcance_x, arraste_origem_x + _alcance_x) - x;
    vspd = _alvo_y - y;
}
else
{
    hspd = 0;
    vspd += grv;
}

// A máscara permanece dentro dos limites externos da sala, como a do jogador.
var _min_x = x - bbox_left;
var _max_x = x + room_width - 1 - bbox_right;
var _min_y = y - bbox_top;
var _max_y = y + room_height - 1 - bbox_bottom;
x = clamp(x, _min_x, _max_x);
y = clamp(y, _min_y, _max_y);
var _requested_hspd = hspd;
var _requested_vspd = vspd;
hspd = clamp(hspd, _min_x - x, _max_x - x);
vspd = clamp(vspd, _min_y - y, _max_y - y);
if (caixa_arrastando)
{
    // Resolve X primeiro e calcula o limite vertical a partir do X alcançado.
    // Assim uma colisão horizontal não permite ultrapassar o círculo em Y.
    var _movimento_y = vspd;
    vspd = 0;
    scr_colision(collision_targets);
    var _dx = x - arraste_origem_x;
    var _alcance_y = sqrt(max(0, _raio * _raio - _dx * _dx));
    vspd = clamp(y + _movimento_y, arraste_origem_y - _alcance_y,
        arraste_origem_y + _alcance_y) - y;
    vspd = clamp(vspd, _min_y - y, _max_y - y);
    var _movimento_x = hspd;
    hspd = 0;
    scr_colision(collision_targets);
    hspd = _movimento_x;
}
else
{
    scr_colision(collision_targets);
}
if (hspd != _requested_hspd) hspd = 0;
if (vspd != _requested_vspd) vspd = 0;

