    timer_distroy--;
    if(timer_distroy <= 0)
    {
        instance_destroy();
    }  
    

switch(state)
{
    case ENEY5_STATES.RM_IN : hop_room(); break;
	case ENEY5_STATES.RNG_POSS: rng_poss()  ;break;
	case ENEY5_STATES.IN_POSS: vel_poss_in();break;
	case ENEY5_STATES.P_CAUGHT: p_caught();break;
}