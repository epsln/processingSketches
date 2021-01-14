void setup(){
  size(720, 720);
  background(0);
  frameRate(1);
  stroke(255);
}

float triWave(float x){//Triangle wave
  if(abs(x-floor(x)) >= abs(x-ceil(x)))
    return abs(x-ceil(x));
   else
    return abs(x-floor(x));
}

void draw(){
  background(0);
  int MAXITER = frameCount;
  float x = 0;
  float y = height;
  float ox = 0;//Get old values to do some lines
  float oy = 0;

  for(int i = 0; i < 720; i++){
    oy = y;
    ox = x;
    y = 0;
    for(int n = 0; n < MAXITER; n++){
      x = map(i, 0, width, 0, 1);
      y += triWave(pow(2,n)*x)/pow(2,n);
    }
    x = map(x, 0, 1, 0, width);
    y = map(y, 0, 1, height, 0);
    line(ox, oy, x, y);
  }
  //Uncomment me to save to a directory
  //saveFrame("output/img##.jpg");
  //if (frameCount > 10) exit();
}
