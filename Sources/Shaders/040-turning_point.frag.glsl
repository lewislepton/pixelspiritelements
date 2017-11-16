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

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a),-sin(a), sin(a),cos(a))*(st-.5);
	return st + 0.5;
}

float polySDF(vec2 st, int V){
	st = st * 2.0 - 1.0;
	float a = atan(st.x, st.y) + PI;
	float r = length(st);
	float v = TAU / float(V);
	return cos(floor(0.5 + a / v) * v - a) * r;
}

vec3 bridge(vec3 c,float d,float s,float w) {
  c *= 1.-stroke(d,s,w*2.);
  return c + stroke(d,s,w);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	st = rotate(st, radians(-60.0));
	st.y = flip(st.y, step(0.5, st.x));
	st.y += 0.25;
	float down = polySDF(st, 3);
	st.y = 1.5 - st.y;
	float top = polySDF(st, 3);
	color += stroke(top, 0.4, 0.15);
	color = bridge(color, down, 0.4, 0.15);
  
  fragColor = vec4(color, 1.0);
}