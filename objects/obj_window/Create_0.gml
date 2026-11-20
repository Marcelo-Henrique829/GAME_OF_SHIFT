// O alpha do sprite define a abertura. Escala, rotação e image_alpha são respeitados.
janela_ativa = true;
janela_camada = -1;
janela_dados = undefined;
janela_arrastando = false;
arraste_offset_x = 0;
arraste_offset_y = 0;

// Captura após os dois backgrounds visíveis mais profundos atrás da janela.
var _camadas = layer_get_all();
var _profundidade = depth;
var _penultima_profundidade = depth;
var _ultima_camada = -1;
var _penultima_camada = -1;
for (var _i = 0; _i < array_length(_camadas); _i++)
{
    var _camada = _camadas[_i];
    var _depth = layer_get_depth(_camada);
    var _background = layer_background_get_id(_camada);
    if (_depth > depth && layer_get_visible(_camada) && _background != -1
        && layer_background_get_visible(_background))
    {
        if (_depth > _profundidade)
        {
            _penultima_camada = _ultima_camada;
            _penultima_profundidade = _profundidade;
            _ultima_camada = _camada;
            _profundidade = _depth;
        }
        else if (_depth > _penultima_profundidade)
        {
            _penultima_camada = _camada;
            _penultima_profundidade = _depth;
        }
    }
}
// Se houver apenas um background, preserva o único disponível.
janela_camada = (_penultima_camada != -1) ? _penultima_camada : _ultima_camada;
if (janela_camada == -1) exit;

// Janelas que revelam o mesmo background compartilham as superfícies e a captura.
for (var _i = 0; _i < instance_number(obj_window); _i++)
{
    var _janela = instance_find(obj_window, _i);
    if (_janela == id || !variable_instance_exists(_janela, "janela_dados")) continue;
    if (is_struct(_janela.janela_dados) && _janela.janela_camada == janela_camada)
    {
        janela_dados = _janela.janela_dados;
        break;
    }
}
if (!is_struct(janela_dados))
{

janela_dados = {
    camada: janela_camada,
    fundo: -1,
    recorte: -1,
    capturou: false,
    camadas_janela: [],
    script_fim_anterior: layer_get_script_end(janela_camada)
};

janela_dados.desenhar_mascara = method(janela_dados, function(_janela)
{
    draw_sprite_ext(_janela.sprite_index, _janela.image_index,
        _janela.x, _janela.y, _janela.image_xscale, _janela.image_yscale,
        _janela.image_angle, c_white, clamp(_janela.image_alpha, 0, 1));
});

janela_dados.capturar = method(janela_dados, function()
{
    if (is_callable(script_fim_anterior)) script_fim_anterior();
    if (event_type != ev_draw || event_number != ev_draw_normal) return;
    capturou = false;

    var _alvo = surface_get_target();
    if (!surface_exists(_alvo)) return;
    var _largura = surface_get_width(_alvo);
    var _altura = surface_get_height(_alvo);

    // Recria as superfícies após perda de contexto ou mudança de resolução.
    if (surface_exists(fundo))
    {
        if (surface_get_width(fundo) != _largura || surface_get_height(fundo) != _altura)
        {
            surface_free(fundo);
            fundo = -1;
        }
    }
    if (surface_exists(recorte))
    {
        if (surface_get_width(recorte) != _largura || surface_get_height(recorte) != _altura)
        {
            surface_free(recorte);
            recorte = -1;
        }
    }
    if (!surface_exists(fundo)) fundo = surface_create(_largura, _altura);
    if (!surface_exists(recorte)) recorte = surface_create(_largura, _altura);
    if (!surface_exists(fundo) || !surface_exists(recorte)) return;

    // Guarda os dois últimos backgrounds antes das demais camadas da cena.
    surface_copy(fundo, 0, 0, _alvo);
    texture_set_stage(0, -1);
    capturou = true;
});

janela_dados.recortar = method(janela_dados, function(_janela)
{
    if (!_janela.janela_ativa || !_janela.visible || _janela.sprite_index == -1) return;
    if (event_type == ev_draw && event_number == ev_draw_normal && capturou
        && surface_exists(fundo) && surface_exists(recorte))
    {
        var _world = matrix_get(matrix_world);
        var _view = matrix_get(matrix_view);
        var _projection = matrix_get(matrix_projection);
        var _camera = camera_get_active();
        var _shader = shader_current();
        var _alpha = draw_get_alpha();
        var _colour = draw_get_colour();
        gpu_push_state();
        shader_reset();
        gpu_set_blendenable(true);
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        gpu_set_alphatestenable(false);
        draw_set_alpha(1);
        draw_set_colour(c_white);
        texture_set_stage(0, -1);

        if (surface_set_target(recorte))
        {
            // O alvo usa coordenadas de pixels; guarda-as para copiar o fundo sem zoom.
            var _pixel_view = matrix_get(matrix_view);
            var _pixel_projection = matrix_get(matrix_projection);
            draw_clear_alpha(c_black, 0);

            // As máscaras usam as mesmas matrizes da sala, acompanhando câmera e zoom.
            matrix_set(matrix_world, _world);
            matrix_set(matrix_view, _view);
            matrix_set(matrix_projection, _projection);
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha,
                bm_one, bm_inv_src_alpha);
            desenhar_mascara(_janela);

            // Mantém apenas o fundo contido no alpha das aberturas.
            matrix_set(matrix_world, matrix_build_identity());
            matrix_set(matrix_view, _pixel_view);
            matrix_set(matrix_projection, _pixel_projection);
            gpu_set_blendmode_ext(bm_dest_alpha, bm_zero);
            draw_surface(fundo, 0, 0);
            surface_reset_target();
            if (_camera != -1) camera_apply(_camera);
            matrix_set(matrix_world, _world);
            matrix_set(matrix_view, _view);
            matrix_set(matrix_projection, _projection);

            // Subtrai as camadas intermediárias e repõe os dois backgrounds preservados.
            // O resultado também preserva transparências e janelas sobrepostas.
            gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
            desenhar_mascara(_janela);
            matrix_set(matrix_world, matrix_build_identity());
            matrix_set(matrix_view, _pixel_view);
            matrix_set(matrix_projection, _pixel_projection);
            gpu_set_blendmode_ext(bm_one, bm_one);
            draw_surface(recorte, 0, 0);
            texture_set_stage(0, -1);
        }

        matrix_set(matrix_world, _world);
        matrix_set(matrix_view, _view);
        matrix_set(matrix_projection, _projection);
        draw_set_alpha(_alpha);
        draw_set_colour(_colour);
        if (_shader == -1) shader_reset();
        else shader_set(_shader);
        gpu_pop_state();
    }
});

layer_script_end(janela_camada, janela_dados.capturar);
}

// Recorta antes de desenhar a camada da janela. Assim o jogador e todos os
// outros elementos dessa camada permanecem visíveis, qualquer que seja a ordem das instâncias.
for (var _i = 0; _i < array_length(janela_dados.camadas_janela); _i++)
{
    if (janela_dados.camadas_janela[_i].camada == layer) exit;
}
var _registro = {
    camada: layer,
    anterior: layer_get_script_begin(layer)
};
_registro.desenhar = method(_registro, function()
{
    if (event_type == ev_draw && event_number == ev_draw_normal)
    {
        for (var _i = 0; _i < instance_number(obj_window); _i++)
        {
            var _janela = instance_find(obj_window, _i);
            if (_janela.layer != camada || !variable_instance_exists(_janela, "janela_dados")) continue;
            if (is_struct(_janela.janela_dados)) _janela.janela_dados.recortar(_janela);
        }
    }
    if (is_callable(anterior)) anterior();
});
array_push(janela_dados.camadas_janela, _registro);
layer_script_begin(layer, _registro.desenhar);
