randomise();
 //x = choose(-60,room_width + 50);
 //y = irandom_range(570,1440);

_x_dir = 0;
_y_dir = 0;

_timer = game_get_speed(gamespeed_fps) * 1;
enum ENEY5_STATES
{
	RM_IN,
	RNG_POSS,
	IN_POSS,
}
state = ENEY5_STATES.RNG_POSS;

rng_poss = function()
{
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

 
}

vel_poss_in = function()
{
	static _timer_o = game_get_speed(gamespeed_fps) * 1.5;
	_timer_o--;
	if(_timer_o <= 0) 
	 {		 
		_timer = game_get_speed(gamespeed_fps) * 1;
		_timer_o = game_get_speed(gamespeed_fps) * 1.5;
		state = ENEY5_STATES.RNG_POSS;
	 }
}