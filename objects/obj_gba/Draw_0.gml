draw_self();

draw_text(x - 20,y,x);
draw_text(x - 20,y- 20,y);

if(state = GBA_STATE.OPEN || state = GBA_STATE.CORRECT )
{
draw_set_valign(1);
draw_set_halign(1);
draw_set_font(fnt_gba);	
draw_set_colour(c_gray);	
	
	draw_text_transformed(x+ 202,y + 126,"HP:"+string(ship.hp),3.3,3.3,0); 

draw_set_colour(-1);	
draw_set_font(-1);	
draw_set_valign(1);
draw_set_halign(1);

}



