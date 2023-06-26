int MAXITER = 1000;
int numIm = 0;
float GAMMA = 4;
PVector[] an = new PVector[12 * 2];
PVector[] par = new PVector[12 * 2];


void setup(){
  size(2160, 3840);
  background(0);
  for (int i = 0; i < 12 * 2; i++){
    an[i] = new PVector(random(-2, 2), random(-2, 2), random(-2, 2));
    par[i] = new PVector(random(-2, 2), random(-2, 2), random(-2, 2));
  }
}

PVector cmult(PVector a, PVector b){
  return new PVector(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}

PVector cpow(PVector a, int n){
  PVector pOut = a;
  if (n == 0)
    return new PVector(1, 0);

  for (int i = 1; i <= n; i++){
    pOut = cmult(pOut, pOut);
  }
  return pOut;
}

PVector f(PVector p, float[] a){
  //xn+1 = a0 + a1xn + a2xn2 + a3xnyn + a4yn + a5yn2
  //yn+1 = a6 + a7xn + a8xn2 + a9xnyn + a10yn + a11yn2
  float x, y;
  x = a[0] + a[1] * p.x + a[2] * p.x * p.x + a[3] * p.x * p.y + a[4] * p.y + a[5] * p.y * p.y; 
  y = a[6] + a[7] * p.x + a[8] * p.x * p.x + a[9] * p.x * p.y + a[10] * p.y + a[11] * p.y * p.y; 
  //  xn+1 = sin(a yn) + c cos(a xn)
  //  yn+1 = sin(b xn) + d cos(b yn)
  //x = sin(a[0] * p.y) + a[2] * cos(a[0] * p.x); 
  //y = sin(a[1] * p.x) + a[3] * cos(a[1] * p.y); 
  return new PVector(x, y);
}

PVector rand_curve(float t, int i){
  return new PVector(par[i].x * sin(par[i].y * t + par[i].z), par[i * 2].x * cos(par[i * 2].y + par[i].z)); 
}

void draw(){
  println(frameCount);
  if (numIm > 900) exit();
  int x, y;
  float maxVal = 0;
  float[] coefs = new float[12];
  PVector p;
  int[][] hist = new int[width][height];
  float t = map(frameCount, 1, 900, 0, 2 * PI);


  for (int i = 0; i < 12; i++){
    coefs[i] = map(noise(rand_curve(t, i).x, rand_curve(t, i).y), 0, 1, -1, 1);
  }

  background(0);
  int idx = 0;
  for (int i = 0; i < height; i++){
    for (int j = 0; j < width; j++){
      p = new PVector(map(j, 0, width, -1, 1), map(i, 0, height, -1, 1));
      for (int iter = 0; iter < MAXITER; iter++){
        p = f(p, coefs);
        x = int(map(p.x, -1, 1, 0, width));
        y = int(map(p.y, -1 * 16/9., 1 * 16/9., 0, height));
        if (x >= 0 && x < width && y >= 0 && y < height){
          hist[x][y]++; 
          maxVal = max(maxVal, hist[x][y]); 
        }

        if (p.x < -1e10 || p.x > 1e10 || p.y < -1e10 || p.x > 1e10)
          break;

      }
    }
  }
  maxVal = log(maxVal);
  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      float s = log(hist[i][j] + 1)/maxVal;
      stroke(map(s, 0, 1, 0, 255));

      point(i, j);
    }
  }
  saveFrame("out/img_###.png"); 
}
