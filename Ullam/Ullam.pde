void setup(){
  size(720, 720);
  background(255);
}

int checkPrime(int num){
 //Simple prime checking function, outputs 1 if num is prime, 0 otherwise
 int i;
 for (i = 2; i < sqrt(num); i++){
  if(num%i == 0){
   return 0; 
  }
 }
 return 1;
}

void draw(){
  int compt = 0;

  int x = width/2;
  int y = height/2;
  int squareSize = 8;
  
  for (int j = 1; j < frameCount*2; j++){//
    fill(0);
    for( int i = 1; i <= j; i++){
      compt++;
      if(j%2 != 0)
        x+=squareSize;
      else if(j%2 ==0)
        x-=squareSize;
      if(checkPrime(compt) == 1)
        rect(x,y,squareSize,squareSize);
    }

    for( int i = 1; i <= j; i++){
      compt++;
      if(j%2 != 0)
        y+=squareSize;
      else if(j%2 == 0)
        y-=squareSize;
      if(checkPrime(compt) == 1)
        rect(x,y,squareSize,squareSize);
    }
  }
 //Uncomment this line if you want to save each frame
 saveFrame("output/image_###.png");
}
