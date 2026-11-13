spd = 4.6;
hspd = 0;

timer_divide = 100;
wreck = oWreckage;

goto_room = function()
{ 		
	if(x < 0)
	 {
	//	direction += 5
		hspd = spd 
	 }
	if(x > room_width)
	 {
	//	image_angle += 5
		hspd = -spd 
	 } 
	
image_angle+=4
	
x += hspd;
}

divide = function()
{
	timer_divide--;	
	if(timer_divide <= 0)
	 {
		for(var i = 0; i <= 7;i++)
		 {			 
			var _wre = instance_create_layer(x,y,"enemys",wreck);
			_wre.hspeed = lengthdir_x(10, 45*(i));
			_wre.vspeed = lengthdir_y(10,-45*(i));
		 }
		instance_destroy();
	 }
}

//Mn, esse inimigo aparece na room e se tu atirar nele, ele explode
//Daí tem que esperar ele sair, ou atira nele tbm, fds