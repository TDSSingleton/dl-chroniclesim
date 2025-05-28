// Original by @ENDESGA at https://www.shadertoy.com/view/dlKyWw
// splat-field forked from https://www.shadertoy.com/view/clGyWm

shader_type canvas_item;

uniform uint colorMode = 0; 

uniform vec4 color : source_color;
uniform float timescale = 0.2; 
uniform float hScrollSpeedFactor = 1.; 
uniform float vScrollSpeedFactor = 1.;
uniform float entropyFactor = 1.; 
uniform float sharpness = 10.;

uniform vec3 fog_color : source_color;
uniform float mixing_rate_color : hint_range(0.0, 1.0) = 0.5;

uniform float contrast : hint_range(0.0, 5.0) = 1.2;
uniform float conservation_factor : hint_range(0.05, 0.25) = 0.2;
uniform float smoothness : hint_range(0.0, 1.) = 1.;
uniform float color_range_skip : hint_range(0.0, 1.) = .55;

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec3 hash(vec3 p)
{
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)), dot(p, vec3(269.5,183.3,246.1)), dot(p, vec3(113.5, 271.9, 124.6)));
    p = fract(sin(p) * 43758.5453123);
    return p;
}

vec3 hsv2rgb(vec3 _c) {
    _c.x = fract(_c.x + 0.1); // Add 0.1 to skip the first part of the hue spectrum
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - 1.4 * _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0., 1.), _c.y);
}

float shard_noise(in vec3 p, in float _sharpness) {
    vec3 ip = floor(p);
    vec3 fp = fract(p);

    float v = 0., t = 0.;
    for (int z = -1; z <= 1; z++) {
        for (int y = -1; y <= 1; y++) {
            for (int x = -1; x <= 1; x++) {
                vec3 o = vec3(float(x), float(y), float(z));
                vec3 io = ip + o;
                vec3 h = hash(io);
                vec3 r = fp - (o + h);

                float w = exp2(-TAU*dot(r, r));
                // tanh deconstruction and optimization by @Xor
                float s = _sharpness * dot(r, hash(io + vec3(11, 31, 47)) - 0.5);
                v += w * s*inversesqrt(1.0+s*s);
                t += w;
            }
        }
    }
    return ((v / t) * .5) + .5;
}

vec4 mainImage( in vec2 _uv )
{
    vec3 uv = vec3(_uv.x + TIME*timescale*hScrollSpeedFactor, _uv.y + TIME*timescale*vScrollSpeedFactor, TIME*timescale * .5 * entropyFactor);

    vec4 C = vec4(vec3(
            (shard_noise(128.0*uv,sharpness) * .03125) +
            (shard_noise(32.0*uv,sharpness) * .0625) +
            (shard_noise(16.0*uv,sharpness) * .125) +
            (shard_noise(8.0*uv,sharpness) * .25) +
            (shard_noise(4.0*uv,sharpness) * .5)
        ),1.);
    
    return C;
}

void fragment() 
{
    vec4 noise = mainImage(UV);
    vec4 texture_color = texture(TEXTURE, UV);
    
    switch (colorMode)
    {
        case 0:
            
            COLOR = vec4(noise.rgb, texture_color.a);
            break;
        case 1:
            
            COLOR = vec4(color.r - noise.r, color.g - noise.g, color.b - noise.b, texture_color.a);
            break;
        case 2:
            
            COLOR = vec4(color.r + noise.r, color.g + noise.g, color.b + noise.b, noise.a);
            break;
        case 3:
            noise.rgb = (noise.rgb - 0.5) * contrast + 0.5;
            vec4 intermittent = vec4(noise.rgb, texture_color.a);
            COLOR = mix(intermittent, vec4(fog_color, texture_color.a), mixing_rate_color);
            break;
        case 5:
            noise.rgb = (noise.rgb - 0.5) * contrast + 0.5;
            float brightness = dot(noise.rgb, vec3(0.2126, 0.7152, 0.0722));
            vec4 brightness_spots;
            if (brightness < (1. - conservation_factor * 2.)) {
                
                float diagonal_pos = mix(UV.x, UV.y, -0.5) * .4 + TIME * timescale;
                
                float hue = (cos(diagonal_pos * 6.28318) * 0.5 + 0.5) * color_range_skip + (1.-color_range_skip); // Excludes red
                vec4 intermittent = mix(noise,vec4(hsv2rgb(vec3(hue, 1., 1.0)), 1),mixing_rate_color);
                brightness_spots = vec4(intermittent.rgb, texture_color.a);
            } else {
                brightness_spots = vec4(noise.rgb, texture_color.a);
            }
            vec4 texA = screen(brightness_spots, noise);
            COLOR = vec4(texA.rgb, texture_color.a);
            break;
        default:
            COLOR = noise;
            break;
    }
}
