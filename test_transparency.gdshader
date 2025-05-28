shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    vec4 parent_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask_texture, UV);
    
    COLOR = vec4(parent_color.rgb, parent_color.a * mask_color.a);
}