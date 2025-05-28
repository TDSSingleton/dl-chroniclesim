shader_type canvas_item;

// Define colors for each corner (with alpha channel)
uniform float interpolation_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float color_multiplier : hint_range(0.0, 2.0) = 0.5;

// Speed of color transition
uniform float speed : hint_range(0.0, 5.0) = 0.5;

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

vec4 lighten(vec4 base, vec4 blend){
	return max(base, blend);
}

vec4 color_burn(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) / blend;
}

vec4 linear_burn (vec4 base, vec4 blend)
{
	return base + blend - 1.0;
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.1, 0.95), c.y);
}

void fragment() {
    // Get original texture color
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Calculate brightness (0-1)
    float brightness = dot(texture_color.rgb, vec3(0.2126, 0.7152, 0.0722));
    
    // Only apply rainbow to darker areas (adjust 0.9 threshold as needed)
    if (brightness < 0.75) {
        // Rainbow generation
        float hue = fract(TIME * 0.1 * speed);
        vec3 rainbow_color = hsv2rgb(vec3(hue, 1.0, 1.0));
        vec4 full_rainbow = vec4(rainbow_color, 1.0);
        
        // Apply your blending modes only to dark areas
        vec4 texA = screen(texture_color, full_rainbow * color_multiplier);
        vec4 texB = color_burn(texA, full_rainbow * color_multiplier);
        vec4 texC = mix(texture_color, texB, interpolation_intensity);
		COLOR = texC;
    }
    
    // Bright areas remain completely unchanged
    
}

