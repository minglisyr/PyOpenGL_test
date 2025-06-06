#version 430 core

layout(std430, binding = 1) buffer colorBuffer {
    vec4[] colors;
};

in flat int InstanceID;

out vec4 final;

void main()
{
    //return pixel colour
	final = colors[InstanceID];
}