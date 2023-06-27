void setup(){
  size(1920, 1080);
  background(0);
  frameRate(60);
  stroke(255);
}

float triWave(float x){//Triangle wave
    return min(abs(x - floor(x)), abs(x-ceil(x)));
}

void draw(){
  background(0);
  int MAXITER = 25;
  float x = 0;
  float y = height;
  float ox = 0;//Get old values to do some lines
  float oy = 0;
  
  float w = 1/2.0 + 1/2.0 * sin(map(frameCount, 0, 30 * 20, 0, 2 * PI));
  for(int i = 0; i < width; i++){
    oy = y;
    ox = x;
    y = 0;
    for(int n = 0; n < MAXITER; n++){
      x = map(i, 0, width, 0, 1);
      y += pow(w,n) * triWave(pow(2,n)*x);
    }
    x = map(x, 0, 1, 0, width);
    y = map(y, 0, 1 + w, height, 0);
    line(ox, oy, x, y);
  }
  saveFrame("output/img_###.jpg");
  if (frameCount > 60 * 10) exit();
}
