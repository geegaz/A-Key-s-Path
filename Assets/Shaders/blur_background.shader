shader_type canvas_item;
render_mode unshaded;

uniform float blur_amount : hint_range(0, 5) = 2.;
uniform float mix_amount : hint_range(0, 1) = 0.5;

void fragment() {
	vec4 screen_col = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
	vec4 col = vec4(0.,0.,0.,1.);
	COLOR = mix(screen_col, col, mix_amount);
}