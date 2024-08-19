shader_type canvas_item;

uniform float brightness : hint_range(0.0, 10.0) = 1.0;

void fragment() {
	COLOR.rgb = COLOR.rgb * brightness;
}
