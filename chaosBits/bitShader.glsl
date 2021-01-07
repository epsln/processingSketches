uniform vec2 iResolution;
uniform float iTime;
uniform int nBit;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 pos;

int funct(vec2 pos){
	//Change this function to whatever you may please.
	//Pro tip : trig function do really well !
	float buff = pos.x;
	for (int idx = 0; idx < 10*nBit; idx++){
		buff += sin(cos(pos.y)*pos.x);
		buff /= length(pos);
	}
	return int(buff);

}

void main()
{
	vec2 ipos = pos.xy  * 2;
	int val = funct(ipos.xy);
	vec3 color = vec3(0.0, 0.0, 0.0);
	//Check the value of a particular bit, if it's up, then the pixel is white
	//You could check multiple bit and make some weird coloring based on the value...
	if ((val & (1 << (nBit - 1))) >> (nBit - 1) == 1)
		color = vec3(1.0, 1.0, 1.0);
	gl_FragColor = vec4(color, 1.0);
}
