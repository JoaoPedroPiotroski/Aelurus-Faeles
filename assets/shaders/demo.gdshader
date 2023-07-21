shader_type canvas_item;

void fragment() {
	COLOR.rgb = vec3(1., 1., 0.) - vec3(SCREEN_UV.x, SCREEN_UV.y, 0.0);
	COLOR.a = 1.0;
}
