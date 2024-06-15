shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec3 color : source_color = vec3(1.0);
uniform bool cull;
uniform sampler2D albedo : hint_default_white, source_color;
uniform sampler2D noise : hint_default_black;
uniform sampler2D dither : hint_default_black;
uniform float view_radius : hint_range(0.0, 1.0, 0.01);
uniform float noise_scale;

const float texelSize = 1.0/4.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 world_position = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float noiseAmount = texture(noise, world_position.xz*noise_scale).r * 0.2;
	float center_dist = distance(world_position, vec3(0,0,0));
	float alpha = smoothstep(view_radius + noiseAmount + 0.2, view_radius + noiseAmount, center_dist);
	float ditherValue = texture(dither, SCREEN_UV*VIEWPORT_SIZE*texelSize).r;
	if (alpha < ditherValue && cull) {
		discard;
	}
	ALBEDO = color*texture(albedo, UV).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
