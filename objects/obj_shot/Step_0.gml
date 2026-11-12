	if((x >= room_width) || (x <= 0))
			 {
		 	    instance_destroy();
		    	//_timer_destroy = 180;
		     }
	
if(place_meeting(x,y,enemy_ar)){
	instance_destroy(self);
}