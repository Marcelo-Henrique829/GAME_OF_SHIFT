switch(state)
{
	case ENEMY_BASE_STATES.FOLLOW : move_to_ship(); break;
	case ENEMY_BASE_STATES.EXPLODE : explode(); break;
}


