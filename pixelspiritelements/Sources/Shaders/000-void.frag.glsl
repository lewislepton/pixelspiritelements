#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

void main() {
	vec3 color = vec3(1.0);
	
	fragColor = vec4(color, 1.0);
}