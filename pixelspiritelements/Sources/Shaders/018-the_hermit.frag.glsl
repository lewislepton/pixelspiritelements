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

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

float triSDF(vec2 st){
	st = (st * 2.0 - 1.0) * 2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

float rhombSDF(vec2 st){
	return max(triSDF(st), triSDF(vec2(st.x, 1.0 - st.y)));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	float sdf = rhombSDF(st);

	color += flip(fill(triSDF(st), 0.5), fill(rhombSDF(st), 0.4));
  
  fragColor = vec4(color, 1.0);
}