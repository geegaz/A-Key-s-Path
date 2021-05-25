shader_type canvas_item;

uniform int h_frames = 1;
uniform int v_frames = 1;
uniform float frame_duration;

void fragment() {
	vec2 frames = vec2(float(h_frames), float(v_frames));
	float frame = floor(mod(TIME, frames.x * frames.y * frame_duration) / frame_duration);
	vec2 offset = vec2(mod(frame, frames.x), floor(frame/frames.x)*frames.y) / frames; //in UV
	COLOR = texture(TEXTURE, UV + offset);
}