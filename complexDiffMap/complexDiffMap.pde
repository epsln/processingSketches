import processing.svg.*;
int RNUM = 100;
float a = 0;
float THETA = 0;
float rotation = 0;
ArrayList<PVector> RA   = new ArrayList();
ArrayList<PVector> posP = new ArrayList();
float H_BOUNDS = 2;
int NUM_MID_POINTS = 2;

PVector mobA = new PVector(random(-1, 1), random(-1, 1));
PVector mobB = new PVector(random(-1, 1), random(-1, 1));
PVector mobC = new PVector(random(-1, 1), random(-1, 1));

int MODE = 0; //0 for Hilbert Curve, 1 for random theta
int reps = 6;
void hilbert(float x0,float y0,float xi,float xj,float yi,float yj,int n){
  if(n <= 0){
    float X = x0 + (xi + yi)/2;
    float Y = y0 + (xj + yj)/2;

    //Output the coordinates of the cv
    X = map(X, 0, 1, -3, 3);
    Y = map(Y, 0, 1, -3, 3);
    RA.add(new PVector(X,Y));
  }
  else{
    hilbert(x0,               y0,               yi/2, yj/2, xi/2, xj/2, n - 1);
    hilbert(x0 + xi/2,        y0 + xj/2,        xi/2, xj/2, yi/2, yj/2, n - 1);
    hilbert(x0 + xi/2 + yi/2, y0 + xj/2 + yj/2, xi/2, xj/2, yi/2, yj/2, n - 1);
    hilbert(x0 + xi/2 + yi,   y0 + xj/2 + yj,  -yi/2,-yj/2,-xi/2,-xj/2, n - 1);
  }
} 

void fillPosP(){
  PVector z = new PVector();
  PVector z0 = new PVector();
  ArrayList<PVector> traj = new ArrayList();
  float x, y, d;
  int inside = 1;
  for (int i = 0; i < RA.size() - 1; i++){
    for (int j = 1; j < NUM_MID_POINTS; j++){
      inside = 1;
      z.x = 0.25;
      z.y = 0.25;
      z0.x = j * RA.get(i).x/(NUM_MID_POINTS + 1);
      z0.y = j * RA.get(i).y/(NUM_MID_POINTS + 1);
      for (int k = 0; k < 1000; k++){
        z = logMap(z, z0);
        //z = genLogMap(z, RA.get(i));
        //z = burningShip(z, RA.get(i));
        //z = threeBrotMap(z, z0);
        //z = julia(z, z0);
        //z = brotMap(z, z0);
        //z = randomMobius(z, z0); 

        x = map(z.y, -2, 2, -width * (16./9.), width * (16/9.));
        y = map(z.x, -2, 2, -height / (16/9.), height / (16/9.));
        d = map(z0.x, -2, 2, -max(width, height), max(width, height));
        if (z.mag() > 1){
          inside = 0;
          break;
        }

        if (Float.isNaN(x) == false && Float.isNaN(y) == false && Float.isNaN(d) == false && k > 100){ 
          traj.add(new PVector(x,y,d));
        }
      }
      if (inside == 1){
          for (int k = 0; k < traj.size(); k++)
            posP.add(traj.get(k).copy());
          traj.clear();
      }
    }
  }
}


void setup(){
  PVector z = new PVector();

  THETA = 0.;
  println(THETA);
  size(1080, 1920, P3D);
  background(0);

  if (MODE == 0){ 
    hilbert(0.0, 0.0, 1.0, 0.0, 0.0, 1.0, reps);
    fillPosP();
  }
  else if (MODE == 1){
    for (int i = 0; i < RNUM; i++){
      float x = map(i, 0, RNUM, 0, 10)*cos(THETA);
      float y = map(i, 0, RNUM, 0, 10)*sin(THETA);
      RA.add(new PVector(x, y));
    }
    fillPosP();
  }

}


PVector cmpxmul( PVector a,PVector b) {
  return new PVector(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y, 0.0);
}

PVector cmpxdiv(PVector a ,PVector b) {
  return cmpxmul(a, reciproc(b));
}

PVector reciproc(PVector a){
  float scale = a.x * a.x + a.y * a.y;
  return new PVector(a.x/a.magSq(), -a.y/a.magSq());
}

//Simple generalized log map
PVector logMap(PVector x, PVector r){
  //rx - rx^2
  PVector buff = new PVector();
  PVector buff1 = new PVector();
  buff = cmpxmul(x, r);
  buff1 = cmpxmul(r, cmpxmul(x, x));
  buff.x = buff.x - buff1.x;
  buff.y = buff.y - buff1.y;
  return buff; 
}

//Fully generalized log map with stronger normalization term
//(1-z) -> exp(theta_z)(1-r) 
//This maps the complex unit circle to itself, guaranteeing us convergence
PVector genLogMap(PVector z, PVector r){
  // x_{n+1} = r*z*exp(theta_z)*(1-r_z)
  float rz = z.magSq();
  float thetaz = atan2(z.y, z.x);
  PVector buff = new PVector();
  PVector buff1 = new PVector();
  buff = cmpxmul(z, r);
  buff1.x = (1-rz)*cos(thetaz);
  buff1.y = (1-rz)*sin(thetaz);
  buff = cmpxmul(buff, buff1);
  return buff; 
}

PVector randomMobius(PVector z, PVector z0){
  //z0 * z + b/z0 * z +d 
  mobB = new PVector(noise(frameCount), mobB.y); 
  PVector buff = new PVector(0, 0);
  buff = cmpxmul(z, z0).add(mobA);
  z = cmpxdiv(buff, cmpxmul(z, mobB).add(mobC));
  return z;
}

PVector brotMap(PVector z, PVector z0){
  //z^2 + z0
  z = cmpxmul(z, z);
  z.x = z.x + z0.x;
  z.y = z.y + z0.y;
  return z; 
}

PVector threeBrotMap(PVector z, PVector z0){
  //z^2 + z0
  z = cmpxmul(z, z);
  z = cmpxmul(z, z);
  z.x = z.x + z0.x;
  z.y = z.y + z0.y;
  return z; 
}

PVector julia(PVector z, PVector z0){
  PVector zOut = new PVector(0,0);
  zOut = cmpxmul(z0, z0);
  zOut.x += z.x;
  zOut.y += z.y;
  return z; 
}

PVector burningShip(PVector z, PVector z0){
  PVector zOut = new PVector(0,0);
  zOut.x =  z.mag() * z.mag() + z0.x;
  zOut.y =  z.mag() * z.mag() + z0.y;
  return zOut;
}

void draw(){
  background(0);

  if (MODE == 1){
    for (int i = 0; i < RNUM; i++){
      float x = map(i, 0, RNUM, 0, 10)*cos(THETA);
      float y = map(i, 0, RNUM, 0, 10)*sin(THETA);
      RA.add(new PVector(x, y));
    }
    fillPosP();
  }

  THETA = map(frameCount, 0, 900, 0, 2 * PI);
  a += 0.05;

  float orbitRadius= width/4. + 1000;
  float ypos= -cos(rotation) * orbitRadius;;
  float xpos= cos(rotation)*orbitRadius;
  float zpos= sin(rotation)*orbitRadius;

  rotation = map(frameCount, 0, 900, 0, 2 * PI); 

  camera(xpos, ypos, zpos, 0, 0, - 100, 0, -1, 0);

  stroke(255);

  for (PVector p: posP){
    point(p.z, p.x, p.y);
  }

  if (MODE == 1){
    RA.clear();
    posP.clear();
  }
  if (frameCount == 900)  exit();
  saveFrame("out/img_###.png");


}
