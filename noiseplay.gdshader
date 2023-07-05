shader_type canvas_item;

uniform sampler2D noisetex1 : repeat_enable;
uniform sampler2D noisetex2 : repeat_enable;
uniform sampler2D uvnoisetex : repeat_enable;
uniform sampler2D blendnoisetex : repeat_enable;
uniform sampler2D blend2noisetex : repeat_enable;
uniform sampler2D colornoisetex : repeat_enable;
uniform sampler2D color2noisetex : repeat_enable;
uniform vec3 black_shore_color : source_color;
uniform vec3 black_deep_color : source_color;
uniform float black_threshold;
uniform float white_threshold;
uniform vec3 white_shore_color : source_color;
uniform vec3 white_deep_color : source_color;
uniform float noise1scrollspeed;
uniform float noise2scrollspeed;
uniform float uvnoisescrollspeed;
uniform float blendnoisescrollspeed;
uniform float blend2noisescrollspeed;
uniform float blend_time_mul;
uniform float color_blend_time_mul;

void fragment() {
	vec3 uv_noise1 = texture(uvnoisetex, UV + (vec2(uvnoisescrollspeed) * TIME)).rgb;
	vec3 uv_noise2 = texture(uvnoisetex, UV + (vec2(-uvnoisescrollspeed) * TIME)).rgb;
	vec3 uv_noise = mix(uv_noise1, uv_noise2, 0.5);
	vec2 distorted_uv = UV + (uv_noise.gb*0.2);
	vec3 blend1_noise = texture(blendnoisetex, distorted_uv + (vec2(blendnoisescrollspeed) * TIME)).rgb;
	vec3 blend2_noise = texture(blend2noisetex, distorted_uv + (vec2(-blend2noisescrollspeed) * TIME)).rgb;
	vec3 blend_noise = mix(blend1_noise, blend2_noise, 0.5);
	vec3 noise1 = texture(noisetex1, (distorted_uv + (vec2(noise1scrollspeed) * TIME))).rgb;
	vec3 noise2 = texture(noisetex2, (distorted_uv + (vec2(noise2scrollspeed) * TIME))).rgb;
	vec3 blended_noise = mix(noise1, noise2, blend_noise.r * (sin(TIME * blend_time_mul + 1.) / 2.));
	vec3 color1_noise = texture(colornoisetex, distorted_uv * blended_noise.gb).rgb;
	vec3 color2_noise = texture(color2noisetex, distorted_uv * blended_noise.gb).rgb;
	vec3 color_noise = mix(color1_noise, color2_noise, (sin(TIME * color_blend_time_mul) + 1.) / 2.);
	vec3 color = color_noise * blended_noise;
	COLOR.rgb = color;
	float luminance = (COLOR.r + COLOR.g + COLOR.b) / 3.;
	if (luminance < black_threshold){
		COLOR.rgb = mix(
			black_shore_color,
			black_deep_color,
			smoothstep(0., black_threshold, luminance)
		);
	}
	if (luminance > white_threshold){
		COLOR.rgb = mix(
			white_shore_color,
			white_deep_color,
			smoothstep(white_threshold, .7, luminance)
		);
	}

}
