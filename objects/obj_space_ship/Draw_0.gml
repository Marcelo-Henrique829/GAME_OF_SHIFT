draw_self();

draw_text(x,y + 40,hp);
draw_text(20,20,instance_number(all));


if(state == SHIP_STATE.DEFEAT ) exit;

draw_sprite(mask_index,0,x,y);