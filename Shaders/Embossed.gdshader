shader_type canvas_item;

// Tweakables:
uniform float fContrast : hint_range(0.0, 5.0) = 1.5;
uniform vec4 color_blend : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float interpolation_intensity : hint_range(0., 1.) = 0.5;


void fragment() {

    vec4 color = vec4(0.5, 0.5, 0.5, 1.0);
    

    vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
    
    color -= texture(TEXTURE, UV - pixel_size) * fContrast;
    color += texture(TEXTURE, UV + pixel_size) * fContrast;

    color.rgb = vec3((color.r + color.g + color.b) * 0.33333);
	color.rgb = mix(color.rgb, color_blend.rgb, interpolation_intensity);

    COLOR = color;
}