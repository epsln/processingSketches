PShader fractal;
float heightF;
float widthF;

int iterMax = 5;
PVector rParam;

void setup() {
  size(720, 720, P3D);
  fractal = loadShader("shaderFrag.glsl", "defaultVert.glsl");
  heightF = height;
  widthF = width;
  rParam = new PVector(0,0);
  fractal.set("iterMax", iterMax);
  fractal.set("r", rParam);
  fractal.set("windowSize", heightF, widthF);
  frameRate(30);
}

void draw() {
  background(0);
  shader(fractal);
  rect(0,0,width,height);
  
  rParam.x = map(frameCount, 0, 60*5, 2, 4);

  //Uncomment to play around with different seed values for c
  //rParam.x = map(frameCount, 0, 60*5, 2, 4);
  if (frameCount%(60 * 5)== 0){
     println("Framecount: ", frameCount);
     iterMax += 3;
     fractal.set("iterMax", iterMax);
  }
  fractal.set("r", rParam);
  saveFrame("out/img_###.jpg");
  if (frameCount == 60 * 5){
    exit();
  }
  
}
