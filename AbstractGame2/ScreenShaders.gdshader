
shader_type canvas_item;

uniform float vignette_intensity = 0.4; // Size of the vignette, how far towards the middle it should go.
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;


float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.0;
	return pow(vignette, vignette_intensity * vignette_opacity);
}

void fragment() {
	vec4 text;
	text = texture(SCREEN_TEXTURE, SCREEN_UV);
	text.rgb *= vignette(SCREEN_UV);
	COLOR = text;
}