precision highp float;

uniform sampler2D texture;
uniform int iterMax;
uniform vec3 r;
uniform vec2 windowSize;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 pos;

vec3 hsl2rgb( in vec3 c )
{
	vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

	return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}
float map(float variable1, float min1, float max1, float min2, float max2){
	return min2+(max2-min2)*((variable1-min1)/(max1-min1));
}
vec2 cmpxcjg( vec2 c) {
	return vec2(c.x, -c.y);
}

vec2 cmpxmul( vec2 a,  vec2 b) {
	return vec2(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}

vec2 cmpxpow( vec2 c, int p) {
	for (int i = 1; i < p; ++i) {
		c = cmpxmul(c, c);
	}
	return c;
}

vec2 cmpxdiv( vec2 a,  vec2 b) {
	return cmpxmul(a, cmpxcjg(b));
}



float cmpxmag( vec2 c) {
	return sqrt(c.x * c.x + c.y * c.y);
}


vec2 logMap(vec2 z, vec3 r, int iter){
	// f[z] = r*z - r * z^2
	vec2 buff1    = vec2(0,0);
	vec2 buff2    = vec2(0,0);
	vec2 outVar   = z;
	for (int i = 0; i < iter; ++i){
		buff1 = cmpxmul(r.xy, outVar);
		buff2 = cmpxmul(r.xy, cmpxpow(outVar, 2));
		outVar.x = buff1.x - buff2.x;
		outVar.y = buff1.y - buff2.y;
	}
	//f(x) = rx(1-x)-x =0
	outVar.x -= z.x;
	outVar.y -= z.y;
	return outVar;
}

vec2 brot(vec2 z, vec3 r, int iter){
	// f[z] = z^2 + c 
	vec2 buff1    = vec2(0,0);
	vec2 c = vec2(0,0);
	vec2 outVar   = z;
	for (int i = 0; i < iter; ++i){
		buff1 = cmpxmul(outVar, outVar);
		outVar.x = buff1.x + r.x;
		outVar.y = buff1.y + r.y;
	}
//f(x) = rx(1-x)-x =0
	outVar.x -= z.x;
	outVar.y -= z.y;
	return outVar;
}


void main() {
	float H, L, S;
	
	float x0 = map(pos.x, -windowSize.x/2, windowSize.x/2, 0, 1.0);
	float y0 = map(pos.y, -windowSize.y/2, windowSize.y/2, -0.5, 0.5);
	vec2 z = vec2(x0, y0);
	z = logMap(z, r, iterMax);
	//z = brot(z, r, iterMax);

	H = map(atan(z.y, z.x), -3.14159, 3.14159, 0, 1);	
	L = 1;	
	S = (1 - pow(0.5, cmpxmag(z)));	


	vec3 outCol = hsl2rgb(vec3(H, L,S));
	gl_FragColor = vec4(outCol, 1.0);
}
