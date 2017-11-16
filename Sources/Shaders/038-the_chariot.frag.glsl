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

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a), -sin(a), sin(a), cos(a)) * (st - 0.5);
	return st + 0.5;
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

	float r1 = rectSDF(st, vec2(1.0));
	float r2 = rectSDF(rotate(st, radians(45.0)), vec2(1.0));
	float inv = step(.5,(st.x + st.y) * 0.5);
	inv = flip(inv,step(0.5, 0.5 + (st.x - st.y) * 0.5));
	float w = 0.075;
	color += stroke(r1, 0.5, w) + stroke(r2, 0.5, w);
	float bridges = mix(r1, r2, inv);
	color = bridge(color, bridges, 0.5, w);
  
  fragColor = vec4(color, 1.0);
}