shader_type spatial;
render_mode cull_disabled;

uniform float frequency;
uniform float maxAmplitude;
uniform float speed;

void vertex() {
    // Scale the amplitude based on the position (more at the beginning, less at the end)
    float scaledAmplitude = maxAmplitude * (VERTEX.z -.06 );

    // Calculate the sine wave for the wiggle
    float wave = scaledAmplitude * sin(VERTEX.z * frequency + TIME * speed);

	VERTEX.x += wave;
}
void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(0,0,0);
}