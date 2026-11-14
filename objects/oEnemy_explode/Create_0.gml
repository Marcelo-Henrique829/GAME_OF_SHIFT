spd = 4.6;
hspd = 0;

timer_divide = choose(170,200,250);
wreck = oWreckage;
s_shot = obj_shot; 

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
	
image_angle += 4;
var _timer100 = timer_divide / 100
image_speed  = lerp(image_speed,30,_timer100);
x += hspd;

	if(place_meeting(x,y,s_shot))
	 {
		timer_divide = 0;
	 }

}

divide = function()
{
	timer_divide--;	
	var _spd = 3.4
	if(timer_divide <= 0)
	 {
		for(var i = 0; i <= 7;i++)
		 {			 
			var _wre = instance_create_layer(x,y,"enemys",wreck);
			_wre.hspeed = lengthdir_x(_spd, 45*(i));
			_wre.vspeed = lengthdir_y(_spd,-45*(i));
		 }
		instance_destroy();
	 }
}

//Mn, esse inimigo aparece na room e se tu atirar nele, ele explode
//Daí tem que esperar ele sair, ou atira nele tbm, fds