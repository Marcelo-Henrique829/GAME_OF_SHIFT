depth = -y;
if(instance_exists(obj_player_topdown))
{

        if(obj_player_topdown.depth>= depth) image_alpha = lerp(image_alpha,0.8,0.1)
        else image_alpha = lerp(image_alpha,1,0.1)

}
