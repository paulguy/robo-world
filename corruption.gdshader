shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture;
uniform sampler2D noise;
uniform float noise_scale = 0.0;

uniform float max_noise_offset = 10.0;
uniform float max_noise_dimming = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float noise_val = texture(noise, UV).r;
	COLOR = texture(screen, vec2(UV.x + (texture(noise, vec2(0.0, UV.y)).r / float(textureSize(screen, 0).x) * (noise_scale * max_noise_offset)), UV.y)) -
			(vec4(noise_val, noise_val, noise_val, 0.0) * (noise_scale * max_noise_dimming));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
