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

float vesicaSDF(vec2 st, float w){
	vec2 offset = vec2(w * 0.5, 0.0);
	return max(circleSDF(st - offset), circleSDF(st + offset));
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a), -sin(a), sin(a),cos(a)) * (st - 0.5);
	return st + 0.5;
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	float n = 12.0;
	float a = TAU / n;
	for (float i = 0.0; i < n; i++) {
		vec2 xy = rotate(st, a * i);
		xy.y -= 0.189;
		float vsc = vesicaSDF(xy, 0.3);
		color *= 1.-stroke(vsc, 0.45, 0.1) * step(0.5, xy.y);
		color += stroke(vsc, 0.45, 0.05);
	}
  
  fragColor = vec4(color, 1.0);
}