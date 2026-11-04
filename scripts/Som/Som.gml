//código teste



function musica(){

sala = room_get_name(room)
sound = noone

rest_Sound_Var = function(){

	quant_priority = 1
	_loop = true 
	quant_gain = 1

}
rest_Sound_Var()

loop_time = function(_sound,_time1,_time2)
{

	audio_sound_loop_start (_sound, _time1 );
	audio_sound_loop_end (_sound, _time2 ); 

}


if (global.pause != 1) and (sala != "rm_menu") and (sala != "rm_intro"){


if (!instance_exists(obj_enemie_fish)) and (!instance_exists(obj_turtle)) sound = "safe";
if (instance_exists(obj_enemie_fish)) sound = "combat";
if (sala = "rm_ABC_4") or (sala = "rm_BC_3") sound = "moio"
if (sala= "rm_tchulu_boss_") and (instance_exists(obj_tchulu_head)) sound = "tchulu";

if (sala = "rm_turtle_boss") and (instance_exists(obj_turtle)) sound = "turtle";

if (sala = "rm_loja_entrada") or (sala = "rm_loja_menu") sound = "encanto"; 

}
else if (global.pause = 1) or (sala = "rm_intro") or (sala = "rm_menu") sound = "pause";



switch (sound){
	
	

	case noone:
	
	audio_stop_sound(global.music)

	break;
	
	
	case "safe":
	
	if (global.music != Snd_Safezone){
	audio_stop_sound(global.music)
	global.music = Snd_Safezone
	rest_Sound_Var()
	
	}
	
	break;

	case "pause":
	
	if (global.music != Snd_Menu){
	audio_stop_sound(global.music)
	global.music = Snd_Menu
	rest_Sound_Var()
	
	}
	break;
	
	
	case "encanto":
	
	if (global.music != Snd_Encanto){
	audio_stop_sound(global.music)
	global.music = Snd_Encanto
	rest_Sound_Var()
	}
	

	
	break;
	
	case "combat":
	
	if (global.music != Snd_battle){
	audio_stop_sound(global.music)
	global.music = Snd_battle
	loop_time(global.music, 11.11, 33.183)  //loop começa no momento 11.11 e termina no momento 33.183
	rest_Sound_Var()
	}
	

	
	break;

	case "turtle":
	
	if (global.music != Snd_Turtle){
	audio_stop_sound(global.music)
	global.music = Snd_Turtle
	loop_time(global.music, 9.23, 59.1171)  //loop começa no momento 9.23 e termina no momento 59.11711
	rest_Sound_Var()
	}
	
	
	break;
	
	case "moio":
	if (global.music != Snd_sus){
	audio_stop_sound(global.music)
	global.music = Snd_sus
	loop_time(global.music, 2.1, 47.64)  //loop começa no momento 2.1 e termina no momento 47.64
	quant_gain = 5 
	} 

	
	break;
	
	case "tchulu":
	if (global.music != Snd_tchulu){
	audio_stop_sound(global.music)
	global.music = Snd_tchulu
	rest_Sound_Var()
	}
	

	
	break;
		

}

var music_player = {

	sound: global.music,
	priority : quant_priority, 
    loop : _loop ,
	gain : quant_gain

	}
	

	if (!audio_is_playing(music_player.sound)){ 
	audio_play_sound_ext(music_player)
	}


}

function sound_effects()
{

	if(!instance_exists(obj_player)) exit; // só roda o código abaixo se o player existir
	
		if (obj_player.hspd != 0 ) or (obj_player.vspd != 0)
		{
			if (!audio_is_playing(Snd_walk_placeholder))
			{
				audio_play_sound(Snd_walk_placeholder,2,true,1,0,1,1)	
			}
		}
		else
		{
			audio_stop_sound(Snd_walk_placeholder)	
		}
		
		/*if(obj_player._i = attack) 
            {
                switch (combo.combo_number)
                {
                	case 0: 
                     
                    break;
                	case 1:
                     punch_create_combo_1()
                     state = P_STATE.COMBO_1
                     break;
                	case 2:
                     punch_create_combo_2() 
                     state = P_STATE.COMBO_2
                    break;
                }
            }*/

}