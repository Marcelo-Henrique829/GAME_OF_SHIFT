hp = 1;
player = obj_space_ship;
hazzard = obj_shot;

enum ENEMY_SHIP_STATES
{
	ENTER,
	SHOTING,
	EXPLODE
}

move_to_ship = function()
{	
	image_angle = lerp(image_angle,
	point_direction(x,y,player.x,player.y),.1);
		
	x = lerp(x,player.x,.01); 
	y = lerp(y,player.y,.01); 
	
	dist_between()
}

distroy = function()
{
	if(position_meeting(x,y,hazzard))
		{
			hp--;
			with(hazzard)
			 {
				instance_destroy();
			 }
		}	
	if(hp <= 0)
	 {
		instance_destroy();
	 }
}

dist_between = function()
{
	var _brox = oEnemy_sps.x;
	var _broy = oEnemy_sps.y;
	
	x = clamp(x,10,_brox);
}