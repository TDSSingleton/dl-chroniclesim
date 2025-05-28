shader_type canvas_item;
uniform float contrast : hint_range(0., 2.) = 1.;

void fragment() {
	vec3 main_texture = texture(TEXTURE, UV).rgb;
	//main_texture = (main_texture - 0.5) * contrast + 0.5;
	float luminance = dot(main_texture.rgb, vec3(0.299, 0.587, 0.114));
	COLOR = vec4(main_texture * contrast, luminance * main_texture.r);
	// Called for every pixel the material is visible on.
}

