#include <flutter/runtime_effect.glsl>

#define M_PI 3.1415926535897932384626433832795

uniform float uRadius;

uniform float uDashAngle;

uniform vec3 uColor;

out vec4 fragColor;

void main() {
    // normalized coordinate from -1 to 1
    vec2 coord = FlutterFragCoord().xy / uRadius;

    // normalized angle from -1 to 1
    float angle = atan(coord.y, coord.x) * 2 / M_PI;

    fragColor = vec4(uColor, step(uDashAngle / 2, mod(angle, uDashAngle)));
}