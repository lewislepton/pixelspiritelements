#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float QTR_PI = 0.78539816339;
float HALF_PI = 1.5707963267948966192313216916398;
float PI = 3.1415926535897932384626433832795;
float TWO_PI = 6.2831853071795864769252867665590;
float TAU = 6.2831853071795864769252867665590;
float PHI = 1.618033988749894848204586834;
float EPSILON = 0.0000001;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float circle(vec2 st){
	return length(st - 0.5) * 2.0;
}

float rectSDF(vec2 st, vec2 s){
	st = st * 2.0 - 1.0;
	return max(abs(st.x / s.x), abs(st.y / s.y));
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float polySDF(vec2 st, int V) {
	st = st * 2.0 - 1.0;
	float a = atan(st.x, st.y) + PI;
	float r = length(st);
	float v = TAU / float(V);
	return cos(floor(0.5 + a / v) * v - a) * r;
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	float d1 = polySDF(st, 5);
	vec2 ts = vec2(st.x, 1.0 - st.y);
	float d2 = polySDF(ts, 5);
	color += fill(d1, 0.75) * fill(fract(d1 * 5.0), 0.5);
	color -= fill(d1, 0.6) * fill(fract(d2 * 4.9), 0.45);
  
  fragColor = vec4(color, 1.0);
}