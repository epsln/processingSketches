int NPOINTS = 1000000;
int MAXITER = 5000;
int NANCHORS = 3;
float DIST = 0.5;
PVector p = new PVector();
PVector[] points = new PVector[NANCHORS];

void setup(){
  background(0);
  size(1080, 1080);
  stroke(255);
}

void draw(){
  if (frameCount > 900) exit();
  background(0);

  int [][]hist = new int[1080][1080];
  PVector[] points = new PVector[NANCHORS];

  for (int i = 0; i < NANCHORS; i++){
    points[i] = new PVector(cos(i/float(NANCHORS) * 2 * PI), sin(i/float(NANCHORS) * 2 * PI));
  }

  int precIdx = 0;
  int idx = int(random(0, NANCHORS));

  float maxVal = 0;
  int x, y;

  for (int i = 0; i < NPOINTS; i++){
    p = new PVector(random(-1, 1), random(-1, 1));
    for (int k = 0; k < MAXITER; k++){
      do {
        idx = int(random(0, NANCHORS));
      }while(idx == precIdx);
      precIdx = idx;
      p.x = (points[idx].x - p.x) * DIST;
      p.y = (points[idx].y - p.y) * DIST;
      x = int(map(p.x, -1, 1, 0, width));
      y = int(map(p.y, -1, 1, 0, height));

      if (x >= 0 && x < width && y >= 0 && y < height){
        hist[x][y]++;
        maxVal = max(hist[x][y], maxVal);
      }
    }
  }
  maxVal = log(maxVal + 1);
  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      stroke(log(hist[i][j] + 1)/maxVal * 255);
      point(i, j);
    }
  }
  saveFrame("out/img_###.jpg");
  NANCHORS++;
}
