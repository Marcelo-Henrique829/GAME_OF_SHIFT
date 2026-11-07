// End Step acontece depois do movimento automático de speed e direction.
// Considera todo o sprite, incluindo seu tamanho: só destrói quando sair por inteiro.
if (bbox_right < 0 || bbox_left > room_width
    || bbox_bottom < 0 || bbox_top > room_height)
{
    instance_destroy();
}
