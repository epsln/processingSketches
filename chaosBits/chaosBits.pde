PShader bitShader;
float iTime;
int nBit;

void setup(){
  size(720, 720, P2D);
  stroke(255);
  background(0);
  frameRate(60);
  iTime = millis()*1000;

  nBit = 1;
  bitShader = loadShader("bitShader.glsl", "defaultVert.glsl");//Loading the shader
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
  //if (frameCount % 30 * 5 == 0){
    nBit += 1 %32 ;
  //}

  saveFrame("out/img_##.jpg");
  if (frameCount > 32){
    exit();
  }
  
}
