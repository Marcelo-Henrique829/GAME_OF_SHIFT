//parametros de velocidade
acel = 15;
hspd = 0;
vspd = 0;
m_vspd  = 6;
m_hspd  = 8;

//variaveis do tiro
deley_shot = 3;
timer_shot = 0;
//estados enumerados e tals
enum SHIP_STATE 
{
	ENTER, 
	CONTROL,
	FLIP_RIGHT,
	FLIP_LEFT
}
state = SHIP_STATE.ENTER;

//método com inputs
ipts = function()
{
 
 //controles de movimento
 k_left  =		keyboard_check(ord("A"));
 k_right =		keyboard_check(ord("D"));
 k_up    =		keyboard_check(ord("W"));
 k_down  =		keyboard_check(ord("S"));
 kp_left  =		keyboard_check_pressed(ord("A"));
 kp_right =		keyboard_check_pressed(ord("D"));
 
 shot   = noone;
 k_shot = keyboard_check(vk_space);
 
}

//iniciando a fase
ship_enter = function()
{
//calma, pera aí
	x += lerp(x,room_width  / 2,.1);
	y += lerp(y,room_height / 2,.1);

if(x == room_width / 2)
 {
	state = SHIP_STATE.FLIP_RIGHT;
 }

}
//estado de controle geral
ship_control = function()
{
 //chamando os inputs	
  ipts();
  //controle de velocidade
  hspd = (k_right - k_left) * acel;
  vspd = (k_down - k_up) * acel;
  
  hspd = clamp(hspd,-m_hspd,m_hspd);
  vspd = clamp(vspd,-m_vspd,m_vspd);
	
	if(!k_right || !k_left)
		{hdps = lerp(hspd,0,.1);}

	if(!k_up || !k_down)
		{vspd = lerp(vspd,0,.1);}
		
	//mudando de direção (esquerda)
	if(kp_left && state != SHIP_STATE.FLIP_LEFT)
	 {		
		sprite_index = spr_ss_flip_left; 
		state = SHIP_STATE.FLIP_LEFT;
		
	 }
	//mudando de direção (direita)
	if(kp_right && state != SHIP_STATE.FLIP_RIGHT)
	 {
		 sprite_index = spr_ss_flip_right;
		 state = SHIP_STATE.FLIP_RIGHT;
		 image_xscale = 1;
	 }
	
	//tiro
	timer_shot--;
	 if(k_shot && timer_shot <= 0)
	  {
		shoting();
	  }
	
  x = clamp(x,0,room_width);		
  y = clamp(y,0,room_height);		
	
  x +=hspd;
  y +=vspd;
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

shoting = function()
{	  
	var _shot_spd = 20;
		 shot = instance_create_layer(x,y,"shot",obj_shot);		 	 
		 shot.image_xscale = image_xscale;
		 shot.hspeed = _shot_spd * image_xscale;
		 timer_shot = deley_shot;
}