import org.qscript.*;
import org.qscript.editor.*;
import org.qscript.errors.*;
import org.qscript.events.*;
import org.qscript.eventsonfire.*;
import org.qscript.operator.*;

ArrayList<PVector> posP   = new ArrayList();

int N = 1;
float Max = 30;
double Pi = 3.14159265358979323846264338327950288419716939937510;
int state = 0;
int a, b, c;
void setup(){
  size(720, 720);
  background(0);
  stroke(255);
  a = int(random(1, 100));
  b = int(random(1, 100));
  c = int(random(1, 100));
}


float func(float x, float a, float b, float c){
  return pow(x, 1)/a + pow(x, 2)/b + pow(x, 3)/c;
}


int lcm(int a, int b){
  int temp = a;
  while (true){
    if (temp % b == 0 && temp % a == 0)
      break;
    temp += 1;
  }
  return temp;
}

void draw(){
  N = 3492;
  background(0);
  float x, y,  xOld, yOld;
  float x0,y0, x1,   y1;
  float maxX, maxY, minX, minY;
  int l;

  minX = 1e10;
  minY = 1e10;
  maxX = -1e10;
  maxY = -1e10;
  x = 0.0;
  y = 0.0; 

  a = round(random(1, 100));
  b = round(random(1, 100));
  c = round(random(1, 100));

  if(a < b)
    l = lcm(int(a), int(b));
  else
    l = lcm(int(b), int(a));
  if(l > int(c))
    N = lcm(l, int(c));
  else
    N = lcm(int(c), l);

  for (int i = 1; i < N; i++){
    x += cos(2.0 * PI * func(i, a, b, c)); 
    y += sin(2.0 * PI * func(i, a, b, c)); 
    posP.add(new PVector(x, y));
    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }
  for(int i = 0; i < N - 2; i++){
    x0 = map(posP.get(i).x,     minX, maxX, 0, width);
    y0 = map(posP.get(i).y,     minY, maxY, height, 0);
    x1 = map(posP.get(i + 1).x, minX, maxX, 0, width);
    y1 = map(posP.get(i + 1).y, minY, maxY, height, 0);

    line(x1,y1,x0,y0);
  }
}

