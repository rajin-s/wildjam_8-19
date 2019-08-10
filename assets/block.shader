shader_type spatial;
render_mode unshaded;

uniform sampler2D tex;
uniform sampler2D noise;
uniform vec4 color : hint_color = vec4(1.0);
uniform float block;
uniform float block_count = 4;
uniform float variation_count = 4;

varying float rand;

void vertex()
{
	vec4 world_position = WORLD_MATRIX * vec4(0,0,0,1);
	vec4 noise_tex = textureLod(noise, (world_position.xz + vec2(block * 123.3, block * -91.2)) / 256.0, 0.0);
	rand = round((noise_tex.r + noise_tex.g + noise_tex.b) / 3.0 * variation_count);
}

void fragment()
{	
	float offset = block * 2.0 / (block_count * 2.0);
	vec2 uv = UV;
	uv.x = uv.x / (block_count * 2.0) + offset;
	uv.y /= float(variation_count);
	uv.y += rand / float(variation_count);
	vec4 tex_color = texture(tex, uv);
	ALBEDO = tex_color.rgb * color.rgb;
	ALPHA_SCISSOR = 0.5;
	ALPHA = tex_color.a;
}