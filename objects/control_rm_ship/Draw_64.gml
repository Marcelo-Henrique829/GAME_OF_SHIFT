var _selected = false;
var _ar_posm = [obj_gba];
if (position_meeting(mouse_x,mouse_y,_ar_posm)) 
 {	
	_selected = true;
 }
var _cursor = _selected ? spr_cursor_selected_ph : spr_cursor_iddle_ph;
draw_sprite_ext(_cursor, 0,
    device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
    1, 1, 0, c_white, 1);