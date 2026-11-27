ship = obj_space_ship;

gun = function()
{
	
image_angle = point_direction(x,y,obj_space_ship.x,obj_space_ship.y);

static timer = 180;
timer--;

	if(timer <= 0)
	 {
		var s_spd = 16;
		var _s =instance_create_layer(x,y,"shot",oWreckage);
		_s.image_xscale = 3;
		_s.image_yscale = 3;
		_s.hspeed = lengthdir_x(s_spd,image_angle);
		_s.vspeed = lengthdir_y(s_spd,image_angle);
		timer = 35;
	 }

}