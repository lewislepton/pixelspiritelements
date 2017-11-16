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

float rectSDF(vec2 st, vec2 s){
	st = st * 2.0 - 1.0;
	return max(abs(st.x / s.x), abs(st.y / s.y));
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a),-sin(a), sin(a),cos(a))*(st-.5);
	return st+.5;
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

	color += flip(stroke(raysSDF(st, 28), 0.5, 0.2), fill(st.y, 0.5));
	float rect = rectSDF(st, vec2(1.0));
	color *= step(0.25, rect);
	color += fill(rect, 0.2);
  
  fragColor = vec4(color, 1.0);
}