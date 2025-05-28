shader_type canvas_item;

uniform vec4 color_blend : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float interpolation_intensity : hint_range(0., 1.) = 0.5;
uniform float contrast : hint_range(0., 2.) = 1.;
uniform float additional_brightness : hint_range(0., 2.) = 1.;


void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    texture_color.rgb = (texture_color.rgb - 0.5) * contrast + 0.5;
    float luminance = dot(texture_color.rgb, vec3(0.299, 0.587, 0.114));
    
    vec3 grayed = mix(texture_color.rgb, vec3(luminance, luminance, luminance) * color_blend.rgb * additional_brightness, interpolation_intensity);
	
    COLOR = vec4(grayed, texture_color.a);
}