shader_type canvas_item;

uniform vec4 black : hint_color = vec4(0,0,0,1);
uniform vec4 white : hint_color = vec4(1,1,1,1);

void fragment()
{
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR = mix(black, white, screen);
}