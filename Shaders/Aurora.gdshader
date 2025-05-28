shader_type canvas_item;

// Define colors for each corner (with alpha channel)
uniform vec4 color_top_left : source_color = vec4(1.0, 0.0, 0.0, 1.0);    // Red
uniform vec4 color_top_right : source_color = vec4(0.0, 1.0, 0.0, 1.0);   // Green
uniform vec4 color_bottom_left : source_color = vec4(0.0, 0.0, 1.0, 1.0); // Blue
uniform vec4 color_bottom_right : source_color = vec4(1.0, 1.0, 0.0, 1.0);// Yellow
uniform float interpolation_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float luminance_halvingrange : hint_range(0.0, 1.0) = 0.5;

// Speed of color transition
uniform float color_change_speed : hint_range(0.0, 5.0) = 0.5;

vec3 hsv2rgb(vec3 _c) {
    _c.x = fract(_c.x); // Add 0.1 to skip the first part of the hue spectrum
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - 1.4 * _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0., 1.), _c.y);
}

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

void fragment() {
    vec2 uv = UV;
    vec4 texture_color = texture(TEXTURE, UV);
    
    
    float time_offset = TIME * color_change_speed;
    float luminance = dot(texture_color.rgb, vec3(0.299, 0.587, 0.114));
    
    vec2 pos = vec2(0.5) - UV;
	vec3 final_color = hsv2rgb(vec3(((atan(pos.y, pos.x) + radians(time_offset*10.)) / 6.28318530718) + 0.5, length(pos) * 2.0, 1.0)) * 0.5;
    if (luminance < luminance_halvingrange)
        final_color *= 0.5;
    
    
    //vec4 finaltex = mix(texture_color, final_color, interpolation_intensity);

    vec4 texA = screen(vec4(final_color, 1),texture_color);
    COLOR = mix(texA*1.2,vec4(final_color, 1),interpolation_intensity);
}

