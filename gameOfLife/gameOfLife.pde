int[] TRUTHTABLE;
int[][] STATE_ARR;
int STATE = 0;
void setup(){
  size(1080, 1920);
  background(0);
  TRUTHTABLE = new int[512];
  STATE_ARR = new int[1080][1920];
}

void draw(){
  if (frameCount > 900) exit();
  for (int i = 0; i < 512; i++){
    TRUTHTABLE[i] = int(random(0, 2));
  }
  for (int i = 0; i < 1080; i++){
    for (int j = 0; j < 1920; j++){
      STATE_ARR[i][j] = int(noise(j/map(frameCount, 0, 900, width/2., 0.00001) + frameCount, i/map(frameCount, 0, 900, height/2., 0.0001) - frameCount) * 2);
    }
  }

  background(0);
  float idx = 0;
  for (int i = 1; i < 1079; i++){
    for (int j = 1; j < 1919; j++){
      idx = STATE_ARR[i - 1][j - 1]  * pow(2, 0);
      idx += STATE_ARR[i - 1][j]     * pow(2, 1);
      idx += STATE_ARR[i - 1][j + 1] * pow(2, 2);
      idx += STATE_ARR[i][j - 1]     * pow(2, 3);
      idx += STATE_ARR[i][j]         * pow(2, 4);
      idx += STATE_ARR[i][j + 1]     * pow(2, 5);
      idx += STATE_ARR[i + 1][j - 1] * pow(2, 6);
      idx += STATE_ARR[i + 1][j]     * pow(2, 7);
      idx += STATE_ARR[i + 1][j + 1] * pow(2, 8);
      STATE_ARR[i][j] = TRUTHTABLE[int(idx)];
    }
  }
  for (int i = 1; i < 1079; i++){
    for (int j = 1; j < 1919; j++){
      stroke(STATE_ARR[i][j] * 255);
      point(i, j);
    }
  }
  saveFrame("out/img_###.png");

}
