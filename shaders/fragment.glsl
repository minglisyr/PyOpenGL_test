#version 330 core

layout (location=0) in vec3 fragmentColor;
layout (location=1) in vec2 fragmentTexCoord;
layout (location=2) in vec3 fragmentNormal;

uniform Material material;
uniform Light lights[MAX_LIGHT_COUNT];
uniform vec3 cameraPos;
uniform vec3 ambient;

layout (location=0) out vec4 color;

void main()
{
    color = vec4(fragmentColor, 1.0f);
}#version 430 core

struct Material {
    sampler2D albedo;
    sampler2D ao;
    sampler2D normal;
    sampler2D specular;
};

struct Light {
    vec3 color;
    vec3 position;
    float strength;
};

in vec3 fragmentPos;
in vec2 fragmentTexCoord;
in vec3 fragmentViewPos;

uniform Material material;
uniform Light lights[8];
uniform vec3 ambient;
uniform vec3 cameraPos;

layout (location=0) out vec4 color;

vec3 CalculatePointLight(int i, vec3 normal) {
    vec3 result = vec3(0.0);

    Light light = lights[i];

    //directions
    normal = normalize(normal);
	vec3 fragLight = normalize(light.position - fragmentPos);
    vec3 fragCam = normalize(cameraPos - fragmentPos);
    vec3 halfDir = normalize(fragLight + fragCam);

    //diffuse
    vec3 adjusted_color = max(0.0,dot(normal, fragLight)) * light.color;
	result += adjusted_color * vec3(texture(material.albedo, fragmentTexCoord));
	
    //specular
    adjusted_color = light.strength * pow(max(dot(normal, halfDir), 0.0),32) * light.color;
    result += adjusted_color * vec3(texture(material.specular, fragmentTexCoord));
    
    return result;
}

void main()
{

    vec3 normal = -normalize(vec3(1.0) - 2.0 * texture(material.normal, fragmentTexCoord).xyz);
    
    //ambient
    vec3 lightLevel = ambient * vec3(texture(material.albedo, fragmentTexCoord));
    lightLevel = lightLevel * texture(material.ao, fragmentTexCoord).xyz;

    for (int i = 0; i < 8; i++) {
        float distance = length(lights[i].position - fragmentPos);
        lightLevel += CalculatePointLight(i, normal) / distance;
    }

    color = vec4(lightLevel, 1.0);
}