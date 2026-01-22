shader_type canvas_item;

// Allows you to control the strength in the Inspector
uniform float scanline_count : hint_range(0, 1800) = 50.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float warp_amount : hint_range(0.0, 5.0) = 0.2; // Curvature
uniform bool clip_warp = false; // Make edges black
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float brightness_boost : hint_range(0.0, 1.0) = 0.1;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float noise_amount : hint_range(0.0, 1.0) = 0.05;


// Curves the UV coordinates to look like a glass screen
vec2 warp(vec2 uv) {
	vec2 delta = uv - 0.5;
	float delta2 = dot(delta.xy, delta.xy);
	float delta4 = delta2 * delta2;
	float delta_offset = delta4 * warp_amount;
	return uv + delta * delta_offset;
}

// Draw the scanlines
float scanline_pattern(vec2 uv) {
	float pixels = (uv.y * scanline_count);
	float scanline = sin(pixels * PI * 2.0);
	return (scanline * 0.5 + 0.5) * scanline_opacity;
}

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	// 1. Curve the screen
	vec2 uv = warp(SCREEN_UV);
	
	// 2. Sample the game screen color
	vec3 color = texture(screen_texture, uv).rgb;
	
	// 3. Apply Scanlines (Darken every other line)
	color -= scanline_pattern(uv);
	
	// 4. Add Vignette (Dark borders)
	float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
	vignette = pow(vignette * 15.0, vignette_intensity);
	color *= vignette;
	
	// 5. Brightness Boost (CRTs are glowing, so we boost brights)
	color += brightness_boost;

	// 6. Black out pixels outside the "TV curve"
	if (clip_warp) {
		if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
			color = vec3(0.0, 0.0, 0.0);
		}
	}
	
	float noise = random(UV + vec2(TIME, 0.0)); // TIME makes it dance
	color += (noise - 0.5) * noise_amount;
	
	COLOR = vec4(color, 1.0);
}