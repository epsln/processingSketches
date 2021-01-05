void setup(){
  size(1920, 1080);
  background(0);
  stroke(255);
  frameRate(60);
}

float logistic(float a, float x){
  return a * x * (1 - x);
}

void drawBiff(float a){
  int i, j;
  int iteration_num = 500;

  float initial_value = 0.1;
  float x;
  float coordX, coordY;

  x = initial_value;

  for(i = 0; i < iteration_num; i++){
    x = logistic(a, x);
    if(i > 100 && a > 2){//Iterate a bit to get to the cycle
      coordX = map(a, 2, 4, 0, width);
      coordY = map(1-x, 0, 1, 0, height);
      point(coordX, coordY);
    }
  }
}


void draw(){
  float a = 0;
  float duration  = 10;//Length of anim in sec
  float pointPerFrame = 10;//Num of point plotted per frame

  //We loop to plot N values of a per frame, to get a smoother line without lengthening to much the length of the anim
  for (int i = 0; i < pointPerFrame; i++){
    a = map((frameCount*pointPerFrame)+i, 0, 60*duration*pointPerFrame, 2, 4);
    drawBiff(a);
  }

  if (a == 4) exit();

  //saveFrame("output/biff_####.png");
}
