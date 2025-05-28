shader_type canvas_item;

uniform float interpolation_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float time_speed : hint_range(0.0, 1.0) = 0.5;
uniform float smoothness : hint_range(0.0, 5.0) = 0.5;
uniform float ahead_shine_value : hint_range(1., 10.) = 1.;
uniform float hatch_angle   = 135.0;

uniform float line_size = 0.02; 
uniform float darkness_factor = 1.;

uniform float offset: hint_range(0.0, 360.0, 1.0);
uniform sampler2D shine_texture: repeat_enable;
uniform vec2 repetition;

const float TWO_PI = 6.28318530718;
const float PI_OV_TWO = 1.57079632679;

vec3 hsv2rgb(vec3 _c) {
    _c.x = fract(_c.x + 0.1); 
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - 1.4 * _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0., 1.), _c.y);
}

vec4 soft_light(vec4 base, vec4 blend) {
    vec3 result;
    vec3 blend_rgb = blend.rgb * blend.a; 
    vec3 limit = step(0.5, blend_rgb);
    
    
    result = mix(
        2.0 * base.rgb * blend_rgb + base.rgb * base.rgb * (1.0 - 2.0 * blend_rgb),
        sqrt(base.rgb) * (2.0 * blend_rgb - 1.0) + (2.0 * base.rgb) * (1.0 - blend_rgb),
        limit
    );
    
    
    float out_alpha = base.a + blend.a - base.a * blend.a;
    result = (result * blend.a + base.rgb * (1.0 - blend.a));
    
    return vec4(result, out_alpha);
}

vec4 hard_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

bool is_progressed(vec2 uv, float progress)
{
    float theta = radians(hatch_angle);
    float d1 = abs(sin(theta) - cos(theta));
    float duv = abs(uv.x * sin(theta) - uv.y * cos(theta));
    return duv <= d1 * progress; 
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float time_offset = TIME * time_speed;
    float progress = 0.;
	float reverse_progress = 0.;

    // --- BACKGROUND LINES
    vec2 pos = vec2(0.5) - UV;
	vec3 final_color = hsv2rgb(vec3(((atan(pos.y, pos.x) + radians(time_offset*10.)) / TWO_PI) + 0.5, max(length(pos) * 4.0, 1.), 1.0));
    final_color.rgb += 0.3;
    float brightness_value = clamp(0.,0.5,(sin(time_offset)-0.5));
    
    if (mod(floor(UV.x / line_size), 2.0) == 1.0) {
        if (sin(time_offset) > 0.5)
        {
            color.rgb *= darkness_factor * 1.02 + brightness_value * 0.15;
            color = mix(color, vec4(final_color,1.), sin(time_offset) * 0.2);//clamp(0.2,1,brightness_value)* 0.2); 
        }
        else{
            color.rgb *= darkness_factor * 1.02;
            color = mix(color, vec4(final_color,1.), 0.1);
        }
        //color = soft_light(color, vec4(final_color,1.));
    }
	
	// -- LITTLE SIDE DOTS
	vec3 randomval = vec3(random(UV));
	vec4 randomval_bg = vec4(randomval,1.);
	vec3 randomval2 = vec3(random(UV*1.333));
	vec4 randomval_bg2 = vec4(randomval2,1.);

	if(randomval.r <= 0.99)
	{
		randomval_bg.rgb = vec3(0.);
	}
	if(randomval2.r <= 0.99)
	{
		randomval_bg2.rgb = vec3(0.);
	}
	//randomval_bg += randomval_bg2;
    if(randomval_bg.r >= 0.99 && sin(time_offset*0.5) > 0.)
    {
        color.rgb = color.rgb * (1. + clamp(sin(time_offset*0.5)*0.2,0.,1.2));
        //randomval_bg = vec4(mix(randomval_bg.rgb, final_color.rgb ,0.5),randomval_bg.a);
    }

    if(randomval_bg2.r >= 0.99 && sin(time_offset*0.5) < 0.)
    {
        color.rgb = color.rgb * (1. + abs(sin(time_offset*0.5)*0.2));
        //randomval_bg = vec4(mix(randomval_bg.rgb, final_color.rgb ,0.5),randomval_bg.a);
    }
	
	//randomval_bg.a *= 0.2;
    // -- FOREGROUND LINES

    COLOR = color;
    vec4 shineTex = texture(shine_texture, UV * repetition);
    shineTex.rgb = mix(shineTex.rgb * ahead_shine_value, final_color, 0.9);

    float timed_pi = mod(time_offset, PI);

    if(timed_pi > -0.2 && timed_pi < PI_OV_TWO)
    {
        if(timed_pi > -0.2 && timed_pi < (PI_OV_TWO)) // This means the cosine function is ascending
        {
            progress = clamp(sin(time_offset)+0.2, 0., 1.);
        }
        else
        {
            progress = 1.;
    }

        if(timed_pi > 0. && timed_pi < PI_OV_TWO) // This means the cosine function is ascending
        {
            reverse_progress = 1. - sin(time_offset);
        }
        else
        {
            reverse_progress = 1.;
        }
    }

	if(is_progressed(UV, progress) && is_progressed(vec2(1. - UV.x, 1. - UV.y), reverse_progress))
	{
        shineTex.a *= 2.45;
        if(color.a == 0.)
        {
            COLOR = shineTex;
        }
        else
        {
            COLOR = soft_light(color, shineTex);
        }
	}
}