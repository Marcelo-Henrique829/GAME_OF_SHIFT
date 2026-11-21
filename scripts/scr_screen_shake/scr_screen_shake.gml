// Intensidade em pixels de tela. Outros objetos podem aumentá-la para iniciar a tremida.
global.shake = 0;

/// @function scr_screen_shake()
/// @description Retorna o deslocamento da tremida e reduz sua intensidade. Chamar uma vez por frame na câmera.
function scr_screen_shake()
{
    global.shake = clamp(global.shake, 0, 60);
    var _offset = [0, 0];

    if (global.shake > 0)
    {
        _offset[0] = random_range(-global.shake, global.shake);
        _offset[1] = random_range(-global.shake, global.shake);
        global.shake = max(0, global.shake - 0.5);
    }
    return _offset;
}
