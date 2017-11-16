#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float TAU = 6.2831853071795864769252867665590;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float starSDF(vec2 st, int V, float s) {
	st = st * 4.0 - 2.0;
	float a = atan(st.y, st.x) / TAU;
	float seg = a * float(V);
	a = ((floor(seg) + 0.5) / float(V) + mix(s, -s, step(0.5, fract(seg)))) * TAU;
	return abs(dot(vec2(cos(a),sin(a)), st));
}

float raysSDF(vec2 st, int N) {
	st -= 0.5;
	return fract(atan(st.y, st.x) / TAU * float(N));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	color += stroke(raysSDF(st, 8), 0.5, 0.15);
	float inner = starSDF(st.xy, 6, 0.09);
	float outer = starSDF(st.yx, 6, 0.09);
	color *= step(0.7, outer);
	color += fill(outer, 0.5);
	color -= stroke(inner, 0.25, 0.06);
	color += stroke(outer, 0.6, 0.05);
  
  fragColor = vec4(color, 1.0);
}