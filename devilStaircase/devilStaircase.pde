int MAXITER = 1;
void setup(){
  size(720, 720);
  background(0);
  stroke(255);
}

float circleMap(float K, float phi){
  float phiN = 0.0 ;
  float res = 0;
  float old = 0; 

  for(int i = 0; i < MAXITER; i++){
    res = phiN + phi - K/(2*PI) * sin(2*PI*phiN);
    phiN = res;
  }
  return phiN/MAXITER;
}

void draw(){
  background(0);
  float phi, out;
  out = width;
  MAXITER ++;
  float oldX, oldY;
  for (int i = 0; i < width; i++){
    phi = map(i, 0, width, 0, 1);
    oldY = out;
    out = circleMap(1, phi);
    out = map(out, 0, 1, height, 0);
    line(i-1, oldY, i, out); 

  }  
    //saveFrame("out/img_###.png");
    //if(frameCount > 60 * 5){exit();}
}

