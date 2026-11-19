hp = 50;
x = room_width / 2;
y = -110;

_x = x;
_y = y;

dir_to_shot = noone;

ship = obj_space_ship;

enum ENEMY4
{
	DOWN,
	SEARCH,
	SHOT,
	DEATH
}

state = ENEMY4.DOWN;

goto_room = function()
{
	y+= 3;
	image_angle += 3;	
	damage()
	if(y >= (room_height / 2) - 5)
	 {
		  state = ENEMY4.SEARCH;     
	 }
}

search = function()
{ 	
	image_angle+= 3
	static _timer = game_get_speed(gamespeed_fps) * 3;
	_timer--;
	damage()
	if(_timer <= 0)
	 {
		state = ENEMY4.SHOT;
	 }
}

shot = function()
{
	damage();
	image_angle += (hp / 8) + 0.4;	
	static _t_shot = 20;
	_t_shot--;
	if(_t_shot <= 0)
	 {
		screen_shake(3,3);
		var _s = instance_create_layer(x,y,"shot",oWreckage);
		_s.hspeed = lengthdir_x(50,image_angle);
		_s.vspeed = lengthdir_y(50,image_angle);
		_s.image_xscale = 3.2;
		_s.image_yscale = 3.2;
		_t_shot = 20;
	 }
}

explode = function()
{
		
		if(image_index >= image_number-1)
		 {
			instance_destroy();
		 }
}

damage = function()
{
	if(position_meeting(x,y,obj_shot)) //levando tiro
		{
			hp--;
			_x += random_range(6,10);
			_y += random_range(8,12);
			screen_shake(2,3); 
			with(obj_shot)
			 {
				instance_destroy();
			 }
		}
	
	if(hp <= 0)
	 {
		sprite_index = spr_explosion; 
		state = ENEMY4.DEATH;
	 }
}

shake_effect = function()
{ 

draw_sprite_ext(sprite_index,image_speed,_x,_y,1,1,image_angle,c_white,1);

	_x = lerp(_x,x,.1);
	_y = lerp(_y,y,.1);

}