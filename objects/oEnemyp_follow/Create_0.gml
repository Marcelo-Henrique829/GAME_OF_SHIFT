randomise();
 //x = choose(-60,room_width + 50);
 //y = irandom_range(570,1440);

vspd = 0;
hspd = 0;

 _timer = 0;

enum ENEY5_STATES
{
	RM_IN,
	RNG_POSS,
	IN_POSS,
}
state = ENEY5_STATES.RNG_POSS;

rng_poss = function()
{
		_timer = game_get_speed(gamespeed_fps) * 4;	
	_timer--;
	vspd = 0;
	hspd = 0;
	
	var _x_dir = choose(0,90,180,270);
	var _y_dir = choose(0,90,180,270);

	hspd = lengthdir_x(3,_x_dir);
	vspd = lengthdir_y(3,_y_dir);
	
	if(_timer <= 0)
	 { 
		state = ENEY5_STATES.IN_POSS;
		_timer = game_get_speed(gamespeed_fps) * 4; 
	 }

}

vel_poss_in = function()
{
	x += hspd;
	y += vspd;
	static _timer_o = game_get_speed(gamespeed_fps);
	_timer_o--;
	if(_timer_o <= 0) 
	 {
		vspd = 0;
		hspd = 0;		 
		state = ENEY5_STATES.RNG_POSS;

	 }
}