shader_type spatial;
render_mode unshaded, shadows_disabled, skip_vertex_transform, cull_disabled;

uniform sampler2D tex;
uniform vec4 color : hint_color;
uniform float offset;
uniform float perspective;

void vertex()
{
	vec4 p = MODELVIEW_MATRIX * vec4(VERTEX,1);
	vec4 a = p;
	vec4 o = MODELVIEW_MATRIX * vec4(0,0,0,1);
	
	vec4 b = vec4(VERTEX,1);
	b.z += offset;
	b = MODELVIEW_MATRIX * b;
	
	a.z = 0.0;
	b.z = 0.0;
	vec4 d = b - a;
	d.xy += o.xy * perspective;
	
	vec4 forward = normalize(MODELVIEW_MATRIX * vec4(0,0,1,0));
	d.xyz -= dot(d.xyz, forward.xyz) * forward.xyz;
	
	VERTEX = p.xyz + d.xyz;
}

void fragment()
{
	vec4 c = texture(tex, UV);
	ALBEDO = c.rgb;
	if (c.a < 0.5)
	{
		discard;
	}
}