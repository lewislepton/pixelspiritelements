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

float circle(vec2 st){
	return length(st - 0.5) * 2.0;
}

float rectangle(vec2 st, vec2 s){
	st = st * 2.0 - 1.0;
	return max(abs(st.x / s.x), abs(st.y / s.y));
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float crossing(vec2 st, float s){
	vec2 size = vec2(0.25, s);
	return min(rectangle(st, size.xy), rectangle(st, size.yx));
}

float flip(float v, float pct){
	return mix(v, 1.0 - v, pct);
}

float vesicaSDF(vec2 st, float w){
	vec2 offset = vec2(w*.5,0.);
	return max( circle(st-offset), circle(st+offset));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  vec3 color = vec3(0.);

	float sdf = vesicaSDF(st, 0.2);
	
	color += flip(fill(sdf, 0.5), step((st.x+st.y)*0.5, 0.5));
  
  fragColor = vec4(color, 1.0);
}