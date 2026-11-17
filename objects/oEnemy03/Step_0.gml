shoot();
damage();
switch(state)
{
	case EN03_STATES.ENTER01 : enter_room01(); break;
	case EN03_STATES.ENTER02 : enter_room02(); break;
	case EN03_STATES.EXPLODE : explode(); break;
}


image_xscale = lerp(image_xscale,1,.1);
image_yscale = lerp(image_xscale,1,.1);