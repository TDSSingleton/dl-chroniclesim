shader_type canvas_item;
render_mode unshaded;

uniform float intensity = 1.0;
uniform float repeat_count = 4.0; // How many times the gradient repeats
uniform bool mirror_gradient = true; // If true, mirrors the gradient for a beam-like effect

uniform bool x;
uniform float r_horizontal;
uniform float g_horizontal;
uniform float b_horizontal;

uniform bool y;
uniform float r_vertical;
uniform float g_vertical;
uniform float b_vertical;

void fragment()
{
    vec4 original_color = texture(TEXTURE, UV);
    float texture_alpha = original_color.a;

    if (texture_alpha > 0.0)
    {
        vec4 gradient_color = original_color;
        float gradient_pos;

        // Apply repeating pattern
        if (x)
        {
            gradient_pos = UV.x * repeat_count;
            if (mirror_gradient)
                gradient_pos = abs(fract(gradient_pos) * 2.0 - 1.0); // Mirrored sawtooth
            else
                gradient_pos = fract(gradient_pos); // Simple repeating gradient
            
            gradient_color.rgb = vec3(
                gradient_pos * r_horizontal * intensity,
                gradient_pos * g_horizontal * intensity,
                gradient_pos * b_horizontal * intensity
            );
        }
        else if (y)
        {
            gradient_pos = UV.y * repeat_count;
            if (mirror_gradient)
                gradient_pos = abs(fract(gradient_pos) * 2.0 - 1.0); // Mirrored sawtooth
            else
                gradient_pos = fract(gradient_pos); // Simple repeating gradient
            
            gradient_color.rgb = vec3(
                gradient_pos * r_vertical * intensity,
                gradient_pos * g_vertical * intensity,
                gradient_pos * b_vertical * intensity
            );
        }

        COLOR = gradient_color;
        COLOR.a = texture_alpha;
    }
    else
    {
        COLOR = original_color;
    }
}