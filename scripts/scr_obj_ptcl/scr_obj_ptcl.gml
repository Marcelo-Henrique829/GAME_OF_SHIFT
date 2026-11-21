function interact(_obj){


	
	//interaction_zone = point_in_rectangle(mouse_x, mouse_y, x_objmin, y_objmax, x_objmax, y_objmin);
	interaction_zone = position_meeting(mouse_x,mouse_y,_obj)

	

	if ((interaction_zone = true) and (mouse_check_button_released(mb_left)) )
		{

				return _obj.interact_function()

		} 
		
}