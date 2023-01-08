shader_type canvas_item;

uniform float time_factor = 0.2;
uniform vec2 amplitude = vec2(20.0,5.0);

void vertex() {
    VERTEX.x += cos(TIME * time_factor + VERTEX.x + VERTEX.y) * amplitude.x;
    VERTEX.x += sin(TIME * time_factor + VERTEX.y + VERTEX.x) * amplitude.y;
}