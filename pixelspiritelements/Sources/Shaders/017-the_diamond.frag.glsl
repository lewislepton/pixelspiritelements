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

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.);

	float sdf = rhombSDF(st);

	color += fill(sdf, 0.425);
	color += stroke(sdf, 0.5, 0.05);
	color += stroke(sdf, 0.6, 0.03);
  
  fragColor = vec4(color, 1.0);
}