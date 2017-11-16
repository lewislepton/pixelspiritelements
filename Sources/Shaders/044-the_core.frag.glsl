#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float TAU = 6.2831853071795864769252867665590;

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float triSDF(vec2 st){
	st = (st*2.0-1.0)*2.0;
	return max(abs(st.x) * 0.866025 + st.y * 0.5, -st.y * 0.5);
}

float rhombSDF(vec2 st){
	return max(triSDF(st), triSDF(vec2(st.x,1.-st.y)));
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a),-sin(a), sin(a),cos(a))*(st-.5);
	return st+.5;
}

vec2 scale(vec2 st, vec2 s){
	return (st - 0.5) * s + 0.5;
}

float starSDF(vec2 st, int V, float s) {
	st = st * 4.0 - 2.0;
	float a = atan(st.y, st.x) / TAU;
	float seg = a * float(V);
	a = ((floor(seg) + 0.5) / float(V) + mix(s, -s, step(0.5, fract(seg)))) * TAU;
	return abs(dot(vec2(cos(a),sin(a)), st));
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	float star = starSDF(st, 8, 0.063);
	color += fill(star, 1.22);
	float n = 8.0;
	float a = TAU / n;
	for (float i = 0.0; i < n; i++) {
		vec2 xy = rotate(st, 0.39 + a * i);
		xy = scale(xy, vec2(1.0, 0.72));
		xy.y -= 0.125;
		color *= step(0.235, rhombSDF(xy));
	}
  
  fragColor = vec4(color, 1.0);
}