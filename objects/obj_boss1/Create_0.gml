y = room_height / 2;
x = room_width + 40;

b_hspd = 0;
b_vspd = 0;
b_vel  = 4;

hp = 400;

ship = obj_space_ship;
s_shot = obj_shot;

enum BOSS
{
	B_IN,	
	B_NOONE
}

b_state = BOSS.B_IN;

#region boss behavior

boss_in = function()
{	
   static timer = 300;	
	timer--;
	x = lerp(x,1250,.1);
	
  if(timer <= 0)
   {
	static _sca  = 1;
	static _alp  = 1;
	_sca += 0.1;
	_alp -= 0.05;
	draw_sprite_ext(sprite_index,image_index,x,y,_sca,_sca,0,c_white,_alp);
	
	if(_alp <= 0)
     {	
	  instance_create_layer(x,y - 35,"enemys",obj_boss_gun);	 
	  timer = 120;
	  _sca = 1;
	  _alp = 1;
	  b_state = BOSS.B_NOONE; return 1;
   	 }
   }	  
}

boss_noone = function()
{
	static _move = 20;
	//x -= _move;
}

damage = function()
{	
	if(place_meeting(x,y,s_shot)) //levando tiro
		{			
			screen_shake(2.3,2.3); 
			hitstop(2,70);
			hp-=0.0999;
		}		
}

#endregion

#region draw functions
x2 = 70;

draw_hp = function()
{
	
	var x1,y1,y2;
	
	x1 = 70;
	//x2 +=1;
	y1 = 740;
	y2 = y1 +10;
	
	x2 = lerp(x2,hp,0.06);
	
	var hp_minus = 5
	if(x2 >= hp - hp_minus)
	 {
		x2 = hp;
	 }
	
	//x2 = clamp(x2,0,hp)
	draw_rectangle(x1,y1,x2,y2,0);
	
}


#endregion