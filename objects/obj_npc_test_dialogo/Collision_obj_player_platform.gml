// Inicia a conversa uma vez enquanto o jogador estiver encostado.
if (!instance_exists(Obj_dialogo))
{
	var _dialogo = instance_create_layer(x, y, "Instances", Obj_dialogo);
	_dialogo.dialogo = dialogo;
	_dialogo.player = other;
	other.dialogo_ativo = true;
}
