sprite_index = spr_photocredit_placeholder;

name_txt = "name";

desc_txt = "description";


draw_info = function()
{
draw_self();

draw_set_font(fnt_shortcut);
draw_set_valign(1);
draw_set_halign(1);

	//nome
	draw_text(x,y,name_txt);
	//descrição
	draw_set_alpha(0.8);
		draw_text_ext_transformed(x,y + 15,desc_txt,0,0,1,1,0);
	draw_set_alpha(-1);


draw_set_valign(-1);
draw_set_halign(-1);
draw_set_font(-1)
}