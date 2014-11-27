#define PROCESSING_COLOR_SHADER
uniform vec2 resolution;
uniform vec2 center;
//uniform mat2 transformMat;
uniform float scale;
uniform float angle;

float f(float c){
	return cos(3.14159 * 0.5 * c);
}

void main(void) {
	//float x0 = (gl_FragCoord.x - resolution.x/2.0)/resolution.x + center.x;
	//float y0 = (gl_FragCoord.y - resolution.y/2.0)/resolution.y + center.y;
	mat2 transformMat = mat2(scale,0.,0.,scale);
	mat2 rotateMat = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));

	vec2 pos = (gl_FragCoord.xy - resolution / 2.0) / resolution;
	vec2 cen = rotateMat * center;

	pos = rotateMat * pos;
	pos = transformMat * pos;
	pos = pos + cen;

	float x = 0.0;
	float y = 0.0;

	float count = 0.0;

	for(float i = 0.0; i < 100.0; i += 1.0){
		if(distance(x,y) > 2.0) {break;}

		float xtemp = pow(x,2.0) - pow(y,2.0);
		y = (2.0 * x * y) + pos.y;
		x = xtemp + pos.x;
		count = i;
	}
	float c = count + 1.0 - log(log(distance(x,y)) / log(2.0));
	c = (c / 99.0);
	if(count == 99.0) {c=1.0;}

	gl_FragColor = vec4(f(c),f(c),f(c),1.0);
}

