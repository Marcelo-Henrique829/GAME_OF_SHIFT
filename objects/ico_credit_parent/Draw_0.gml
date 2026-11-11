//draw_info();

draw_self();

draw_set_font(fnt_shortcut);
draw_set_valign(1);
draw_set_halign(1);

	//nome
	draw_text_ext_transformed(x + 50,y + 50,name_txt,0,0,1.2,1.2,0);
	//descrição
	draw_set_alpha(0.8);
		draw_text_ext_transformed(x,y + 15,desc_txt,0,0,1,1,0);
	draw_set_alpha(-1);


draw_set_valign(-1);
draw_set_halign(-1);
draw_set_font(-1)