PVector[] par = new PVector[4 * 2];

float a, b, c, d;
int MAXITER = 10000000;
void setup(){
  size(1080, 1960);
  background(0);
  for (int i = 0; i < 4 * 2; i++)
    par[i] = new PVector(random(-2, 2), random(-2, 2), random(-2, 2));
  
}

PVector rand_curve(float t, int i){
  return new PVector(par[i].x * sin(par[i].y * t + par[i].z), par[i * 2].x * cos(par[i * 2].y + par[i].z)); 
}

void draw(){
  if (frameCount > 900) exit();
  int[][] hist = new int[2160][3840];
  float x, y;
  int x0, y0;
  float maxVal = 0;
  float t = map(frameCount, 1, 900, 0, 2 * PI);

  a = map(noise(rand_curve(t, 0).x, rand_curve(t, 0).y), 0, 1, 5, -2.0);
  b = map(noise(rand_curve(t, 1).x, rand_curve(t, 1).y), 0, 1, -2.5, 5);
  c = map(noise(rand_curve(t, 2).x, rand_curve(t, 2).y), 0, 1, 2, 0);
  d = map(noise(rand_curve(t, 3).x, rand_curve(t, 3).y), 0, 1, 2, -5);

  PVector p = new PVector(random(-1, 1), random(-1, 1));
  PVector[] pArr = new PVector[MAXITER];
  float xMin, yMin, xMax, yMax;
  xMin = 1e10;
  yMin = 1e10;
  xMax = -1e10;
  yMax = -1e10;
  for (int i = 0; i < MAXITER; i++){
    x = sin(a * p.y) + c * cos(a * p.x); 
    y = sin(b * p.x) + d * cos(b * p.y); 
    p.x = x;
    p.y = y;
    pArr[i] = p.copy();
    xMin = min(xMin, p.x);
    yMin = min(yMin, p.y);
    xMax = max(xMax, p.x);
    yMax = max(yMax, p.y);
  }
  for (int i = 0; i < MAXITER; i++){
    p = pArr[i];
    x0 = int(map(p.x, xMin * 1.1, xMax * 1.1, 0, width));
    y0 = int(map(p.y, yMin * 1.1, yMax * 1.1, 0, height));
    if (x0 >= 0 && x0 < width && y0 >= 0 && y0 < height){

      hist[x0][y0]++;
      maxVal = max(maxVal, hist[x0][y0]);
    }
  }
  maxVal = log(maxVal + 1) ;
  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      stroke(log(hist[i][j] + 1)/maxVal * 255);
      point(i, j);
    }
  }
  saveFrame("out/img_###.jpg");
}
