shader_type canvas_item;

uniform float outline_width : hint_range(0.0, 40.0) = 1.0;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool use_8way_kernel = false;
uniform bool normalize_outline = false;

void fragment() {
	vec4 col = texture(TEXTURE, UV, 0);
	vec2 ps = TEXTURE_PIXEL_SIZE * outline_width;
	float a;
	float maxa = col.a;
	float mina = col.a;
	
	for(float y = -1.0; y <= 1.0; y++) {
		for(float x = -1.0; x <= 1.0; x++) {
			if(vec2(x,y) == vec2(0.0)) continue;
			if(!use_8way_kernel){
				if(x != 0.0 && y != 0.0) continue;
			}
			
			vec2 displacement;
			if(normalize_outline) displacement = normalize(vec2(x,y))*ps;
			else displacement = vec2(x,y)*ps;
			
			a = texture(TEXTURE, UV + displacement).a;
			maxa = max(a, maxa);
			mina = min(a, mina);
		}
	}
	
	if(col.a == 0.0){
		COLOR = mix(col, outline_color, maxa-mina);
	} else {
		COLOR = col;
	}
}