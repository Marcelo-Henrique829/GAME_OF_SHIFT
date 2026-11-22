// Permite desativar a interação sem ocultar a caixa.
caixa_ativa = true;
caixa_arrastando = false;
arraste_offset_x = 0;
arraste_offset_y = 0;

// Raio de arraste em pixels, medido a partir da posição inicial da instância.
arraste_raio = 100;
arraste_origem_x = x;
arraste_origem_y = y;

// Mesma gravidade e resolução de colisões do jogador de plataforma.
grv = 0.5;
hspd = 0;
vspd = 0;
collision_targets = [obj_ground, obj_player_platform, obj_box];
var _collision_layer = layer_get_id("tlColision");
if (_collision_layer != -1)
{
    var _collision_tilemap = layer_tilemap_get_id(_collision_layer);
    if (_collision_tilemap != -1) array_push(collision_targets, _collision_tilemap);
}
