#region Efeito subaquático na metade direita
// Coordenada do mundo onde começa a água; acompanha a câmera e o zoom.
agua_inicio_x = room_width * 0.5;
agua_superficie_seca = -1;
agua_largura_seca = 0;

// Reaproveita o filtro configurado no editor da sala.
agua_camada_fx = layer_get_id("Effect_1");
agua_camada_fx_criada = (agua_camada_fx == -1);
agua_profundidade_original = 0;
if (agua_camada_fx_criada)
{
    agua_camada_fx = layer_create(0, "layer_underwater_right_fx");
    layer_set_fx(agua_camada_fx, fx_create("_filter_underwater"));
}
else
{
    agua_profundidade_original = layer_get_depth(agua_camada_fx);
}

// Inclui todas as camadas, inclusive a camada de bolhas criada em -1000.
var _frente = -1000;
var _camadas = layer_get_all();
for (var _i = 0; _i < array_length(_camadas); _i++)
{
    _frente = min(_frente, layer_get_depth(_camadas[_i]));
}
agua_camada_captura = layer_create(_frente - 1, "layer_underwater_capture");
layer_depth(agua_camada_fx, _frente - 2);
layer_enable_fx(agua_camada_fx, true);
fx_set_single_layer(layer_get_fx(agua_camada_fx), false);
agua_camada_restaura = layer_create(_frente - 3, "layer_underwater_restore");

// Captura a parte seca antes de o filtro nativo processar a cena completa.
layer_script_begin(agua_camada_captura, method(id, function()
{
    if (event_type != ev_draw || event_number != ev_draw_normal) return;
    agua_largura_seca = 0;
    var _alvo = surface_get_target();
    if (!surface_exists(_alvo)) return;

    var _largura = surface_get_width(_alvo);
    var _altura = surface_get_height(_alvo);
    var _view_x = 0;
    var _view_largura = room_width;
    if (view_enabled && view_current >= 0)
    {
        var _camera = view_camera[view_current];
        if (_camera != -1)
        {
            _view_x = camera_get_view_x(_camera);
            _view_largura = camera_get_view_width(_camera);
        }
    }
    // Converte o limite no mundo em pixels da superfície, sem fixá-lo na tela.
    var _seca = clamp(ceil((agua_inicio_x - _view_x) / _view_largura * _largura), 0, _largura);
    if (_seca <= 0) return;

    if (surface_exists(agua_superficie_seca))
    {
        if (surface_get_width(agua_superficie_seca) != _largura
            || surface_get_height(agua_superficie_seca) != _altura)
        {
            surface_free(agua_superficie_seca);
            agua_superficie_seca = -1;
        }
    }
    if (!surface_exists(agua_superficie_seca))
    {
        agua_superficie_seca = surface_create(_largura, _altura);
    }
    if (!surface_exists(agua_superficie_seca)) return;

    surface_copy_part(agua_superficie_seca, 0, 0, _alvo, 0, 0, _seca, _altura);
    // A cópia deixa a textura de origem vinculada; libera antes do filtro
    // voltar a usar essa mesma superfície como alvo de desenho.
    texture_set_stage(0, -1);
    agua_largura_seca = _seca;
}));

// Uma camada separada garante que a cópia ocorra depois do filtro.
// Copiar pixels evita alterar matrizes, transparência ou o estado de desenho.
layer_script_begin(agua_camada_restaura, method(id, function()
{
    if (event_type != ev_draw || event_number != ev_draw_normal) return;
    if (agua_largura_seca <= 0 || !surface_exists(agua_superficie_seca)) return;
    var _alvo = surface_get_target();
    if (!surface_exists(_alvo)) return;

    surface_copy_part(_alvo, 0, 0, agua_superficie_seca, 0, 0,
        agua_largura_seca, surface_get_height(agua_superficie_seca));
}));
#endregion

#region Geração de bolhas
// Limite de obj_buble na sala e intervalo entre novas bolhas, em Steps.
bolhas_maximo = 10;
bolhas_intervalo = 15;

// Tamanho relativo ao sprite: 1 = tamanho original, 0.5 = metade.
bolhas_escala_min = 0.05;
bolhas_escala_max = 0.30;

// Velocidade em pixels por Step e direção em graus (0 a 360 = todas).
bolhas_velocidade_min = 0.10;
bolhas_velocidade_max = 0.70;
bolhas_direcao_min = 0;
bolhas_direcao_max = 360;

// Começa gerando uma bolha no primeiro Step.
bolhas_tempo_ate_criar = 0;
#endregion

#region Sprites das camadas
// Use -1 para ocultar uma camada.
parallax_background_sprite = GrassLand_Background_1;
parallax_back_middleground_sprite = spr_house_shadow_1;
parallax_middleground_sprite = spr_house_shadow;
parallax_foreground_sprite = GrassLand_Background_4;

#endregion

#region Velocidades das camadas
// Fatores relativos ao movimento horizontal da câmera.
// 0 = fixa na tela em X, 1 = acompanha o mundo, acima de 1 = passa mais rápido.
parallax_background_speed = 0.20;
parallax_back_middleground_speed = 0.35;
parallax_middleground_speed = 0.55;
parallax_foreground_speed = 1.25;

#endregion

#region Posição das camadas
// Deslocamento em pixels do mundo; a base das camadas fica no fundo da sala.
// X positivo move para a direita. Y positivo desce além da base da sala.
// Y negativo eleva a camada; zero alinha sua borda inferior ao fundo da sala.
parallax_background_offset_x = 0;
parallax_background_offset_y = 0;
parallax_back_middleground_offset_x = 0;
parallax_back_middleground_offset_y = -60;
parallax_middleground_offset_x = 0;
parallax_middleground_offset_y = 30;
parallax_foreground_offset_x = 0;
parallax_foreground_offset_y = -30;

#endregion

#region Repetição das camadas
// true repete o sprite no eixo escolhido. false desenha uma única vez nesse eixo.
// X controla a repetição horizontal. Y controla a repetição vertical.
parallax_background_repeat_x = true;
parallax_background_repeat_y = true;
parallax_back_middleground_repeat_x = true;
parallax_back_middleground_repeat_y = false;
parallax_middleground_repeat_x = true;
parallax_middleground_repeat_y = false;
parallax_foreground_repeat_x = true;
parallax_foreground_repeat_y = false;

#endregion

#region Função de desenho do parallax
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

    // Usa o enquadramento padrão centrado na câmera como referência de movimento.
    // O zoom altera o canto da view mesmo sem mover seu centro; essa compensação
    // evita que as camadas deslizem em X só porque a câmera se aproximou.
    var _parallax_x = _view_x;
    if (instance_exists(obj_camera))
    {
        _parallax_x += (_view_width - global.camera_width) * 0.5;
    }

    var _left = round(_parallax_x * (1 - _speed) + _offset_x);
    // Mantém a borda inferior na base da sala, independente da câmera e do zoom.
    var _top = round(room_height - _height + _offset_y);

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
#endregion
