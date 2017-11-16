#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float PI = 3.1415926535897932384626433832795;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.0);

	float offset = cos (st.y * PI) * 0.15;

	color += stroke(st.x, 0.28 + offset, 0.1);
	color += stroke(st.x, 0.5 + offset, 0.1);
	color += stroke(st.x, 0.72 + offset, 0.1);
  
  fragColor = vec4(color, 1.0);
}