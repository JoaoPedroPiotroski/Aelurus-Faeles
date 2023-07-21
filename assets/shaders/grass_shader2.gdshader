shader_type canvas_item;

global uniform vec2 player_position;
global uniform vec2 player_velocity;
uniform vec4 base_color : source_color;
uniform vec4 shadow_color : source_color;
uniform sampler2D character_distance_falloff_curve : filter_nearest;
uniform sampler2D color_noise : filter_nearest, repeat_enable;
uniform sampler2D character_vel_curve;
uniform float shadow_mix;
uniform float player_dist_cutoff = 128;
varying float falloff_curve;
varying vec2 pos;
uniform float character_push_strength = 1.0;

void vertex(){
	//VERTEX.x += sin(TIME) / (exp(VERTEX.y));
	//VERTEX.x += sin(TIME) * (1.-VERTEX.y);
	pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	
	vec2 dir_to_player = player_position.xy - pos.xy;
	float dist_to_player = length(dir_to_player);
	float falloff = 1.0 - smoothstep(0.0, 1.0, dist_to_player/player_dist_cutoff);
	dir_to_player = normalize(dir_to_player);
	falloff_curve = texture(character_distance_falloff_curve, vec2(falloff) * (texture(character_vel_curve, abs(vec2(length(player_velocity))) / vec2(80.)).x)  * vec2(1., float(dir_to_player.y < 0.))).x ;
	VERTEX.x += sin(TIME *  (1.-falloff_curve) * 4.0 * cos(pos.x)) * pow((1.0 - UV.y), 2) * 2.0 ;
	VERTEX.x += sin(pos.x + UV.x) * 2.0;
	VERTEX.x += -dir_to_player.x * falloff_curve * character_push_strength ;
	VERTEX.y *= 1.0 - falloff_curve * 0.7;
	VERTEX.y += falloff_curve * 3.;
	VERTEX.x = floor(VERTEX.x);
	VERTEX.y = floor(VERTEX.y);
	//VERTEX.x *= UV.y ;
	//VERTEX.y +=  ( dir_to_player.y * falloff_curve * character_push_strength );
}

void fragment() {
	vec2 uv = UV;
	vec2 d_uv = UV; //floor(UV * vec2(320., 180.)) / vec2(320., 180.);//vec2(UV.x + UV.y, UV.y);
	vec4 color = texture(TEXTURE, d_uv);
	//COLOR.rgb *= texture(color_noise, 0.05 * mod(pos, vec2(1.0 ))).rgb;
	COLOR.a *= color.a * (1.0 - falloff_curve);
	//COLOR.rgb = vec3(sin(pos.x), sin(pos.y), 1.0);

}
