//This sketch is inspired by the paper Pattern and Chaos : New Images in the Semantics of Paradox
//https://pdfs.semanticscholar.org/c14bc6069eec278eea39ca0490374.pdf
//Which shows that chaotic behavior can emerge in pardoxes using infinite valued logic

PShader fractal;
float heightF;
float widthF;

void setup() {
  size(1920, 1080, P3D);
  fractal = loadShader("shaderFrag.glsl", "defaultVert.glsl");
  frameRate(1);
  heightF = height;
  widthF = width;
  //set shader variables
  fractal.set("iResolution", heightF, widthF);
}

void draw() {
  background(0);
  //set which shader
  shader(fractal);
 
  //render blank box to use the shader on
  rect(0,0,width,height);
  fractal.set("iResolution", heightF, widthF);
  //set shader variables
  //saveFrame("dualistChaos.jpg");
}
