shader_type canvas_item;

uniform float grass_density;
uniform float blade_thickness : hint_range(0., 2.);
varying vec2 pos;

void vertex() {
	pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	VERTEX.x += sin(TIME + sin(pos.x * 32.)) * (1. - UV.y); // X wind sway
	VERTEX.y += cos(pos.x);
}

void fragment() {
	COLOR.a = step(1. - blade_thickness, sin(pos.x*grass_density));
	COLOR.a *= step(1.-sin(floor(pos.x)) -0.2, UV.y * grass_density);
	COLOR.rgb = vec3(0., 1., 0.);
}
