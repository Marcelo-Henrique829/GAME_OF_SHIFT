item = "Armario"
is_item = false 
hud_interact = false

interact_function = function()
{

	
	if (is_item = true)
		{
			visible = false
			add_item(item)
	
		}
	else
		if (!hud_interact)
			{
	
				show_message("é movel")
	
			}
		else
		{
		
		room_change()
		
		}

}
