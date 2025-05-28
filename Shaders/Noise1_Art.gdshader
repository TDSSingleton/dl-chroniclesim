shader_type canvas_item;


uniform float strength : hint_range(-0.05, 0.05) = 0.01;
uniform float hyperstrength : hint_range(0., 5.) = 2.;
uniform float time_mult : hint_range(0., 5.) = 1.;

uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);

void fragment() {
	
	vec2 uv_r = UV + (r_displacement * strength);
	vec2 uv_g = UV + (g_displacement * strength);
	vec2 uv_b = UV + (b_displacement * strength);

	if(abs(sin(TIME)) < 0.1)
	{
		uv_r = UV + (r_displacement * strength * hyperstrength);
		uv_g = UV + (g_displacement * strength * hyperstrength);
		uv_b = UV + (b_displacement * strength * hyperstrength);
	}
    
    
	
    float r = texture(TEXTURE, uv_r).r;
    float g = texture(TEXTURE, uv_g).g;
    float b = texture(TEXTURE, uv_b).b;
	
	
    vec4 final_combinant = vec4(r, g, b, texture(TEXTURE, UV).a);
	vec4 final_combinant_b = vec4(r, g, b, texture(TEXTURE, UV).a);

	
	if(abs(sin(TIME)) > 0.5 && abs(sin(TIME)) < 0.6)
    {
      if (UV.y > 0.5 && UV.y < 0.52)
	  {
		final_combinant_b = texture(TEXTURE, UV + 0.1);
	  }
    }

	if(abs(sin(TIME)) > 0.8 && abs(sin(TIME)) < 0.9)
    {
      if (UV.y > 0.2 && UV.y < 0.22)
	  {
		final_combinant_b = texture(TEXTURE, UV + 0.1);
	  }
    }

	if(abs(sin(TIME)) > 0.1 && abs(sin(TIME)) < 0.2)
    {
      if (UV.y > 0.7 && UV.y < 0.72)
	  {
		final_combinant_b = texture(TEXTURE, UV + 0.1);
	  }
    }
	
	if(abs(sin(TIME)) > 0.7 && abs(sin(TIME)) < 0.8)
    {
      if (UV.y > 0.8 && UV.y < 0.82)
	  {
		final_combinant_b = texture(TEXTURE, UV - 0.1);
	  }
    }
	
	if(abs(sin(TIME)) > 0.4 && abs(sin(TIME)) < .52)
    {
      if (UV.y > 0.1 && UV.y < 0.12)
	  {
		final_combinant_b = texture(TEXTURE, UV + 0.1);
	  }
    }



	COLOR = final_combinant_b;
}

