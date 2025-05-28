shader_type canvas_item;

uniform float interpolation_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float time_speed : hint_range(0.0, 1.0) = 0.5;
uniform float speed_mitigation : hint_range(0.0, 1.0) = 0.5;
uniform float smoothness : hint_range(0.0, 5.0) = 0.5;

uniform float line_size = 0.02; // Height of each line (0-1 range)
uniform float darkness_factor = 1.;

uniform float offset: hint_range(0.0, 360.0, 1.0);

const float TWO_PI = 6.28318530718;

vec3 hsv2rgb(vec3 _c) {
    _c.x = fract(_c.x + 0.1); 
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - 1.4 * _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0., 1.), _c.y);
}

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

vec4 hard_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float time_offset = TIME * time_speed;

    // --- BACKGROUND LINES
    vec2 pos = vec2(0.5) - UV;
	vec3 final_color = hsv2rgb(vec3(((atan(pos.y, pos.x) + radians(time_offset*10.)) / TWO_PI) + 0.5, length(pos) * 2.0, 1.0));
    float brightness_value = clamp(0.,0.5,(sin(time_offset)-0.5));

    if (mod(floor((UV.y + time_offset * speed_mitigation)  / line_size), 2.0) == 1.0) {

            color.rgb *= darkness_factor * 1.02;
            if (color.a == 0.)
                {
                    color = vec4(0.,0.,0.,0.05);
                }
            //color = mix(color, vec4(final_color,1.), sin(time_offset) * 0.2);//clamp(0.2,1,brightness_value)* 0.2); 
    }
	
	//randomval_bg.a *= 0.2;
    // -- FOREGROUND LINES

    COLOR = color;
}