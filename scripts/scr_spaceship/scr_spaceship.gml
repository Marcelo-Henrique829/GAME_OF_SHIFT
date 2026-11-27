global.black_screen = 0;
global.surface = noone;
global.histop = 0;
global.spaceships_points = 0;

function dust_effect(_x,_y)
{
  if(surface_exists(global.surface))
   {
	surface_set_target(global.surface);   
	repeat(random_range(5,15))
	 {
		instance_create_layer(_x,_y,"shot",obj_dust);
	 }
	surface_reset_target();
   }
}

function hitstop(_time = 2, _spd = 20 )
{
 var _hit =	instance_create_layer(x,y,layer,obj_hitstop);
 
 _hit.time_stop = _time;
 _hit.spd_stop	= _spd ;
		
}
