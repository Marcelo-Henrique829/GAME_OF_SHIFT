if(image_angle == 0)
 {
  global.gba_block02 = 1;
 }				
else			
 {				
  global.gba_block02 = 0;
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
