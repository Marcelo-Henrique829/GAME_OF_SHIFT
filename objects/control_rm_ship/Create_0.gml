randomise();
enemys = [oEnemy_sps];

timer_create = 180;

create_base_enemy = function()
{
	timer_create--;
	var random_posx = choose(-575,2730);
	var random_posy = choose(163,398,935);
		
	if(timer_create <= 0)
	 {
		var random_num = choose(1,2,3);
		 repeat(random_num)
		  {
			instance_create_layer(random_posx,random_posy,"enemys",enemys[0]);
		  }
		timer_create = choose(60,120,240,300);
	 }
}