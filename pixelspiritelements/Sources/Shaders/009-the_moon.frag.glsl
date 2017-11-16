#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.0);

	color += fill(circleSDF(st), 0.65);
	vec2 offset = vec2(0.1, 0.05);
	color -= fill(circleSDF(st - offset), 0.5);
  
  fragColor = vec4(color, 1.0);
}