shader_type canvas_item;

uniform float hp_ratio = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE, UV);

	float dist = distance(UV, vec2(0.5));

	if (tex_color.a > 0.0) {
		if (dist < 0.5 * hp_ratio) {
			tex_color.a = 1.0;
		} else {
			tex_color.a = 0.3;
		}
	}
	//tex_color.a = mix(tex_color.a, 1.0, boost_factor);

	COLOR = tex_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
