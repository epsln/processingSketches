int NUM_PT = 100000;
int MAXITER = 1000000;
int[][] HISTO = new int[4961][7016];
PrintWriter output;
void setup(){
  size(4961, 7016);
  background(0);
  output = createWriter("checkpoint_CPU.txt"); 

  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      HISTO[i][j] = 0;
    }
  }
}

PVector cmpxmul( PVector a,PVector b) {
  return new PVector(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y, 0.0);
}

PVector f(PVector z, PVector r){
  float xtemp;

  //   a c - a c^2 - b d + 2 b c d + a d^2 
  //i (b c - b c^2 + a d - 2 a c d + b d^2)	
  xtemp = r.x * z.x - r.x * z.x * z.x - r.y * z.y + 2 * r.y * z.x * z.y + r.x * z.y * z.y;
  z.y =   r.y * z.x - r.y * z.x * z.x + r.x * z.y - 2 * r.x * z.x * z.y + r.y * z.y * z.y;
  z.x = xtemp;

  return new PVector(z.x, z.y);
}

void draw(){
  background(0);
  PVector z0;
  PVector z = new PVector(0, 0);
  PVector[] traj = new PVector[MAXITER];
  int x, y;
  float maxVal = 0;
  boolean drawIt = false;
  for (int i = 0; i < NUM_PT; i++){
    z0 = new PVector(random(-1, 1), random(-1, 1)); 
    drawIt = false;
    for (int j = 0; j < MAXITER; j++){
      traj[j] = new PVector(0., 0.);
    }
    traj[0] = new PVector(random(-1, 1), random(-1, 1));
    for (int j = 1; j < MAXITER; j++){
      traj[j] = f(traj[j - 1], z0).copy();
      if (traj[j].mag() > 2){
        for (int idx = 1; idx < j; idx++){
          y = int(map(traj[idx].x, -1 , 1, 0, height)); 
          x = int(map(traj[idx].y, -1 * 1/sqrt(2), 1 * 1/sqrt(2), 0, width)); 
          if (x >= 0 && y >= 0 && x < width && y < height)
            HISTO[x][y]++;
        }
        break;
      }
    }
  }
  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      maxVal = max(HISTO[i][j], maxVal);
    }
  }
  maxVal = log(maxVal);

  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      output.print(str(HISTO[i][j]) + ",");
      stroke(log(HISTO[i][j] + 1)/maxVal * 255);
      point(i, j);
    }
    output.print("\n");
  }
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file

  println(frameCount);
  saveFrame("out/img_###.png");
}
