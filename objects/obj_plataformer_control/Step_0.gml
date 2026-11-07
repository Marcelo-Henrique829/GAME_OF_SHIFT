// Conta todas as bolhas da sala, inclusive as colocadas pelo editor.
var _maximo = max(0, floor(bolhas_maximo));
if (instance_number(obj_buble) >= _maximo)
{
    bolhas_tempo_ate_criar = 0;
    exit;
}

// Repõe as bolhas aos poucos, sem ultrapassar o limite configurado.
bolhas_tempo_ate_criar = max(0, bolhas_tempo_ate_criar - 1);
if (bolhas_tempo_ate_criar > 0) exit;
bolhas_tempo_ate_criar = max(1, floor(bolhas_intervalo));

// Aceita os limites invertidos e evita escala nula ou velocidade negativa.
var _escala_min = max(0.01, min(bolhas_escala_min, bolhas_escala_max));
var _escala_max = max(_escala_min, max(bolhas_escala_min, bolhas_escala_max));
var _velocidade_min = max(0, min(bolhas_velocidade_min, bolhas_velocidade_max));
var _velocidade_max = max(_velocidade_min, max(bolhas_velocidade_min, bolhas_velocidade_max));
var _direcao_min = min(bolhas_direcao_min, bolhas_direcao_max);
var _direcao_max = max(bolhas_direcao_min, bolhas_direcao_max);
var _escala = random_range(_escala_min, _escala_max);

// O próprio obj_buble configura sua camada com ripple no evento Create.
var _bolha = instance_create_layer(random(room_width), random(room_height), layer, obj_buble);
_bolha.image_xscale = _escala;
_bolha.image_yscale = _escala;
_bolha.speed = random_range(_velocidade_min, _velocidade_max);
_bolha.direction = random_range(_direcao_min, _direcao_max);
