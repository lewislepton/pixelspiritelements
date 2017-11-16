#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float PI = 3.1415926535897932384626433832795;
float TAU = 6.2831853071795864769252867665590;

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float triSDF(vec2 st){
	st = (st*2.0-1.0)*2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

float rhombSDF(vec2 st){
	return max(triSDF(st), triSDF(vec2(st.x,1.-st.y)));
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

	st -= 0.5;
	float r = dot(st, st);
	float a = (atan(st.y, st.x) / PI);
	vec2 uv = vec2(a, r);
	vec2 grid = vec2(5.0, log(r) * 20.0); 
	vec2 uv_i = floor(uv * grid);
	uv.x += 0.5 * mod(uv_i.y, 2.0);
	vec2 uv_f = fract(uv * grid);
	float shape = rhombSDF(uv_f);
	color += fill(shape, 0.9) * step(0.75, 1.0 - r);
  
  fragColor = vec4(color, 1.0);
}