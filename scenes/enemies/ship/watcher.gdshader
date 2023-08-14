shader_type canvas_item;

void fragment() {
	float t = TIME * 0.025;
	vec4 tex = texture(TEXTURE, UV);
	float grad = sign(cos((sin(t * 0.77) + cos(t * 0.43) + sin(t * 0.13) + 4.0) * UV.y * 50.0 + UV.x * 100.0 * sin(t * 13.33) + (1.0 - UV.x) * 100.0 * sin(t * 3.33)));
	COLOR = vec4(grad, grad, grad, tex.a);
}
