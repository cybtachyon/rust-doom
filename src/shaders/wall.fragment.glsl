#version 330 core
out vec3 color;

uniform vec2 u_atlas_size;
uniform sampler2D u_atlas;
uniform sampler2D u_palette;

in float v_dist;
in vec2 v_tile_uv;
flat in vec2 v_atlas_uv;
flat in float v_tile_width;
flat in float v_brightness;

const float BRIGHT_BIAS = 1e-4;
const float DISTANCE_FALOFF = 30.0;
const float TILE_HEIGHT = 128.0;

void main() {
    vec2 uv = mod(v_tile_uv, vec2(v_tile_width, TILE_HEIGHT)) + v_atlas_uv;
    vec2 palette_index = texture(u_atlas, uv / u_atlas_size).rg;
    if (palette_index.g > .5) {  // Transparent pixel.
        discard;
    } else {
        float dist_term = min(1.0, 1.0 - 1.2 / (v_dist + 1.2));
        float colormap_index = min(v_brightness, v_brightness - dist_term);
        colormap_index = clamp(1.0 - colormap_index,
                               BRIGHT_BIAS, 1.0 - BRIGHT_BIAS);
        color = texture(u_palette, vec2(palette_index.r, colormap_index)).rgb;
    }
}
