#version 430 core

uniform vec3 color;

out vec4 final;

void main()
{
    //return pixel colour
	final = vec4(color,1.0);
}