extern vec4 glowColor;   // Color of the glow
extern float radius;     // Radius of the glow effect (in pixels)
extern vec2 textureSize; // Size of the sprite

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float alpha = 0.0;
    vec2 pixel = vec2(1.0) / textureSize;

    // 8-direction sampling (box blur for outline)
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * pixel * radius;
            vec4 sample = Texel(texture, texture_coords + offset);
            alpha = max(alpha, sample.a);
        }
    }

    vec4 texColor = Texel(texture, texture_coords);

    // If the pixel is transparent, use the glow color where alpha > 0
    if (texColor.a == 0.0 && alpha > 0.0) {
        return glowColor;
    }

    // Otherwise, return the sprite normally
    return texColor * color;
}
