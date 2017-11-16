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

float triSDF(vec2 st){
	st = (st * 2.0 - 1.0) * 2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

float rhombSDF(vec2 st){
	return max(triSDF(st), triSDF(vec2(st.x,1.-st.y)));
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

	st = st.yx;
	st.x = mix(1.0 - st.x, st.x, step(0.5, st.y));
	vec2 o = vec2(0.1, 0.0);
	vec2 s = vec2(1.0);
	float a = radians(45.0);
	float l = rectSDF(rotate(st + o, a), s);
	float r = rectSDF(rotate(st - o, -a), s);
	color += stroke(l, 0.3, 0.1);
	color = bridge(color, r, 0.3, 0.1);
	color += fill(rhombSDF(abs(st.yx - vec2(0.0, 0.5))), 0.1);
  
  fragColor = vec4(color, 1.0);
}