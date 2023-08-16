shader_type canvas_item;
render_mode blend_add;

uniform vec4 tgt_color : source_color;

void fragment() {
	COLOR.rgb = tgt_color.rgb;
	COLOR.a = UV.x * texture(TEXTURE, UV).a;
	COLOR.a *= 0.2;
}
