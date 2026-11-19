
switch(state)
{
	case GBA_STATE.CLOSE    : gba_close();   break;
	case GBA_STATE.OPEN     : gba_open();    break;
	case GBA_STATE.OPENING  : gba_opening(); break;
	case GBA_STATE.CORRECT  : gba_correct(); break;	
}

