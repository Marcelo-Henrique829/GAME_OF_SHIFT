y = room_height / 2;
x = room_width + 40;

b_hspd = 0;
b_vspd = 0;
b_vel  = 4;

enum BOSS
{
	B_IN,	
	B_NOONE
}

b_state = BOSS.B_IN;

boss_in = function()
{	
   static timer = 120;	
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
	x -= _move;
	b_state = BOSS.B_IN;
	_move += 10;
}
