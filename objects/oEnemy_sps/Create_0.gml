hp = 3;
player = obj_space_ship;
hazzard = obj_shot;

acel = 0.3;

enum ENEMY_SHIP_STATES
{
	ENTER,
	SHOTING,
	EXPLODE
}

move_to_ship = function()
{	
	image_angle = point_direction(x,y,player.x,player.y);
		
	x = lerp(x,player.x,.01); 
	y = lerp(y,player.y,.01); 
	
}

distroy = function()
{
	if(place_meeting(x,y,hazzard))
	{
		hp--;
	}
	
	if(hp <= 0)
	 {
		instance_destroy();
	 }
}