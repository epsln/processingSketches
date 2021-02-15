int MAXITER = 2000;
PShader circleShader;


void setup(){
  size(720, 720, P3D);
  background(0);
  frameRate(60);

  circleShader = loadShader("circleShader.glsl", "defaultVert.glsl");
  circleShader.set("res", width, height);
}

void draw(){
  shader(circleShader);
  rect(0, 0, width, height);
  circleShader.set("res", float(width), float(height));
  circleShader.set("maxiter", 1000);
  //saveFrame("output/FHD.jpg");
  //exit();
}
