switch(state)
{		
	case ENEMY4.DOWN   : goto_room(); break;
	case ENEMY4.SEARCH : search();	  break;
	case ENEMY4.SHOT   : shot();      break;
	case ENEMY4.DEATH   : explode();      break;
	
}