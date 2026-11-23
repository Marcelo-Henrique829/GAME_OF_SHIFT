time_stop--;

if(time_stop >= 0)
 {
	game_set_speed(spd_stop, gamespeed_fps)
 }
else
 {
	game_set_speed(60,gamespeed_fps);
	instance_destroy();
 }