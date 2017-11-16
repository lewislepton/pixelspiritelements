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

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.0);

	float sdf = 0.5 + (st.x - st.y) * 0.5;
	color += stroke(sdf, 0.5, 0.1);

	float sdf_inv = (st.x + st.y) * 0.5;
	color += stroke(sdf_inv, 0.5, 0.1);
  
  fragColor = vec4(color, 1.0);
}