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

float polySDF(vec2 st, int V){
	st = st * 2.0 - 1.0;
	float a = atan(st.x, st.y) + PI;
	float r = length(st);
	float v = TAU / float(V);
	return cos(floor(0.5 + a / v) * v - a) * r;
}

vec3 bridge(vec3 c,float d,float s,float w) {
  c *= 1.0 - stroke(d, s, w * 2.0);
  return c + stroke(d, s, w);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	st.y = 1.0 - st.y;
	float s = 0.25;
	float t1 = polySDF(st + vec2(0.0, 0.175), 3);
	float t2 = polySDF(st + vec2(0.1, 0.0), 3);
	float t3 = polySDF(st - vec2(0.1, 0.0), 3);
	color += stroke(t1, s, 0.08) + stroke(t2, s, 0.08) + stroke(t3, s, 0.08);
	float bridges = mix(mix(t1, t2, step(0.5, st.y)), mix(t3, t2, step(0.5, st.y)), step(0.5, st.x));
	color = bridge(color, bridges, s, 0.08);
  
  fragColor = vec4(color, 1.0);
}