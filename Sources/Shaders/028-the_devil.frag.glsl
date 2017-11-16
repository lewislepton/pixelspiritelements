#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;
float TAU = 6.2831853071795864769252867665590;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float starSDF(vec2 st, int V, float s) {
	st = st * 4.0 - 2.0;
	float a = atan(st.y, st.x) / TAU;
	float seg = a * float(V);
	a = ((floor(seg) + 0.5) / float(V) + mix(s, -s, step(0.5, fract(seg)))) * TAU;
	return abs(dot(vec2(cos(a), sin(a)), st));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	color += stroke(circleSDF(st), 0.8, 0.05);
	st.y = 1.0 - st.y;
	float s = starSDF(st.yx, 5, 0.1);
	color *= step(0.7, s);
	color += stroke(s, 0.4, 0.1);
  
  fragColor = vec4(color, 1.0);
}