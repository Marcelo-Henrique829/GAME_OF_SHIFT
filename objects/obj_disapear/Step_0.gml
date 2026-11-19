// Altera o tamanho sem perder o sinal usado para espelhar o sprite.
var _scale_x = abs(image_xscale) + disapear_scale_spd;
var _scale_y = abs(image_yscale) + disapear_scale_spd;
image_alpha -= disapear_spd;
if (image_alpha <= 0 || _scale_x <= 0 || _scale_y <= 0
    || image_xscale == 0 || image_yscale == 0)
{
    instance_destroy();
    exit;
}
image_xscale = sign(image_xscale) * _scale_x;
image_yscale = sign(image_yscale) * _scale_y;
if(follow and target != noone)
{
	if(instance_exists(target))
	{
		x = target.x
		y = target.y
	}
}
