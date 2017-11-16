#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float spiralSDF(vec2 st, float t) {
  st -= .5;
	float r = dot(st,st);
	float a = atan(st.y,st.x);
	return abs(sin(fract(log(r)*t+a*0.159)));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	color += step(0.5, spiralSDF(st, 0.13));
  
  fragColor = vec4(color, 1.0);
}