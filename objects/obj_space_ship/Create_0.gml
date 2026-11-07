//parametros de velocidade
acel = .2;
hspd = 0;
vspd = 0;
m_vspd  = 10;
m_hspd  = 12;


//estados enumerados e tals
enum SHIP_STATE 
{
	CONTROL,
	D_LEFT,
	D_RIGHT,
	FLIP_RIGHT,
	FLIP_LEFT,
}
state = SHIP_STATE.FLIP_LEFT ;

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
 
 last_key = noone;
 
}

//estado de controle geral
ship_control = function()
{
 //chamando os inputs	
  ipts();
  
  hspd += (k_right - k_left) * acel;
  vspd += (k_down - k_up) * acel;
  
  hspd = clamp(hspd,-m_hspd,m_hspd);
  vspd = clamp(vspd,-m_vspd,m_vspd);
 
	if(!k_right && !k_left)
		{hdps = lerp(hspd,0,.08);}

	if(!k_up && !k_down)
		{vspd = lerp(vspd,0,.08);}
 	
	//mudando de direção (esquerda)
	if(kp_left && state != SHIP_STATE.FLIP_LEFT)
	 {		
		sprite_index = spr_ss_flip_left; 
		state = SHIP_STATE.FLIP_LEFT;
	 }
	//mudando de direção (direita)
	if(kp_right && state != SHIP_STATE.FLIP_RIGHT)
	 {
		 image_xscale = -1; 
		 sprite_index = spr_ss_flip_right;
		 state = SHIP_STATE.FLIP_RIGHT;
	 }
	
  x +=hspd;
  y +=vspd;
}
//estado de girando


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