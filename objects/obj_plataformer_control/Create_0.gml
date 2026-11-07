// SPRITES DAS CAMADAS
// Use -1 para ocultar uma camada.
parallax_background_sprite = GrassLand_Background_1;
parallax_middleground_sprite = GrassLand_Background_3;
parallax_foreground_sprite = GrassLand_Background_4;

// VELOCIDADES DAS CAMADAS
// Fatores relativos ao movimento da câmera, aplicados nos eixos X e Y.
// 0 = fixa na tela, 1 = acompanha o mundo, acima de 1 = passa mais rápido.
parallax_background_speed = 0.20;
parallax_middleground_speed = 0.55;
parallax_foreground_speed = 1.25;

// POSIÇÃO DAS CAMADAS
// Deslocamento em pixels do mundo, somado ao movimento do parallax.
// X positivo move para a direita. Y positivo baixa o sprite na tela.
// Use valores negativos para mover para a esquerda ou para cima.
parallax_background_offset_x = 0;
parallax_background_offset_y = 0;
parallax_middleground_offset_x = 0;
parallax_middleground_offset_y = 40;
parallax_foreground_offset_x = 0;
parallax_foreground_offset_y = 150;

// REPETIÇÃO DAS CAMADAS
// true repete o sprite no eixo escolhido. false desenha uma única vez nesse eixo.
// X controla a repetição horizontal. Y controla a repetição vertical.
parallax_background_repeat_x = true;
parallax_background_repeat_y = true;
parallax_middleground_repeat_x = true;
parallax_middleground_repeat_y = false;
parallax_foreground_repeat_x = true;
parallax_foreground_repeat_y = false;

// DESENHO DO PARALLAX
// Desenha somente as cópias que podem aparecer na câmera atual.
// A posição representa o canto superior esquerdo da arte.
function parallax_draw(_sprite, _speed, _offset_x, _offset_y, _repeat_x, _repeat_y)
{
    if (!sprite_exists(_sprite)) return;

    var _view_x = 0;
    var _view_y = 0;
    var _view_width = room_width;
    var _view_height = room_height;
    if (view_enabled && view_current >= 0)
    {
        var _camera = view_camera[view_current];
        if (_camera != -1)
        {
            _view_x = camera_get_view_x(_camera);
            _view_y = camera_get_view_y(_camera);
            _view_width = camera_get_view_width(_camera);
            _view_height = camera_get_view_height(_camera);
        }
    }

    var _width = sprite_get_width(_sprite);
    var _height = sprite_get_height(_sprite);
    var _left = round(_view_x * (1 - _speed) + _offset_x);
    var _top = round(_view_y * (1 - _speed) + _offset_y);

    // Cada eixo se repete apenas quando sua variável está ativada.
    var _first_x = 0;
    var _last_x = 0;
    var _first_y = 0;
    var _last_y = 0;
    if (_repeat_x)
    {
        _first_x = floor((_view_x - _left) / _width);
        _last_x = ceil((_view_x + _view_width - _left) / _width) - 1;
    }
    if (_repeat_y)
    {
        _first_y = floor((_view_y - _top) / _height);
        _last_y = ceil((_view_y + _view_height - _top) / _height) - 1;
    }

    // Compensa a origem do sprite para os offsets posicionarem o canto da arte.
    var _origin_x = sprite_get_xoffset(_sprite);
    var _origin_y = sprite_get_yoffset(_sprite);
    for (var _tile_y = _first_y; _tile_y <= _last_y; _tile_y++)
    {
        for (var _tile_x = _first_x; _tile_x <= _last_x; _tile_x++)
        {
            draw_sprite_ext(
                _sprite, 0,
                _left + _tile_x * _width + _origin_x,
                _top + _tile_y * _height + _origin_y,
                1, 1, 0, c_white, 1
            );
        }
    }
}
