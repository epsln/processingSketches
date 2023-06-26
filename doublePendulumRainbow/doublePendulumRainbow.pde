import processing.svg.*;

float g = 9.81;
int PEND_NUM = 1000000;

float m1 = 1;
float m2 = 1;
float l1 = 1;
float l2 = 1;
float mu = 1+m1/m2;

float step = 0.01;
float[][] thetaArr = new float[PEND_NUM][4];

void setup(){
  noiseSeed(42);
  size(1920, 1080);
  background(0);
  stroke(255); 
  smooth(8);

  float a = random(PI, 2 * PI);
  float b = random(PI, 2 * PI);
  for (int i = 0; i < PEND_NUM; i++){
    thetaArr[i][0] = PI + 0.01 + i/float(PEND_NUM)/10000;
    thetaArr[i][1] = PI + 0.01 + i/float(PEND_NUM)/10000;
  }
}

float ddTheta1(float Theta1, float Theta2, float dTheta1, float dTheta2){
  return (g*(sin(Theta2)*cos(Theta1-Theta2)-mu*sin(Theta1))-(l2*dTheta2*dTheta2+l1*dTheta1*dTheta1*cos(Theta1-Theta2))*sin(Theta1-Theta2))/(l1*(mu-cos(Theta1-Theta2)*cos(Theta1-Theta2)));

}

float ddTheta2(float Theta1, float Theta2, float dTheta1, float dTheta2){
  return (mu*g*(sin(Theta1)*cos(Theta1-Theta2)-sin(Theta2))+(mu*l1*dTheta1*dTheta1+l2*dTheta2*dTheta2*cos(Theta1-Theta2))*sin(Theta1-Theta2))/(l2*(mu-cos(Theta1-Theta2)*cos(Theta1-Theta2)));
}

void draw(){
  background(0);

  float a0, b0, c0, d0;
  float a1, b1, c1, d1;

  PVector pos1 = new PVector(0, 0);
  PVector pos2 = new PVector(0, 0);

  float dTheta1 = 0;
  float dTheta2 = 0;

  for (int i = 0; i < PEND_NUM; i++){
    //RK Pour choper dTheta1 et dTheta2 
    a0 = step * ddTheta1(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2],        thetaArr[i][3]);
    a1 = step * ddTheta2(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2],        thetaArr[i][3]);
    b0 = step * ddTheta1(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2] + a0/2, thetaArr[i][3] + a1/2);
    b1 = step * ddTheta2(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2] + a0/2, thetaArr[i][3] + a1/2);
    c0 = step * ddTheta1(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2] + b0/2, thetaArr[i][3] + b1/2);
    c1 = step * ddTheta2(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2] + b0/2, thetaArr[i][3] + b1/2);
    d0 = step * ddTheta1(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2] + c0,   thetaArr[i][3] + c1);
    d1 = step * ddTheta2(thetaArr[i][0], thetaArr[i][1], thetaArr[i][2] + c0,   thetaArr[i][3] + c1);

    dTheta1 = thetaArr[i][2] + (a0 + b0*2 + c0*2 + d0)/6;
    dTheta2 = thetaArr[i][3] + (a1 + b1*2 + c1*2 + d1)/6;

    a0 = step *  dTheta1;
    a1 = step *  dTheta2;
    b0 = step * (dTheta1 + a0/2);
    b1 = step * (dTheta2 + a1/2);
    c0 = step * (dTheta1 + b0/2);
    c1 = step * (dTheta2 + b1/2);
    d0 = step * (dTheta1 + c0);
    d1 = step * (dTheta2 + c1);

    thetaArr[i][0] += (a0 + b0*2 + c0*2 + d0)/6;
    thetaArr[i][1] += (a1 + b1*2 + c1*2 + d1)/6;
    thetaArr[i][2] = dTheta1;
    thetaArr[i][3] = dTheta2;

    pos1 = new PVector(map(l1 * sin(thetaArr[i][0]), -l1, l1, (690),  (1230)),
                       map(l1 * cos(thetaArr[i][0]), -l1, l1, (height/4.), (3 * height/4.)));
    pos2 = new PVector(map(l1 * sin(thetaArr[i][0]) + l2 * sin(thetaArr[i][1]), -l1 - l2, l1 + l2, 420, 1500),
                       map(l1 * cos(thetaArr[i][0]) + l2 * cos(thetaArr[i][1]), -l1 - l2, l1 + l2, 0, height));
    stroke(i/float(PEND_NUM) * 255);
    line(width/2., height/2., pos1.x, pos1.y);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  println(frameCount);
  saveFrame("out/img_####.png");
  if (frameCount > 1800) exit();
 }
