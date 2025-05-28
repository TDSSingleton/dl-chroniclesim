shader_type canvas_item;
render_mode unshaded;

//uniform float intensity = 1.0;
//uniform float smoothness = 1.0;

uniform vec3 colorA : source_color = vec3(1.0,1.0,1.0);
uniform vec3 colorB : source_color = vec3(1.0,1.0,1.0);
uniform float beam_width = -0.02;
uniform float beam_pos = 0.05;

void fragment()
{
    float texture_alpha = texture(TEXTURE, UV).a;
    if (texture_alpha > 0.0)
    {
        
        float gradient_value = beam_pos - abs( beam_pos/2.0 - UV.y) / beam_width; // Horizontal beam
        gradient_value = clamp(gradient_value, 0.0, 1.0); // Ensure it stays within bounds
        vec3 color = mix(colorA, colorB, gradient_value); // Blend

        COLOR = vec4(color.r, color.g, color.b, texture_alpha);
    }
}