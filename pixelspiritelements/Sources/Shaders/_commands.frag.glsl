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

float spiralSDF(vec2 st, float t) {
  st -= .5;
	float r = dot(st,st);
	float a = atan(st.y,st.x);
	return abs(sin(fract(log(r)*t+a*0.159)));
}

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float rectSDF(vec2 st, vec2 s){
	st = st * 2.0 - 1.0;
	return max(abs(st.x / s.x), abs(st.y / s.y));
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float crossSDF(vec2 st, float s){
	vec2 size = vec2(0.25, s);
	return min(rectSDF(st, size.xy), rectSDF(st, size.yx));
}

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

float vesicaSDF(vec2 st, float w){
	vec2 offset = vec2(w*.5,0.);
	return max( circleSDF(st-offset), circleSDF(st+offset));
}

float triSDF(vec2 st){
	st = (st*2.0-1.0)*2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

float rhombSDF(vec2 st){
	return max(triSDF(st), triSDF(vec2(st.x,1.-st.y)));
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a),-sin(a), sin(a),cos(a))*(st-.5);
	return st+.5;
}

float polySDF(vec2 st, int V){
	st = st * 2.0 - 1.0;
	float a = atan(st.x, st.y) + PI;
	float r = length(st);
	float v = TAU / float(V);
	return cos(floor(0.5 + a / v) * v - a) * r;
}

float hexSDF(vec2 st){
	st = abs(st * 2.0 - 1.0);
	return max(abs(st.y), st.x * 0.866025 + st.y * 0.5);
}

float raysSDF(vec2 st, int N) {
	st -= 0.5;
	return fract(atan(st.y, st.x) / TAU * float(N));
}

float heartSDF(vec2 st) {
	st -= vec2(0.5, 0.8);
	float r = length(st) * 5.0;
	st = normalize(st);
	return r - ((st.y * pow(abs(st.x), 0.67)) / (st.y + 1.5) - (2.0) * st.y + 1.26);
}

vec3 bridge(vec3 c,float d,float s,float w){
  c *= 1.-stroke(d,s,w*2.);
  return c + stroke(d,s,w);
}

vec2 scale(vec2 st, vec2 s){
	return (st - 0.5) * s + 0.5;
}

float flowerSDF(vec2 st, int N) {
	st = st * 2.0 - 1.0;
	float r = length(st) * 2.0;
	float a = atan(st.y, st.x);
	float v = float(N) * 0.5;
	return 1.0 - (abs(cos(a * v)) * 0.5 + 0.5) / r;
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
  vec3 color = vec3(0.);
  
  fragColor = vec4(color, 1.0);
}