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

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

vec3 bridge(vec3 c,float d,float s,float w) {
  c *= 1.-stroke(d, s, w * 2.0);
  return c + stroke(d, s, w);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	st.x = flip(st.x, step(0.5, st.y));
  vec2 offset = vec2(0.15, 0.0);
  float left = circleSDF(st + offset);
  float right = circleSDF(st - offset);
  color += stroke(left, 0.4, 0.075);
  color = bridge(color, right, 0.4, 0.075);
  
  fragColor = vec4(color, 1.0);
}