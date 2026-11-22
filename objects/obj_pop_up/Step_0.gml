// A mesma lógica atende ao pai e a todos os seus filhos.
if (life <= 0 && state != "die") popup_set_state("die");
if (state == "die")
{
    if (image_index >= image_number - 1) instance_destroy();
    exit;
}
if (state == "apear" || state == "hit")
{
    if (image_index >= image_number - 1) popup_set_state("iddle");
}

// Um clique atinge somente o popup mais à frente, incluindo os filhos.
if (popup_ativo && visible && image_alpha > 0 && !global.player_in_menu
    && (state == "iddle" || state == "hit") && mouse_check_button_pressed(mb_left))
{
    var _selecionado = noone;
    var _profundidade = infinity;
    for (var _i = 0; _i < instance_number(obj_pop_up); _i++)
    {
        var _popup = instance_find(obj_pop_up, _i);
        // Aparição e morte também bloqueiam cliques nos popups atrás.
        if (!_popup.popup_ativo || !_popup.visible || _popup.image_alpha <= 0) continue;
        if (_popup.depth <= _profundidade
            && collision_point(mouse_x, mouse_y, _popup, true, false) != noone)
        {
            _selecionado = _popup;
            _profundidade = _popup.depth;
        }
    }
    if (_selecionado == id) popup_receive_hit();
}

if (!popup_ativo || state != "iddle") exit;
// Salas sem jogador de plataforma não precisam reposicionar o popup.
var _player = instance_nearest(x, y, obj_player_platform);
if (_player == noone) exit;
if (point_distance(x, y, _player.x, _player.y) > max(0, popup_distancia_reposicionar))
{
    var _minimo = max(0, min(popup_deslocamento_min, popup_deslocamento_max));
    var _maximo = max(_minimo, max(popup_deslocamento_min, popup_deslocamento_max));
    var _deslocamento = random_range(_minimo, _maximo);
    var _direcao = sign(_player.hspd);
    if (_direcao == 0) _direcao = sign(_player.image_xscale);
    if (_direcao == 0) _direcao = 1;
    x = _player.x - _direcao * _deslocamento;
    y = _player.y - sign(_player.vspd) * _deslocamento;
    popup_set_state("apear");

    // Mantém a arte da aparição dentro da sala, respeitando a origem do sprite.
    var _min_x = sprite_get_xoffset(sprite_index);
    var _min_y = sprite_get_yoffset(sprite_index);
    x = clamp(x, _min_x, max(_min_x, room_width - sprite_get_width(sprite_index) + _min_x));
    y = clamp(y, _min_y, max(_min_y, room_height - sprite_get_height(sprite_index) + _min_y));
}
