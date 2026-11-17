var _plus =  0.06;
image_alpha+=_plus;
image_alpha = clamp(image_alpha,0,1);

if(image_angle == 180)
 {
	global.gba_block03 = 1;
 }
else
 {
	global.gba_block03 = 0;
 }

if(position_meeting(mouse_x,mouse_y,self))
{
	if(mouse_check_button_pressed(mb_left))
	 {
		image_angle+=90;
	 }
 
}

if(image_angle >= 360)
 {
	 image_angle = 0;
 }
