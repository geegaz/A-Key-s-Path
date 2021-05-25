shader_type canvas_item;

uniform vec4 flash_color : hint_color = vec4(1.0,1.0,1.0, 1.0);
uniform float flash_amount : hint_range(0.0,1.0) = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, vec4(flash_color.rgb, color.a), flash_amount);
}