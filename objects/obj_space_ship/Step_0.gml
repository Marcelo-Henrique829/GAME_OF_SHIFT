if(state != SHIP_STATE.DEFEAT || state != SHIP_STATE.ENTER )
{
	ship_control();
}

switch(state)
{
	case SHIP_STATE.ENTER      :ship_enter();	    break;
	case SHIP_STATE.FLIP_LEFT  :ship_flip_right();	break;
	case SHIP_STATE.FLIP_RIGHT :ship_flip_left();	break;
	case SHIP_STATE.DEFEAT	   :ship_defeat();	    break;
}