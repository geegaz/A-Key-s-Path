shader_type canvas_item;

uniform float scale : hint_range(0.001, 2.0) = 0.2;

void vertex() {
	VERTEX.x += sin(TIME)*(sin(TIME)+1.5) * (VERTEX.y - 48.0) * scale;
}