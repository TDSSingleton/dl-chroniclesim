shader_type canvas_item;


uniform float time_speed : hint_range(0.0, 1.0) = 0.5;
uniform float breadth : hint_range(0.0, 1.0) = 0.5;
const float PI_OV_TWO = 1.57079632679;
const float THREEPI_OV_TWO = 4.71238898038;

void fragment() {
	// Called for every pixel the material is visible on.

	vec4 color = texture(TEXTURE, UV);
	float time_offset = TIME * time_speed;
	float timed_pi = mod(time_offset, 2. * PI);
	if((abs(timed_pi) > 0.0015 && abs(timed_pi) < PI_OV_TWO - 0.0015) || (abs(timed_pi) > PI && abs(timed_pi) < THREEPI_OV_TWO - 0.0015)) // This means the sine function is ascending
        {
			float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
			if (clamp(abs(sin(time_offset)) + breadth,0.,1.) > 1. - luminance && abs(sin(time_offset)) - breadth < 1. - luminance)
            {
				COLOR.rgb = vec3(1., 1., 1.);
			}
        }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
