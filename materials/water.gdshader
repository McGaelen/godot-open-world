shader_type spatial;

render_mode specular_toon;

uniform sampler2D noise;
uniform sampler2D normalmap;
uniform float height_scale = 0.5;

varying vec2 tex_position;

float height(vec2 position, float time) {
	vec2 offset = 0.01 * cos(position + time);
	return texture(noise, (position / 10.0) - offset).x;
}

void vertex() {
	vec2 pos = VERTEX.xz;
	float h = height(VERTEX.xz, TIME);
	VERTEX.y = h;
	NORMAL = normalize(
		vec3(
			h - height(pos + vec2(0.1, 0.0), TIME),
			0.1, 
			h - height(pos + vec2(0.0, 0.1), TIME)
		)
	);
	
	tex_position = VERTEX.xz / 2.0 + 0.0;
}

void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
	ALBEDO = vec3(0.01, 0.03, 0.05) + (0.1 * fresnel);
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	RIM = 0.2;
}


