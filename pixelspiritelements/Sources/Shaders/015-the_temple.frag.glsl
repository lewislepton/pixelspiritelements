#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float triSDF(vec2 st) {
	st = (st*2.0-1.0)*2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.);

	st.y = 1.0 - st.y;
	vec2 ts = vec2(st.x, 0.82 - st.y);
	color += fill(triSDF(st), 0.7);
	color -= fill(triSDF(ts), 0.36);
  
  fragColor = vec4(color, 1.0);
}