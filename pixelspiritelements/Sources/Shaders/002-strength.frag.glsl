#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float PI = 3.1415926535897932384626433832795;

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.0);

  color += step(0.5 + cos(st.y * PI) * 0.25, st.x);
  
  fragColor = vec4(color, 1.0);
}