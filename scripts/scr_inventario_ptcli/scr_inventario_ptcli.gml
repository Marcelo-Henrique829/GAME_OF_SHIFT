function inventarioadm(){
	global.itens = []
	
	
}

function add_item(_item)
	{
	
		array_push(global.itens, _item)
		show_message(global.itens)
	}
	
function room_change()
{

	camada = layer_get_all_elements("mobilia_itens")
		
		for(var i = 0; i<array_length(camada); i++){
			if (layer_get_element_type(camada[i]) == layerelementtype_instance) 
			{
		        var _inst = layer_instance_get_instance(camada[i]);
		        instance_destroy(_inst);
		    }
		}
	
}