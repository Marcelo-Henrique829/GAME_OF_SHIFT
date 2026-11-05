acel = .2;
hspd = 0;
vspd = 0;
m_vspd  = 8;
m_hspd  = 8;


ipts = function()
{
 
 //controles de movimento
 k_left  =		keyboard_check(ord("A"));
 k_right =		keyboard_check(ord("D"));
 k_up    =		keyboard_check(ord("W"));
 k_down  =		keyboard_check(ord("S"));
 
 
}

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
  
	
  x +=hspd;
  y +=vspd;

}