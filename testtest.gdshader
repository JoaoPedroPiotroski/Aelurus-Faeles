shader_type canvas_item;


uniform sampler2D gradient;
uniform float max_iter = 256;
uniform float scale;
uniform vec2 offset;
uniform float color_div;
uniform sampler2D n1;
uniform sampler2D n2;

void fragment() {
	
	float n = 1.;
	vec2 c = (UV )/ 2. * 4.0  ;
	c -= vec2(2.0);
	c*= scale;
	c+= offset;
	//c = UV / 2. * 4.0 ;
	float iter = 0.0;
	vec2 z = vec2(0.0);
	COLOR.rgb = vec3(0.) * (0.8);
	while (iter < max_iter) {
		iter += 1.0;
		
		if (length(z) > 2.0) {
			COLOR = texture(gradient, vec2(mod(iter , color_div) / color_div));
			break;
		}
		z = vec2((z.x*z.x - z.y*z.y), (z.x*z.y + z.y*z.x)) + c;
	}
}
