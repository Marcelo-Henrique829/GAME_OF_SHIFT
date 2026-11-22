// Filhos chamam event_inherited() e podem alterar estas configurações.
life = 3;
popup_ativo = true;
popup_sprite_aparecer = spr_popup_apear;
popup_sprite_parado = spr_pop_up;
popup_sprite_hit = spr_popup_hit;
popup_sprite_morrer = spr_popup_destroy;
popup_distancia_reposicionar = 500;
popup_deslocamento_min = 50;
popup_deslocamento_max = 200;
// Variação vertical em torno do Y do jogador, em pixels; 0 mantém o mesmo Y.
popup_variacao_y = 16;
popup_tremida = 2;

// Troca de estado reiniciando a animação, inclusive ao receber outro golpe.
popup_set_state = function(_state)
{
    state = _state;
    switch (state)
    {
        case "apear": sprite_index = popup_sprite_aparecer; break;
        case "iddle": sprite_index = popup_sprite_parado; break;
        case "hit": sprite_index = popup_sprite_hit; break;
        case "die": sprite_index = popup_sprite_morrer; break;
    }
    image_index = 0;
    image_speed = 1;
    if (state == "apear" || state == "hit" || state == "die")
    {
        global.shake = max(global.shake, max(0, popup_tremida));
    }
};

// Também disponível para futuros ataques, sem depender de obj_attack.
popup_receive_hit = function(_damage = 1)
{
    if (!popup_ativo || (state != "iddle" && state != "hit")) return;
    life = max(0, life - max(0, _damage));
    popup_set_state(life <= 0 ? "die" : "hit");
};

popup_set_state("apear");
