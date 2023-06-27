int MAXITER = 1000000;
int numIm = 0;
int IMG_SIZE = 1080 * 2;
PVector[] an = new PVector[12 * 2];


void setup(){
  size(2160, 2160);
  background(0);
  for (int i = 0; i < 12 * 2; i++){
    an[i] = new PVector(random(-2, 2), random(-2, 2), random(-2, 2));
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
  return new PVector(x, y);
}

void draw(){
  if (numIm > 900) exit();
  int x, y;
  float dx, dy, d0, dd, xe, ye, ly;
  ly = 0;
  float maxVal = 0;
  float xMin = 1000000;
  float yMin = 1000000;
  float xMax = -100000;
  float yMax = -100000;
  int drawIt = 0;
  float[] coefs = new float[12];
  PVector p =  new PVector(random(-1, 1), random(-1, 1));
  PVector pe =  new PVector(random(-1, 1), random(-1, 1));
  PVector[] traj = new PVector[MAXITER];
  int[][] hist = new int[IMG_SIZE][IMG_SIZE];
  for (int i = 0; i < 12; i++)
    coefs[i] = random(-1, 1);

  traj[0] = f(p, coefs);

  d0 = -1;
  xe = 0; ye = 0;
  while (d0 <= 0){
    xe = traj[0].x + random(-0.5, 0.5)/1000.;
    ye = traj[0].y + random(-0.5, 0.5)/1000.;
    dx = traj[0].x - xe;
    dy = traj[0].y - ye;
    d0 = sqrt(dx * dx + dy * dy);
  }
  int idx = 0;
  for (int i = 1; i < MAXITER; i++){
    traj[i] = f(traj[i - 1], coefs);
    pe = f(new PVector(xe, ye), coefs);

    xMin = min(xMin, traj[i].x);
    xMax = max(xMax, traj[i].x);
    yMin = min(yMin, traj[i].y);
    yMax = max(yMax, traj[i].y);


    if (xMin < -1e10 || xMax > 1e10 || yMin < -1e10 || yMax > 1e10){
      drawIt = 0; 
      break;
    }
    
    dx = traj[i].x - traj[i - 1].x;
    dy = traj[i].y - traj[i - 1].y;
    if (abs(dx) < 1e-10 && abs(dy) < 1e-10){
      drawIt = 0;
      break;
    }
    if ( i > 1000){ 
      //Computing lyap exponent
      dx = traj[i].x - pe.x;
      dy = traj[i].y - pe.y;
      dd = sqrt(dx * dx + dy * dy);
      ly += log(abs(dd/d0)); 
      xe = traj[i].x + d0 * dx / dd;
      ye = traj[i].y + d0 * dy / dd;
    }
  }

  //If lyap exponent is positive, then system is chaotic
  if (ly > 0){
    background(0);
    println("Chaotic: ", ly);
    for (int i = 1; i < MAXITER; i++){
      x = int(map(traj[i].x, xMin, xMax, 50, IMG_SIZE - 50));
      y = int(map(traj[i].y, yMin, yMax, 50, IMG_SIZE - 50));
      hist[x][y]++;
      maxVal = max(hist[x][y], maxVal);
    }

    maxVal = log(maxVal);

    for (int i = 0; i < IMG_SIZE; i++){
      for (int j = 0; j < IMG_SIZE; j++){
        stroke( log(hist[i][j] + 1)/maxVal * 255.);
        point(i, j);
      }
    }
    saveFrame("out/img_" + str(numIm) +".png"); 
    numIm++;
  }
}
