PShader bitShader;
float iTime;
int nBit;

void setup(){
  size(720, 720, P2D);
  stroke(255);
  background(0);
  frameRate(60);

  iTime = millis()/1000;

  nBit = 1;
  //Loading the shader
  bitShader = loadShader("bitShader.glsl", "defaultVert.glsl");
  //Setting the uniforms (with iTime in case of animation stuff)
  bitShader.set("res", width, height);
  bitShader.set("iTime", iTime);
}

void draw(){
  iTime = millis()/1000.0;
  rect(0, 0, width, height);
  shader(bitShader);
  
  bitShader.set("res", width, height);
  bitShader.set("iTime", iTime);
  bitShader.set("nBit", nBit);

  //Uncomment me if you want to save the frame :)
 //saveFrame("out/img_##.jpg");
  
}
