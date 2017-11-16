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

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a),-sin(a), sin(a),cos(a))*(st-.5);
	return st+.5;
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float polySDF(vec2 st, int V){
	st = st * 2.0 - 1.0;
	float a = atan(st.x, st.y) + PI;
	float r = length(st);
	float v = TAU / float(V);
	return cos(floor(0.5 + a / v) * v - a) * r;
}

float starSDF(vec2 st, int V, float s) {
	st = st * 4.0 - 2.0;
	float a = atan(st.y, st.x) / TAU;
	float seg = a * float(V);
	a = ((floor(seg) + 0.5) / float(V) + mix(s, -s, step(0.5, fract(seg)))) * TAU;
	return abs(dot(vec2(cos(a),sin(a)), st));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	float bg = starSDF(st, 16, 0.1);
	color += fill(bg, 1.3);
	float l = 0.0;
	for (float i = 0.0; i < 8.0; i++) {
		vec2 xy = rotate(st, QTR_PI * i);
		xy.y -= 0.3;
		float tri = polySDF(xy, 3);
		color += fill(tri, 0.3);
		l += stroke(tri, 0.3, 0.03);
	}
	color *= 1.-l;
	float c = polySDF(st, 8);
	color -= stroke(c, 0.15, 0.04);
  
  fragColor = vec4(color, 1.0);
}