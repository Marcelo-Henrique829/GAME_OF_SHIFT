randomise();
 x = choose(-20,room_width + 20);
 y = irandom_range(200,room_width - 500);
    hspd = 0;

timer_distroy = game_get_speed(gamespeed_fps) * 10.5;

_timer = game_get_speed(gamespeed_fps) * 1;
enum ENEY5_STATES
{
	RM_IN,
	RNG_POSS,
	IN_POSS,
	P_CAUGHT
}
state = ENEY5_STATES.RM_IN;

rng_poss = function()
{
image_angle+=2.3;	
	_timer--;	
	 static _x_dir = choose(45,135,225,315);
	 static _y_dir = choose(45,135,225,315);

	x += lengthdir_x(3,_x_dir);
	y += lengthdir_y(3,_y_dir);
	
	if(_timer <= 0)
	 {		 
		state = ENEY5_STATES.IN_POSS;
		_x_dir = choose(45,135,225,315);
		_y_dir = choose(45,135,225,315);	
	 }
	
	if(place_meeting(x,y,obj_space_ship))
	 {
		sprite_index = spr_inimigo_follow_caugth;
		state = ENEY5_STATES.P_CAUGHT;
	 }
}

vel_poss_in = function()
{
image_angle+=2.3;	
	static _timer_o = game_get_speed(gamespeed_fps) * 1.5;
	_timer_o--;
	if(_timer_o <= 0) 
	 {		 
		_timer = game_get_speed(gamespeed_fps) * 1;
		_timer_o = game_get_speed(gamespeed_fps) * 1.5;
		state = ENEY5_STATES.RNG_POSS;
	 }
	 if(place_meeting(x,y,obj_space_ship))
	 {
	//	image_speed = 0;
		sprite_index = spr_inimigo_follow_caugth;
		state = ENEY5_STATES.P_CAUGHT;
	 }
}

p_caught = function()
{
timer_distroy = 180;	
screen_shake(4,8);	
x = lerp(x,obj_space_ship.x,.2);		
y = lerp(y,obj_space_ship.y,.2);		
	
image_angle += 15;	
image_speed = 0.2;
		
	if(image_index >= image_number -1)
	 {
		hitstop(2,20); 
		global.black_screen = 1; 
		instance_destroy();
	 }
}

hop_room = function()
{
image_angle+=2.3;
    if(x <= 0)
     {
        hspd = 4;
     }
    if(x >= room_width)
     {
        hspd = -4;
     }   
    x += hspd;
    
    var _gap = x = clamp(x,160,room_width -160);
        if(_gap)
        {
            state = ENEY5_STATES.IN_POSS;
        }    
}