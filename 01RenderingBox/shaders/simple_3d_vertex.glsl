#version 430 core

layout (location=0) in vec3 vertexPos;

uniform mat4 view;
uniform mat4 projection;
layout(std430, binding = 0) buffer modelBuffer {
    mat4[] models;
};

out flat int InstanceID;

void main()
{
    mat4 model = models[gl_InstanceID];
    InstanceID = gl_InstanceID;
    gl_Position = projection * view * model * vec4(vertexPos, 1.0);
}