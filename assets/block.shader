shader_type spatial;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D tex;
uniform sampler2D noise;
uniform vec4 color : hint_color = vec4(1.0);
uniform vec4 color_2 : hint_color = vec4(1.0);
uniform float block;
uniform float scale_variation = 0.0;

varying vec4 rand;

void vertex()
{
	float block_count = 8.0;
	float variation_count = 4.0;
	
	vec4 world_position = WORLD_MATRIX * vec4(0,0,0,1);
	vec4 noise_tex = textureLod(noise, (world_position.xz + vec2(block * 123.3, block * -91.2)) / 256.0, 0.0);
	rand.r = round((noise_tex.r + noise_tex.g + noise_tex.b) * 1.1 * 0.33 * variation_count);
	rand.g = clamp(noise_tex.r - noise_tex.g + noise_tex.b, 0, 1);
	
	VERTEX *= mix(1.0, 1.0 + scale_variation, noise_tex.b * noise_tex.r + noise_tex.g);
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment()
{	
	float block_count = 8.0;
	float variation_count = 4.0;
	float offset = block * 2.0 / (block_count * 2.0);
	vec2 uv = UV;
	uv.x = uv.x / (block_count * 2.0) + offset;
	uv.y /= float(variation_count);
	uv.y += rand.r / float(variation_count);
	vec4 tex_color = texture(tex, uv);
	ALBEDO = tex_color.rgb * mix(color_2.rgb, color.rgb, rand.g);
	if (tex_color.a < 0.5)
	{
		discard;
	}
//	ALPHA_SCISSOR = 0.5;
//	ALPHA = tex_color.a;
}