void setup(){
  size(1920, 1080);
  background(0);
  stroke(255);
}

float logistic(float a, float x){
  return a * x * (1 - x);
}

float gauss(float a, float b, float x){
  return exp(-a * x * x) + b;
}

void drawBiff(float a, float b){
  int i, j;
  int iteration_num = 200;

  float x;
  float coordX, coordY;

  x = 0.1;

  for(i = 0; i < iteration_num; i++){
    //x = logistic(a, x);
    x = gauss(5.2, b, x);
    if(i > 100){//Iterate a bit to get to the cycle
      coordX = map(b, -1, 1, 0, width);
      coordY = map(x, -0.75, 1.25, height, 0);
      point(coordX, coordY);
    }
  }
}

void draw(){
  float a = 0;
  float b = 0;
  float duration  = 10;//Length of anim in sec
  float pointPerFrame = 10;//Num of point plotted per frame

  for (int i = 0; i < pointPerFrame; i++){
    b = map((frameCount * pointPerFrame) + i, 0, 30 * duration*pointPerFrame, -1, 1);
    drawBiff(a, b);
  }
  println(frameCount);
  saveFrame("out/img_###.png");
  if (frameCount > 450) exit();

}
