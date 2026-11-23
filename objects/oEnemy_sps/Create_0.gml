hp = 3;
player = obj_space_ship;
s_shot = obj_shot;
enemys = [oEnemy_sps,oEnemy03];

enum ENEMY_BASE_STATES
{
	FOLLOW,
	EXPLODE,
}

state = ENEMY_BASE_STATES.FOLLOW

move_to_ship = function()
{	
	image_angle = lerp(image_angle,point_direction(x,y,player.x,player.y),.1);
		
	x = lerp(x,player.x,.01); 
	y = lerp(y,player.y,.01);
	
	if(place_meeting(x,y,enemys))
	 {
		hp = 0;	
	 }
	damage();		
}

damage = function()
{
	
	if(position_meeting(x,y,s_shot)) //levando tiro
		{
			dust_effect(x,y);
			hp--;
			screen_shake(6,5); 
			with(s_shot)
			 {
				instance_destroy();
			 }
		}	
		
	if(hp <= 0)
	 {
	    screen_shake(10,12);  
		state = ENEMY_BASE_STATES.EXPLODE;
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