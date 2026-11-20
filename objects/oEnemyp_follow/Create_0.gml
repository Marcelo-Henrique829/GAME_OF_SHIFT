randomise();
 //x = choose(-60,room_width + 50);
 //y = irandom_range(570,1440);

vspd = 0;
hspd = 0;

rng_poss = function()
{
	var _x_dir = choose(0,90,180,270);
	var _y_dir = choose(0,90,180,270);
	hspd = lengthdir_x(10,_x_dir);
	vspd = lengthdir_y(10,_y_dir);
	
	
	x +=hspd;
	y +=vspd;
}