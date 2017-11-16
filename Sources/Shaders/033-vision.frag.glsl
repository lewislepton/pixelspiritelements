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

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float vesicaSDF(vec2 st, float w){
	vec2 offset = vec2(w*.5,0.);
	return max( circleSDF(st-offset), circleSDF(st+offset));
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

	float v1 = vesicaSDF(st, 0.5);
	vec2 st2 = st.yx + vec2(0.04, 0.0);
	float v2 = vesicaSDF(st2, 0.7);
	color += stroke(v2, 1.0, 0.05);
	color += fill(v2, 1.0) * stroke(circleSDF(st),0.3, 0.05);
	color += fill(raysSDF(st, 50), 0.2) * fill(v1, 1.25) * step(1.0, v2);
  
  fragColor = vec4(color, 1.0);
}