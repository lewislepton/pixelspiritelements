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

float rectSDF(vec2 st, vec2 s){
	st = st * 2.0 - 1.0;
	return max(abs(st.x / s.x), abs(st.y / s.y));
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float flip(float v, float pct) {
	return mix(v, 1.0 - v, pct);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.);

	float rect = rectSDF(st, vec2(0.5, 1.0));
	float diag = (st.x + st.y) * 0.5;
	color += flip(fill(rect, 0.6), stroke(diag, 0.5, 0.01));
  
  fragColor = vec4(color, 1.0);
}