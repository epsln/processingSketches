int BOUNDS = 1;
int MODE = 2;
int MAXINT = 5;

void setup(){
  size(1080, 1080);
  background(0);
  stroke(255);
}

int checkPrime(int p){
  if (p > 2 && p%2 == 0) return 0;
  for (int i = 3; i < sqrt(p); i+=2){
    if (p%i == 0){
      return 0;
    }
  }
  return 1;
}

void draw(){
  background(0);
  stroke(255);
  float x, y;
  int xp, yp;
  if (MODE == 1){
    MAXINT += 2;
    for (int i = -MAXINT; i < MAXINT; i++){
      for (int j = -MAXINT; j < MAXINT; j++){
        x = map(j, -MAXINT,MAXINT, 0, width); 
        y = map(i, -MAXINT,MAXINT, height, 0); 
        if (i != 0 && j != 0 && checkPrime(i*i+j*j) == 1){
        println("0", i, j);
          point(x,y);
          continue;
        }
        else if (i == 0 && checkPrime(abs(j)) == 1 && abs(j) % 4 == 3){
        println("1", i, j);
          point(x,y);
          continue;
        }
        else if (j == 0 && checkPrime(abs(i)) == 1 && abs(i) % 4 == 3){
          point(x,y);
        println("2", i, j);
          continue;
        }
      }
    }
  }
  else {
    BOUNDS +=1;
    for (int i = 0; i < height; i++){
      for (int j = 0; j < width; j++){
        xp = (int)map(i, 0, height,-BOUNDS, BOUNDS); 
        yp = (int)map(j, 0, width, -BOUNDS, BOUNDS); 
        if (checkPrime(xp*xp+yp*yp) == 1) point(i,j);
        if (checkPrime(i*i+j*j) == 1){
          point(xp,yp);
        }
        else if (i == 0 && checkPrime(abs(j)) == 1 && abs(j) % 4 == 3){
          point(xp,yp);
          continue;
        }
        else if (j == 0 && checkPrime(abs(i)) == 1 && abs(i) % 4 == 3){
          point(xp,yp);
          continue;
        }
      }
    }
  }
  //Uncomment this to save the image into out/ 
  saveFrame("out/img_##.jpg");
  if(frameCount > 120) exit();
}
