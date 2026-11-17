randomise();

gba_spr = [spr_gba_closed,spr_gba_opened_anim,spr_gba_open];
block = [obj_block1,obj_block2,obj_block3];
ship = obj_space_ship;
enum GBA_STATE
{
	CLOSE,
	OPENING,
	OPEN	
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
			state = GBA_STATE.OPENING;		
		 }
	 }
	if(mouse_check_button_pressed(mb_right))
	 {
		state = GBA_STATE.OPENING; 
		//state = GBA_STATE.OPEN;
	 }
}

gba_opening = function()
{
x = lerp(x,939,.1);
y = lerp(y,463.9,.1);
	
	sprite_index = gba_spr[1];
	 if((image_index >= image_number -1) && (y >= 464))
	  {
		instance_block();
		state = GBA_STATE.OPEN;
	  }
}

gba_open = function()
{	
x = lerp(x,939,.1);
y = lerp(y,464,.1);	
	sprite_index = gba_spr[2];


/*
	if (position_meeting(mouse_x,mouse_y,self)) 
	 {	
		if(mouse_check_button_pressed(mb_left))
		 {
			state = GBA_STATE.CLOSE;
		 }
	 }
	*/
	valid();
    if(mouse_check_button_pressed(mb_right))
		 {
			if(instance_exists(block[0]) || instance_exists(block[1]) || instance_exists(block[2]))
			 {
				instance_destroy(block[0]);
				instance_destroy(block[1]);
				instance_destroy(block[2]);
			 }
			sprite_index = gba_spr[0]; 
			state = GBA_STATE.CLOSE;
		 }
}

instance_block = function()
{
//arow poss x=72, y=202		
	static _marg = 80;
	var _y =y+202; 
	for(var i = 1; i <= 2; i++)
	 {
		var _blc = instance_create_layer((x+90) + (_marg * i),_y,"gba_blocks",block[0]);
		_blc.direction = choose(180,90,270);
	 }
	
	instance_create_layer((x+92),_y,"gba_blocks",block[1]);
	instance_create_layer((x+92) + 225,_y,"gba_blocks",block[2]);
	
}

valid = function()
{ 
			if(global.gba_block01 = true && global.gba_block02 = true && global.gba_block03 = true)
			 {
				ship.hp+=1;
			if(instance_exists(block[0]) || instance_exists(block[1]) || instance_exists(block[2]))
			 {
				instance_destroy(block[0]);
				instance_destroy(block[1]);
				instance_destroy(block[2]);
			 }
				state = GBA_STATE.CLOSE;
			 }
}