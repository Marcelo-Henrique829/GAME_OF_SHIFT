randomise();
enemys = [oEnemy_sps,oEnemy_explode];

ship = obj_space_ship;

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
			var random_posy = choose(180,282,400,540,670);			
			var _bomb = instance_create_layer(random_posx,random_posy,"enemys",enemys[1]);
		}
		static _t_min = 10;
		static _t_max = 20;
		timer_create = irandom_range(game_get_speed(gamespeed_fps)*_t_min,
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