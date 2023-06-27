int MAXITER = 10;
void setup(){
  size(1920, 1080);
  background(0);
  frameRate(60);
  stroke(255);
}

float weierstrass(float x, float a, float b){//Triangle wave
  float out = 0;
  for (int i = 0; i < MAXITER; i++){
    out += pow(a, i) * cos(pow(b, i) * PI * x);
  }
  return out;
}

void draw(){
  background(0);
  float x = 0;
  float y = weierstrass(0, 0.1, 3);
  float ox = 0;//Get old values to do some lines
  float oy = 0;
  float a, b;
  a = 0.5;
  b = 3;
  
  float w = 1/2.0 + 1/2.0 * sin(map(frameCount, 0, 60 * 10, 0, 2*PI));
  println(w);
  for(int i = 0; i < width; i++){
    oy = y;
    ox = x;

    x = map(i, 0, width, -2, 2);
    y = weierstrass(x, a, b);

    x = map(x, -2, 2, 0, width);
    y = map(y, -2, 2, height, 0);
    line(ox, oy, x, y);
  }
  //Uncomment me to save to a directory
  saveFrame("output/img###.jpg");
  if (frameCount > 60 * 10) exit();
}
