shader_type canvas_item;

uniform sampler2D flower_noise : repeat_enable;
uniform sampler2D white_noise : repeat_enable;

void fragment() {
	vec3 flower = texture(flower_noise, vec2(1.) - vec2(UV.x * (1. - UV.y), UV.y * UV.y)).rgb;
	vec3 whiten_color = texture(white_noise, UV).rgb;
	vec3 color = mix(flower, whiten_color, 0.2);
	COLOR.rgb = color;
}
