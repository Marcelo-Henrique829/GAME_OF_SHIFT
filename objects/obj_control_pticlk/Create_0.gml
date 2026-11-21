inventarioadm()

	if (!instance_exists(obj_trocavisao))
	{
	
	instance_create_layer(room_width-100,room_height/2,"controle",obj_trocavisao)
	instance_create_layer(100,room_height/2,"controle",obj_trocavisao)
	
	
	}