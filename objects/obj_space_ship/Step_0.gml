ship_control();

switch(state)
{
	case SHIP_STATE.FLIP_LEFT  :ship_flip_right();	break;
	case SHIP_STATE.FLIP_RIGHT :ship_flip_left();	break;
}



