image_alpha = 0;
alpha_increment = 0.3;


credit_ar = [arthu,kaiky,davi,marcelo,riccelly];
credit_create = function()
{
	
// x inicial: 281
// y inicial: 176	

	 var ar_size = array_length(credit_ar)-1;	
	for(var i = 0;i <= ar_size ;i++)
	 {
		var _marg = 4;		
		instance_create_layer(  x+281,y-176,"credits",credit_ar[i]);
	 }

	//instance_create_layer(  x+281,y-176,"credits",arthu);
	
}

credit_create();

close_folder = function()
{	
	//tamanho do sprites
	var _spr_width  = sprite_get_width(spr_folder_credits);
    var _spr_height = sprite_get_height(spr_folder_credits);
		
	//click do mouse
	var _m_click = mouse_check_button_released(mb_left);	
	
	//intervalo do mouse
    var m_x_gap = mouse_x = clamp(mouse_x,1078,1113);
    var m_y_gap = mouse_y = clamp(mouse_y,90,120);
	
	var _poss_met = position_meeting(m_x_gap,m_y_gap,self)

	if(m_x_gap && m_y_gap)
	 {	 
		if(_m_click)
		 {
			image_alpha--;
			instance_destroy()
		 }
	 }
}

