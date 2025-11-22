shader_type spatial;

//render_mode world_vertex_coords;
uniform vec3 colors[3]: source_color ;
//uniform vec3 color_B : source_color ;
//uniform vec3 color_C : source_color ;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	//vec3 Wn = normalize((MODEL_NORMAL_MATRIX * NORMAL));

	vec3 Wn = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	//vec3 Wn = normalize(MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
	//float alignment = dot(Wn, vec3(0.0, 1.0, 0.0));
	//float step_result = step(0.4, alignment) + step(0.85, alignment);
	float step_result = step(0.4, Wn.y) + step(0.85, Wn.y);


	int intstep = int(step_result);

	ALBEDO = colors[intstep];

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
