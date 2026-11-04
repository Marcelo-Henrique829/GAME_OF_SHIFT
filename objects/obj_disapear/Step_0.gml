image_xscale += disapear_scale_spd
image_yscale += disapear_scale_spd
image_alpha  -= disapear_spd
if(image_alpha<=0) instance_destroy()
if(image_xscale<=0 or image_yscale<=0) instance_destroy()
if(follow and target != noone)
{
	if(instance_exists(target))
	{
		x = target.x
		y = target.y
	}
}