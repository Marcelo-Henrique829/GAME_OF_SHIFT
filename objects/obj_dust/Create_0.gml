image_blend = c_white;

image_xscale = random_range(1.4,3);
image_yscale = image_xscale;

dir = random(359);
spd = random_range(5,22);
dim = random_range(image_xscale / 10, image_xscale / 5);


effect = function()
{
	image_xscale -= dim;
	image_yscale = image_xscale;
	
	x += lengthdir_x(spd,dir);
	y += lengthdir_y(spd,dir);

	image_alpha -= random_range(.01,.1);
	
	if(image_xscale < 0 )
	 {
		instance_destroy();
	 }

}