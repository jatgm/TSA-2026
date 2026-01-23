shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform float vibrance : hint_range(1.0, 2.5) = 1.4;
uniform float brightness : hint_range(1.0, 1.5) = 1.05;
uniform float hue_shift : hint_range(-1.0, 1.0) = 0.05; // Subtle shift for that "Retro" tint

void fragment() {
    vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 col = tex.rgb;

    // 1. Boost Vibrance (Saturates colors without clipping them harshly)
    float luma = dot(col, vec3(0.299, 0.587, 0.114));
    float max_color = max(col.r, max(col.g, col.b));
    col = mix(vec3(luma), col, vibrance);

    // 2. Hue Rotation (Optional) 
    // This gives it that "not quite modern" color grading
    float angle = hue_shift * 3.14159;
    vec3 k = vec3(0.57735);
    float cos_angle = cos(angle);
    col = col * cos_angle + cross(k, col) * sin(angle) + k * dot(k, col) * (1.0 - cos_angle);

    // 3. Brightness & Clean Glow prep
    col *= brightness;

    // 4. Final Color Correction (Keeping it smooth)
    // We use a smooth curve instead of floor() to avoid crushing
    col = pow(col, vec3(0.95)); // Slightly lifts shadows for a "filmic" retro look

    COLOR = vec4(col, tex.a);
}