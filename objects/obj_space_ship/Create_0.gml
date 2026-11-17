mask_index = spr_ss_maskcol;

//parametros de velocidade
acel = 6;
hspd = 0;
vspd = 0;
m_vspd  = 10;
m_hspd  = 12;

//vida e dano
ar_enemys = [oEnemy_sps,oEnemy_explode,oWreckage];
damage = 0
hp = 1; 

//variaveis do tiro
deley_shot = 3;
timer_shot = 0;
//estados enumerados e tals
enum SHIP_STATE 
{
	ENTER, 
	CONTROL,
	FLIP_RIGHT,
	FLIP_LEFT,
	DEFEAT
}
state = SHIP_STATE.ENTER;

//método com inputs
ipts = function()
{
 
 //controles de movimento
 k_left   =		keyboard_check(vk_left)			 ||	keyboard_check(ord("A"));		
 k_right  =	   	keyboard_check(vk_right)		 ||	keyboard_check(ord("D"));		
 k_up     =	   	keyboard_check(vk_up)			 ||	keyboard_check(ord("W"));		
 k_down   =	   	keyboard_check(vk_down)			 ||	keyboard_check(ord("S"));
 kp_left  =	    keyboard_check_pressed(vk_left)	 ||	keyboard_check_pressed(ord("A"));
 kp_right =	    keyboard_check_pressed(vk_right) ||	keyboard_check_pressed(ord("D"));
 
 shot   = noone;
 k_shot = keyboard_check(vk_space) || mouse_check_button(mb_left);
 
}

//iniciando a fase
ship_enter = function()
{
	static _timer = 140;
	_timer--;
	x = lerp(x,room_width  / 2,.05);
	y = lerp(y,room_height / 2,.05);

if(_timer <= 0)
	 {
		state = SHIP_STATE.FLIP_RIGHT;
	 }

}
//estado de controle geral
ship_control = function()
{
 //chamando os inputs
  ipts();
  
    //tiro  
	timer_shot--;
	if(k_shot && timer_shot <= 0)
	  {
		shoting();
	  }  
  
  //controle de velocidade
  hspd = (k_right - k_left) * acel;
  vspd = (k_down - k_up) * acel;
  
 // hspd = clamp(hspd,-m_hspd,m_hspd);
  vspd = clamp(vspd,-m_vspd,m_vspd);
  
	//tiro
  
	
	/*if(!k_right || !k_left)
		{hdps = lerp(hspd,0,.1);}

	if(!k_up || !k_down)
		{vspd = lerp(vspd,0,.1);}*/
		
	//mudando de direção (esquerda)
	if(k_left && state != SHIP_STATE.FLIP_LEFT)
	 {		
		sprite_index = spr_ss_flip_left; 
		state = SHIP_STATE.FLIP_LEFT;
	 }
	//mudando de direção (direita)
  	if(k_right && state != SHIP_STATE.FLIP_RIGHT)
	 {
		 sprite_index = spr_ss_flip_right;
		 state = SHIP_STATE.FLIP_RIGHT;
		 image_xscale = 1;
	 }
	 
	 //dano
      if(place_meeting(x,y,ar_enemys) && damage = 0)
	   {
			hp -= 1;
			damage = 1;
			screen_shake(25,22);
	   }	   
	  if(damage)
	   {
			static timer_iv = 180;
			timer_iv--;
			image_alpha = cos(get_timer() / 106000);				
			  if(timer_iv <= 0)
			   {
				   timer_iv = 180;
				   damage = 0;
				   image_alpha = 1;
			   }
	   }	
	//morrendo
	if(hp <= 0) 
	 {
		image_alpha = 1;
		sprite_index = spr_spaceShip_defeat;		 
		state = SHIP_STATE.DEFEAT;
	 }

  x +=hspd;
  y +=vspd;

  x = clamp(x,0,room_width);		
  y = clamp(y,0,room_height);		
}

//mudando de direção
ship_flip_left = function()
{		
		if(image_index >= image_number-1)
		 {
			sprite_index = spr_spaceShip;
			image_xscale = 1;
		 }
}

ship_flip_right = function()
{	
		if(image_index >= image_number-1)
		 {			
			sprite_index = spr_spaceShip;
			image_xscale = -1;
		 }
}
//atirando
shoting = function()
{	
	if(state == SHIP_STATE.DEFEAT) exit;
	var _shot_spd = 35;
		 shot = instance_create_layer(x,y,"shot",obj_shot);		 	 
		 shot.image_xscale = image_xscale;
		 shot.hspeed = _shot_spd * image_xscale;
		 timer_shot = deley_shot;
}
//morredo
ship_defeat = function()
{
	var _acel = 5;	
	image_angle+=3; 	
	vspd += _acel;
	
	y+= vspd;
}