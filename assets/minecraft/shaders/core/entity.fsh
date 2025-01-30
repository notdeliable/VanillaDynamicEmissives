#version 150

#moj_import <fog.glsl>
#moj_import <emissive_utils.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightColor;
in vec4 faceLightColor;
in vec4 overlayColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    color *= vertexColor * ColorModulator;
    #ifndef NO_OVERLAY
		color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
	#endif
    int alpha = int(round(textureLod(Sampler0, texCoord0, 0.0).a * 255.0));
    color = make_emissive(color, lightColor, faceLightColor, alpha);
	#ifdef ALPHA_CUTOUT
		if (color.a < ALPHA_CUTOUT) discard;
	#endif
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
