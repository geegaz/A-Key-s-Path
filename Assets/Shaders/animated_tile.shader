shader_type canvas_item;
render_mode unshaded;

uniform sampler2D frames: hint_albedo;
uniform float count;
uniform float duration;
uniform float width;
uniform float startX = 0;

void fragment() {
	float frame = floor(mod(TIME, count * duration) / duration);
	float offset = floor((UV.x - startX) / width);
	COLOR = texture(frames, UV + vec2((mod(offset + frame, count) - offset) * width, 0));
}