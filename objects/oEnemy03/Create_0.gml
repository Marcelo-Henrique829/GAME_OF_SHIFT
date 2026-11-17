hp = 50;
spd = 4; 
shot = oWreckage;
ship = obj_space_ship;

enum EN03_STATES
{
	ENTER01,
	ENTER02,
	ENTER_EDGE,
}
state = noone

//state = ;

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



if(y >= 830)
{
  state = EN03_STATES.ENTER02;

}
else
{
  state = EN03_STATES.ENTER01;
  
}