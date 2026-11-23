randomise();
enemys = [oEnemy_sps,oEnemy_explode,oEnemy03];
gba = obj_gba;
gba_blocks = [obj_block1,obj_block2,obj_block3];
ship = obj_space_ship;

#region surface
global.surface = surface_create(room_width,room_height);

create_surface = function()
{
	if(!surface_exists(global.surface))
	 {
		global.surface = surface_create(room_width,room_height);		
		if (surface_exists(global.surface) && surface_set_target(global.surface))
		 {
			draw_clear_alpha(c_black,0);
			surface_reset_target();
		 }
	 }
	else
	 {
		draw_surface(global.surface,0,0);
	 }
}

#endregion


create_base_enemy = function()
{
 static timer_create = 240;
	
	timer_create--;
	if(timer_create <= 0)
	 {
		var random_posx = choose(-65,1430);
		var random_num = choose(1,2,3);		
		 repeat(random_num)
		  {
			var random_posy = choose(-350,-200,163,398,935,1250);  
			var _enemy = instance_create_layer(random_posx,random_posy,"enemys",enemys[0]);
		  }
		timer_create = choose(120,240,300);
	 }
}

create_explode_enemy = function()
{
	static timer_create = 100;
	timer_create--;
	if(timer_create <= 0)
	 {
		var _qtd_bomb = choose(1,2,3);		
		var random_posx = choose(-40,room_width + 40);			
	repeat(_qtd_bomb)
		{			
		var random_posy = choose(180,282,400,540,630);		
			var _bomb = instance_create_layer(random_posx,random_posy,"enemys",enemys[1]);
		}
		static _t_min = 10;
		static _t_max = 20;
		timer_create = irandom_range(game_get_speed(gamespeed_fps)*_t_min,
		game_get_speed(gamespeed_fps)*_t_max);	
	 }			
}

create_enemy_shooter = function()
{
	static _timer = 300;
	_timer--;
	var _posy = choose(-151,994);
	var _posx = room_width / 2;
	if(_timer <= 0)
	 {
		var _enemy = instance_create_layer(_posx,_posy,"enemys",enemys[2]);
		static _t_min = 8;
		static _t_max = 20;
		_timer =irandom_range(game_get_speed(gamespeed_fps)*_t_min,
		game_get_speed(gamespeed_fps)*_t_max);
	 }
}

screenshake = function()
{
   view_xport = global.screen_shakex;
   view_yport = global.screen_shakey; 
   
   global.screen_shakex = lerp(global.screen_shakex,0,.1);
   global.screen_shakey = lerp(global.screen_shakey,0,.1);
}

black_screen = function()
{
		if(global.black_screen == 0) exit;
		var _c = c_black;
		static _time = game_get_speed(gamespeed_fps) * 10;
		var _t = get_timer() / 190500;
		var _alpha = cos(_t) * 3;
		_time--;
	
		draw_sprite_ext(spr_black_screen,0,0,0,21,20,1,c_black,_alpha);
		 if(_time <= 0)
		  {  
			_time = game_get_speed(gamespeed_fps) * 10;  
			global.black_screen = 0;		
		  }

}