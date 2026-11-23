global.black_screen = 0;
global.surface = noone

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