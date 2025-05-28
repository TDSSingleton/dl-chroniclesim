shader_type canvas_item;

uniform vec4 color_top_left : source_color = vec4(1.0, 0.0, 0.0, 1.0);    // Red
uniform vec4 color_top_right : source_color = vec4(0.0, 1.0, 0.0, 1.0);   // Green
uniform vec4 color_bottom_left : source_color = vec4(0.0, 0.0, 1.0, 1.0); // Blue
uniform vec4 color_bottom_right : source_color = vec4(1.0, 1.0, 0.0, 1.0);// Yellow
uniform float interpolation_intensity : hint_range(0.0, 1.0) = 0.5;

uniform float color_change_speed : hint_range(0.0, 5.0) = 0.5;

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
    

    vec4 tl = color_top_left * (0.8 + 0.2 * sin(time_offset));
    vec4 tr = color_top_right * (0.8 + 0.2 * sin(time_offset + 1.047)); // + π/3
    vec4 bl = color_bottom_left * (0.8 + 0.2 * sin(time_offset + 2.094)); // + 2π/3
    vec4 br = color_bottom_right * (0.8 + 0.2 * sin(time_offset + 3.141)); // + π
    
    float brightness = dot(texture_color.rgb, vec3(0.2126, 0.7152, 0.0722));
    
    if (brightness > 0.55 && brightness < 0.95)
    {
        vec4 color_top = mix(tl, tr, uv.x);
        vec4 color_bottom = mix(bl, br, uv.x);
        vec4 final_color = mix(color_top, color_bottom, uv.y);
        final_color.a = 1.0;
        
        //vec4 finaltex = mix(texture_color, final_color, interpolation_intensity);

        vec4 texA = screen(final_color,texture_color);
        vec4 texB = screen(texA,texture_color);
        vec4 texC = color_burn(texB,final_color);
        COLOR = mix(texC, texture_color, interpolation_intensity);
    }
    
}

