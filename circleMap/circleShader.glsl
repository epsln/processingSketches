precision highp float;

uniform vec2 res;
uniform int maxiter;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 pos;


float PI = 3.141592653;

float circleMap(float phi, float K){
	float phiN = 0.1;
	float res = 0;

	for(int i = 0; i < maxiter; i++){
		res = phiN + phi + (K/(2*PI) * sin(2*PI*phiN));
		phiN = res;
	}
	return (phiN-phi)/maxiter;
}

float map(float variable1, float min1, float max1, float min2, float max2){
	return min2+(max2-min2)*((variable1-min1)/(max1-min1));
}

void main() {
	float aspectRatio = res.x/res.y;
	float bounds = 1;
	float x = map(pos.x/res.x, 0, 1, 0, 1);
	float y = map(pos.y/res.y, 0, 1, 2*PI, 0);

	float grayCol = circleMap(x, y);	
	gl_FragColor = vec4(grayCol, grayCol, grayCol, 1.0);
}
