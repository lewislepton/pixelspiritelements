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

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float crossSDF(vec2 st, float s){
	vec2 size = vec2(0.25, s);
	return min(rectSDF(st, size.xy), rectSDF(st, size.yx));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.);

	float rect = rectSDF(st, vec2(1.0));
	color += fill(rect, 0.5);
	float cross = crossSDF(st, 1.0);
	color *= step(0.5, fract(cross * 4.0));
	color *= step(1.0, cross);
	color += fill(cross, 0.5);
	color += stroke(rect, 0.65, 0.05);
	color += stroke(rect, 0.75, 0.025);
  
  fragColor = vec4(color, 1.0);
}