gba_spr = [spr_gba_closed,spr_gba_opened];

enum GBA_STATE
{
	OPEN,
	CLOSE	
}

state = GBA_STATE.CLOSE; 

gba_close = function()
{
	x = lerp(x,939,.06);
	y = lerp(y,670,.06);
	
	sprite_index = gba_spr[0];
	
	if (position_meeting(mouse_x,mouse_y,self)) 
	 {	
		if(mouse_check_button_pressed(mb_left))
		 {
			state = GBA_STATE.OPEN;
		 }
	 }
	if(mouse_check_button_pressed(mb_right))
	 {
		state = GBA_STATE.OPEN;
	 }
}

gba_open = function()
{	
	x = lerp(x,939,.1);
	y = lerp(y,464,.1);

	sprite_index = gba_spr[1];

	if (position_meeting(mouse_x,mouse_y,self)) 
	 {	
		if(mouse_check_button_pressed(mb_left))
		 {
			state = GBA_STATE.CLOSE;
		 }
	 }
    if(mouse_check_button_pressed(mb_right))
		 {
			state = GBA_STATE.CLOSE;
		 }
}