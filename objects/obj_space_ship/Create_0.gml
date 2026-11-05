acel = .09;
hspd = 0;
vspd = 0;
m_vspd  = 5;
m_hspd  = 5;


ipts = function()
{

 k_left  =		keyboard_check(ord("A")) || keyboard_check(vk_left);
 k_right =		keyboard_check(ord("D")) || keyboard_check(vk_right);
 k_up    =		keyboard_check(ord("W")) || keyboard_check(vk_up);	
 k_down  =		keyboard_check(ord("S")) || keyboard_check(vk_down);
 
 
 
}

ship_control = function()
{
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