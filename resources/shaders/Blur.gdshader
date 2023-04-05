shader_type canvas_item;

uniform float blur: hint_range(0.0, 2.5, 0.1);
uniform float brightness: hint_range(0.0, 1.0, 0.05);

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur);
	COLOR.rgb *= brightness;
}
