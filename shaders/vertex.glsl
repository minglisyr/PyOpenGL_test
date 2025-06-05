#version 430 core

layout (location=0) in vec3 vertexPos;
layout (location=1) in vec2 vertexTexCoord;
layout (location=2) in vec3 vertexNormal;
layout (location=3) in vec3 vertexTangent;
layout (location=4) in vec3 vertexBitangent;

uniform mat4 view;
uniform mat4 projection;
layout(std430, binding = 0) buffer modelBuffer {
    mat4[] models;
};

out vec3 fragmentPos;
out vec2 fragmentTexCoord;
out mat3 TBN;

void main()
{
    mat4 model = models[gl_InstanceID];
    
    gl_Position = projection * view * model * vec4(vertexPos, 1.0);

    vec3 T = normalize(vec3(model * vec4(vertexTangent, 0)));
    vec3 B = normalize(vec3(model * vec4(vertexBitangent, 0)));
    vec3 N = normalize(vec3(model * vec4(vertexNormal, 0)));
    TBN = transpose(mat3(T, B, N));
    
    fragmentPos = vec3(model * vec4(vertexPos, 1.0));
    fragmentTexCoord = vertexTexCoord;
}