uniform vec2 iResolution;
uniform float iTime;
uniform int nBit;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 pos;

float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = 1080/freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	//xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(3.14159265358*xy));
	float a = rand((ij+vec2(0.,0.)));
	float b = rand((ij+vec2(1.,0.)));
	float c = rand((ij+vec2(0.,1.)));
	float d = rand((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
	float persistance = .5;
	float n = 0.;
	float normK = 0.;
	float f = 4.;
	float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		n+=amp*noise(p, f);
		f*=2.;
		normK+=amp;
		amp*=persistance;
		if (iCount == res) break;
		iCount++;
	}
	float nf = n/normK;
	return nf*nf*nf*nf;
}

int funct(vec2 pos){
	//Change this function to whatever you may please.
	//Pro tip : trig function do really well !
	float buff = pNoise(pos.xy, 10) * 100;
	for (int idx = 0; idx < 10*nBit; idx++){
		buff += pNoise(pos.xy, 10) * 100;
	}
	return int(buff);

}

void main()
{
	vec2 ipos = pos.xy  * 10;
	int val = funct(ipos.xy);
	vec3 color = vec3(0.0, 0.0, 0.0);
	//Check the value of a particular bit, if it's up, then the pixel is white
	//You could check multiple bit and make some weird coloring based on the value...
	if ((val & (1 << (nBit - 1))) >> (nBit - 1) == 1)
		color = vec3(1.0, 1.0, 1.0);
	gl_FragColor = vec4(color, 1.0);
}
