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

	float inv = step(0.5, st.y);
	st = rotate(st, radians(-45.0))-0.2;
	st = mix(st, 0.6 - st, step(0.5, inv));
	for (int i = 0; i < 5; i++) {
		float r = rectSDF(st, vec2(1.0));
		float s = 0.25;
		s -= abs(float(i) * 0.1 - 0.2);
		color = bridge(color, r, s, 0.05);
		st += 0.1;
	}
  
  fragColor = vec4(color, 1.0);
}