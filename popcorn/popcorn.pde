int MAXIT = 100;
float[] p;
void setup(){
  size(1080, 1920);
  background(0);
  p = new float[4]; 
}

void draw(){
  if (frameCount > 900) exit();
  background(0);
  int[][] arr = new int[1080][1920];
  float x, y, buff;
  x = random(-1, 1); 
  y = random(-1, 1); 
  int i, j;
  float maxVal = -1;
  // xn+1 = xn - h sin(yn + tan(3 yn))
  //yn+1 = yn - h sin(xn + tan(3 xn))
  p[0] = noise(2 * sin(frameCount/900. * 2 * PI), 2 * cos(frameCount/900. * 2 * PI)) * 0.2;
  p[1] = noise(1 * sin(frameCount/900. * 2 * PI), 1 * cos(frameCount/900. * 2 * PI)) * 0.5;
  p[2] = noise(1 * sin(frameCount/900. * 2 * PI), 1 * cos(frameCount/900. * 2 * PI)) * 0.5;
  p[3] = noise(4 * sin(frameCount/900. * 2 * PI), 4 * cos(frameCount/900. * 2 * PI)) * 0.1;

  println(frameCount, p[0], p[1], p[2], p[3]);
  for (int x0 = 0; x0 < width; x0++){
    for (int y0 = 0; y0 < height; y0++){
      x = map(x0, 0, width, -1, 1);
      y = map(y0, 0, width, -1, 1);
      for(int iter = 0; iter < MAXIT; iter++){
        buff = x - p[0] * sin(p[2] * y + tan(3 * y)) ;
        y    = y - p[0] * sin(p[2] * x + tan(3 * x)) ;
        x    = buff;

        i = int(map(x, -1, 1, 0, width));
        j = int(map(y, -1 * 16/9.,  1 * 16./9., 0, height));
        if (i >= 0 && i < width && j >= 0 && j < height){
          arr[i][j]++;
          maxVal = max(maxVal, arr[i][j]);
        }
      }
    }
  }
  
  maxVal = log(maxVal);
  for (x = 0; x < width; x++){
    for (y = 0; y < height; y++){
      stroke(log(arr[int(x)][int(y)])/maxVal * 255); point(x, y);
    }
  }
  saveFrame("out/img_###.jpg");
}
