#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float triSDF(vec2 st) {
	st = (st * 2.0 - 1.0) * 2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.);

	float sphere = circleSDF(st - vec2(0.0, 0.1));
	float triangle = triSDF(st + vec2(0.0, 0.1));

	color += stroke(sphere, 0.45, 0.1);
	color *= step(0.55, triangle);
	color += fill(triangle, 0.45);
  
  fragColor = vec4(color, 1.0);
}