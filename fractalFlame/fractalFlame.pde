int NFUNCTS = 10;
int MAXITER = 1000000;
int NPOINTS = 1000;
float GAMMA = 0.5;

//ArrayList<ArrayList<Variation>> variations = new ArrayList<Variation>();
Variation finalVar;
float[][][] hist  = new float[2160][2160][4];
ArrayList<Variation> variations = new ArrayList<Variation>();
void setup() {
  size(2160, 2160, P3D);
}

void initVars(){
  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      hist[i][j][0] = 0;
      hist[i][j][1] = 0;
      hist[i][j][2] = 0;
      hist[i][j][3] = 0;
    }
  }

  for (int i = 0; i < NFUNCTS; i++){
    int idx = int(random(0, 23));
    int r = int(random(idx, max(idx + random(0, 23), 23)));
    if(r == 0)
      variations.add(new linear());
    if (r == 1)
      variations.add(new sinusoidal());
    if (r == 2)
      variations.add(new spherical());
    if (r == 3)
      variations.add(new swirl());
    if (r == 4)
      variations.add(new horseshoe());
    if (r == 5)
      variations.add(new polar());
    if (r == 6)
      variations.add(new handkerchief());
    if (r == 7)
      variations.add(new disc());
    if (r == 8)
      variations.add(new spiral());
    if (r == 9)
      variations.add(new hyperbolic());
    if (r == 10)
      variations.add(new diamond());
    if (r == 11)
      variations.add(new ex());
    if (r == 12)
      variations.add(new julia());
    if (r == 13)
      variations.add(new bent());
    if (r == 14)
      variations.add(new waves());
    if (r == 15)
      variations.add(new fisheye());
    if (r == 16)
      variations.add(new popcorn());
    if (r == 17)
      variations.add(new exponential());
    if (r == 18)
      variations.add(new power());
    if (r == 19)
      variations.add(new cosine());
    if (r == 20)
      variations.add(new eyefish());
    if (r == 21)
      variations.add(new bubble());
    if (r == 22)
      variations.add(new cylinder());
  }
  finalVar = variations.get(int(random(variations.size())));
}

void draw() {
  NFUNCTS = int(random(3, 20));
  initVars();
  PVector previousP, p;
  PVector[] traj = new PVector[MAXITER];
  PVector[][] trajCol = new PVector[MAXITER][3];
  int enditer = 0;
  int xInt, yInt;
  float freqMax = 0;
  float xMin, xMax, yMin, yMax;
  xMin = 1e10;
  yMin = 1e10;
  xMax = -1e10;
  yMax = -1e10;
  int index, num;
  stroke(255);

  for (int np = 0; np < NPOINTS; np++){
    p = new PVector(random(-1, 1), random(-1, 1));
    //For the number of specified iter
    for (int iter = 0; iter < MAXITER; iter++){
      enditer++;
      //Loop over all variations
      //Chose a random variation 
      num = int(random(0, variations.size()));
      Variation variation = variations.get(num);

      //In case we get INF or NaN we copy the point
      previousP = p.copy();

      //Set transform of the randomly chosen variation
      p = variation.applyVariation(p);

      //Check if values are bad and roll back if
      if (Float.isNaN(p.x) || Float.isNaN(p.y) || !Float.isFinite(p.x) || !Float.isFinite(p.y) || p.mag() > 1e10) {
        p = previousP.copy();
        continue;
      }

      xInt = int(map(p.x, -2, 2, 0, width));
      yInt = int(map(p.y, -2, 2, 0, height));
      if (xInt < width && xInt >= 0 && yInt < height && yInt >= 0){
        hist[xInt][yInt][0] = variation.blending * (hist[xInt][yInt][0] + variation.col[0])/2.;
        hist[xInt][yInt][1] = variation.blending * (hist[xInt][yInt][1] + variation.col[1])/2.;
        hist[xInt][yInt][2] = variation.blending * (hist[xInt][yInt][2] + variation.col[2])/2.;
        hist[xInt][yInt][3]++;
        freqMax = max(freqMax, hist[xInt][yInt][3]);
      }

      p = finalVar.applyVariation(p);
      xInt = int(map(p.x, -2, 2, 0, width));
      yInt = int(map(p.y, -2, 2, 0, height));
      if (xInt < width && xInt >= 0 && yInt < height && yInt >= 0){
        hist[xInt][yInt][0] = finalVar.blending * (hist[xInt][yInt][0] + finalVar.col[0])/2.;
        hist[xInt][yInt][1] = finalVar.blending * (hist[xInt][yInt][1] + finalVar.col[1])/2.;
        hist[xInt][yInt][2] = finalVar.blending * (hist[xInt][yInt][2] + finalVar.col[2])/2.;
        hist[xInt][yInt][3]++;
        freqMax = max(freqMax, hist[xInt][yInt][3]);
      }

      //traj[iter] = p.copy();
      //trajCol[iter] =  
      //xMin = min(p.x, xMin);
      //yMin = min(p.y, yMin);
      //xMax = max(p.x, xMax);
      //yMax = max(p.y, yMax);
      //Convert to size and add to histo if in bounds
    }
    /*
       println(enditer, xMin, xMax, yMin, yMax);
       for (int i = 100; i < min(MAXITER, enditer -1); i++){
       xInt = int(map(traj[i].x, xMin, xMax, 0, width));
       yInt = int(map(traj[i].y, yMin, yMax, 0, height));

       if (xInt < width && xInt >= 0 && yInt < height && yInt >= 0)
       hist[xInt][yInt] += hist[xInt][yInt] + ;

       }
     */
  }

  freqMax = log(freqMax);

  //Make log log histo and plot to screen
  for (int i = 0; i < width; i++){
    for (int j = 0; j < height; j++){
      //println(hist[i][j]* 255);
      //stroke(hist[i][j] * pow(log(hist[i][j])/log(freqMax), 1.0/GAMMA) * 255);
      stroke(hist[i][j][0]* log(hist[i][j][3] + 1)/freqMax* 255, 
          hist[i][j][1]* log(hist[i][j][3] + 1)/freqMax* 255,
          hist[i][j][2]* log(hist[i][j][3] + 1)/freqMax* 255);
      point(i,j);
    }
  }
  println(frameCount);

  saveFrame("out/img_###.png");
  if (frameCount > 300){
    exit();
  }
}
