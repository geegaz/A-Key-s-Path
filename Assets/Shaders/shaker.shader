shader_type canvas_item;

const float PI = 3.14159;

uniform float intensity = 50.0;
uniform float scale = 1.0;
uniform float cycle_time = 1.0;

void vertex() {
	VERTEX.y += sin(PI*TIME/(2.0*cycle_time)+PI/2.0)*sin(PI*TIME*intensity)*scale;
}