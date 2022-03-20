import processing.svg.*;

int maxiter = 200;

void setup(){
  size(3840, 2160);
  background(255);
}

void findRoot(float a, float b, float c){
 float x, y;
 if (a == 0){
   point(map(-b, -1, 1, 0, width), height/2);
 }
 float Delta = pow(b,2)-4*a*c;
 if (Delta < 0){
   x = map(-b/(2*a), -1.0 * width/height, 1.0 * width/height, 0, width);
   y = map( -sqrt(-Delta)/(2*a), -1, 1, 0, height);
   point(x,y);
   x = map(-b/(2*a), -1.0 * width/height, 1.0 * width/height,0, width);
   y = map(sqrt(-Delta)/(2*a), -1, 1, 0, height);
   point(x,y);
 }
 else{
  x = (-b-sqrt(Delta))/(2*a);
  y = (-b+sqrt(Delta))/(2*a);
  x = map(x, 1.0 * width/height, -1.0 * width/height, 0, width);
  y = map(y, -1, 1, 0, width);
  point(x, height/2);
  point(y, height/2);
 }

}

void findRootCubic(int a, int b, int c, int d){
 float Delta0 = b*b-3*a*c;
 float Delta1 = 2*b*b*b - 9*a*b*c + 27*a*a*d;
 float C0 = pow((Delta1 - sqrt(pow(Delta1, 2)-4*pow(Delta0, 3))/2), 1/3);
 float C1 = pow((Delta1 + sqrt(pow(Delta1, 2)-4*pow(Delta0, 3))/2), 1/3);
 float x = -1/(3*a)*(b+c+Delta0/c);
}


void draw(){
 for(int a = 0; a < 200; a++){
   for(int b = 0; b < 200; b++){
     for(int c = 0; c < 200; c++){
       findRoot(map(a, 0, maxiter, -1, 1),
           map(b, 0, maxiter, -1, 1),
           map(c, 0, maxiter, -1, 1));
     }
   }
 }
 println("Done");
  saveFrame("img.png");
  exit();
}
