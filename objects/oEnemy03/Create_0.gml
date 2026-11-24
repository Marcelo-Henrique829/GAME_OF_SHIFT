hp = 10;
spd = 4; 
shot = oWreckage;
ship = obj_space_ship;
s_shot = obj_shot ;
enemys = [oEnemy_sps,oEnemy03];

enum EN03_STATES
{
	ENTER01,
	ENTER02,
	ENTER_EDGE,
	EXPLODE
}
state = noone;

if(y >= 830)
{
  state = EN03_STATES.ENTER02;
}
else
{
  state = EN03_STATES.ENTER01;
}

enter_room01 = function()
{
	x = lerp(x,room_width  / 4,.009);
	y = lerp(y,room_height / 2,.009);
	image_angle = point_direction(x,y,ship.x,ship.y);
}

enter_room02 = function()
{
	x = lerp(x,(room_width / 2) + 280,.009);
	y = lerp(y,room_height / 2,.009);	
	image_angle = point_direction(x,y,ship.x,ship.y);
}

shoot = function()
{
	static _timer = 120;
	_timer--;
	if(_timer <= 0)
	 {	 
		effect(); 
		var _shot = instance_create_layer(x,y,"shot",shot);
		_shot.hspeed = lengthdir_x(13,image_angle);
		_shot.vspeed = lengthdir_y(13,image_angle);
		_timer = 120;
	 }	
}

effect = function()
{
		image_xscale  = 1.4;
		image_yscale  = 0.04;
}

damage = function()
{
	
	if(place_meeting(x,y,s_shot)) //levando tiro
		{			
			screen_shake(8,12); 
			hitstop(2,40);
			hp--;
		}
		
	if(hp <= 0)
	 {
	    screen_shake(10,12);  
		state = EN03_STATES.EXPLODE;
		sprite_index = spr_explosion;
	 }
}

explode = function()
{
		//sprite_index = spr_explosion;
		if(image_index >= image_number-1)
		 {
			instance_destroy();
		 }
}