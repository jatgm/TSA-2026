shader_type canvas_item;

// --- SETTINGS ---
uniform float warp_amount : hint_range(0.0, 1.0) = 0.05;
uniform float saturation : hint_range(0.0, 3.0) = 1.4;
uniform float aberration : hint_range(0.0, 10.0) = 0.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float scanline_count : hint_range(0, 1800) = 240.0;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float brightness_boost : hint_range(0.0, 1.0) = 0.15;

// ** NEW: Controls the fuzziness/static grain **
uniform float noise_amount : hint_range(0.0, 1.0) = 0.05;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

vec2 warp(vec2 uv) {
	vec2 delta = uv - 0.5;
	float delta2 = dot(delta.xy, delta.xy);
	float delta4 = delta2 * delta2;
	float delta_offset = delta4 * warp_amount;
	return uv + delta * delta_offset;
}

// Generates random static based on time
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = warp(SCREEN_UV);
	vec2 centered_uv = uv - 0.5;
	
	// 1. Chromatic Aberration
	float aber_offset = aberration * 0.002; 
	vec2 r_pos = uv - (centered_uv * aber_offset);
	vec2 g_pos = uv;
	vec2 b_pos = uv + (centered_uv * aber_offset);
	
	float r = texture(screen_texture, r_pos).r;
	float g = texture(screen_texture, g_pos).g;
	float b = texture(screen_texture, b_pos).b;
	vec3 color = vec3(r, g, b);
	
	// 2. Scanlines
	float pixels = (uv.y * scanline_count);
	float scanline = sin(pixels * PI * 2.0);
	scanline = (scanline * 0.5 + 0.5) * scanline_opacity;
	color -= scanline;
	
	// 3. Saturation Boost
	float grey = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(vec3(grey), color, saturation);
	
	// 4. Noise / Fuzziness (The "Alive" look)
	// We add TIME to the UV so the static dances around
	float noise = random(uv + vec2(TIME * 10.0, TIME * 5.0));
	color += (noise - 0.5) * noise_amount;
	
	// 5. Vignette
	float val = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
	val = pow(val * 15.0, vignette_intensity);
	color *= val;
	
	// 6. Brightness
	color += brightness_boost;
	
	// 7. Clip Edges
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		color = vec3(0.0);
	}
	
	COLOR = vec4(color, 1.0);
}