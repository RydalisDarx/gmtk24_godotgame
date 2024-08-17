shader_type canvas_item;
uniform sampler2D SCREEN_BLUR: hint_screen_texture, filter_linear_mipmap;

uniform float levelOfBlur: hint_range(0.0, 5) = 0.0;


void fragment() {
	vec4 color = texture(SCREEN_BLUR, SCREEN_UV, levelOfBlur);
	COLOR = color;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
