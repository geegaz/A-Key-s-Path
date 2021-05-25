shader_type canvas_item;
render_mode unshaded;

// Based on a tutorial by GDQuest
// https://www.youtube.com/watch?v=K9FBpJ2Ypb4
uniform float progress : hint_range(-1., 1.0) = -1.;
uniform float smooth_size : hint_range(0.0, 1.0) = 0.;
uniform sampler2D transition_mask : hint_black;

uniform vec4 color : hint_color;

void fragment()
{
	float value = texture(transition_mask, UV).r;
	float s = sign(progress);
	if(s < 0.) value = 1. - value;
	float alpha = smoothstep(progress*s, progress*s + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	COLOR = vec4(color.rgb, alpha);
}