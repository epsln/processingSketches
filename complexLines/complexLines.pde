int STEP_SIZE = 30;
int DEG_POL = 5;
int MAXITER = 1;
int N_SUBDIV = 4;
Complex[] an = new Complex[DEG_POL];
PVector[] p = new PVector[DEG_POL * 2];
float EXP = 2.7182818284590452353602874713526624977572470936999;

void setup(){
  noiseSeed(42);
  background(0);
  size(1080, 1920);
  for (int i = 0; i < DEG_POL * 2; i++){
    p[i] = new PVector(random(-.2, -.2), random(-.2, .2));
  }
}

float st_gamma(float x){
  return sqrt(2 * PI/x) * pow((x / EXP), x);
}

float la_gamma(float x){
  float[] p = {0.99999999999980993, 676.5203681218851, -1259.1392167224028,
    771.32342877765313, -176.61502916214059, 12.507343278686905,
    -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7};
  int g = 7;
  if(x < 0.5) return PI / (sin(PI * x) * la_gamma(1 - x));

  x -= 1;
  float a = p[0];
  float t = x + g + 0.5;
  for(int i = 1; i < p.length; i++){
    a += p[i]/(x+i);
  }
  return sqrt(2 * PI) * pow(t, x + 0.5) * exp(-t) * a;
}

Complex f(Complex z){
  Complex buff = an[0].minus(z); 
  Complex[] vals = new Complex[DEG_POL]; 
  
  for (int i = 1; i < DEG_POL; i++){
    buff = buff.times(an[i].minus(z));
  }
  return buff;
}

Complex mandel(Complex z, Complex c){
  return z.times(z).plus(c);
}
Complex smoothMandel(Complex z, Complex c, float q, float n){
  float x = 0;
  float y = 0;
  float x0 = 0;
  float y0 = 0;
  for (int i = 0; i < n; i++){
    x0 = x;
    y0 = y;
    x += st_gamma(n - i + q)/st_gamma(n - i + 1) * (x0 * x0 - y0 * y0 + c.re);
    y += st_gamma(n - i + q)/st_gamma(n - i + 1) * (2 * x0 * y0 + c.im);
  }
  x *= 1/st_gamma(q);
  y *= 1/st_gamma(q);
  return new Complex(x, y);
}

Complex smoothMandel(Complex c){
    Complex z = new Complex(0, 0);
    for (int k = 0; k < MAXITER; k++){ 
      float q = 0.0001;
      z = smoothMandel(z, c, q, k);
      //z = mandel(z, new Complex(x0, y0));
    }
    return z;
}

float averageBand(int ts, int startIdx, int stopIdx){
  float ret = 0;
  for (int i = startIdx; i < stopIdx; i++){
    ret += spectra[ts][i];
  }
  return log(ret/25 + 1)/20; 
}

void draw(){
  background(0);
  float x0, y0;
  float x1, y1;
  x1 = -2;
  y1 = -2;
  stroke(255);
  float[] t = new float[4];

  t[0] = map(frameCount, 0, 10000, 0, 2 * PI);
  t[1] = map(frameCount, 0, 5800, 2, 2 + 2 * PI);
  t[2] = map(frameCount, 0, 9000, -2, -2 + 2 * PI);
  t[3] = map(frameCount, 0, 7800, -1, -1 + 2 * PI);

  Complex z0 = new Complex(0, 0);
  Complex z1 = new Complex(0, 0);
  Complex z2 = new Complex(0, 0);
  Complex zDiv0  = new Complex(0, 0);
  Complex zDiv1  = new Complex(0, 0);
  Complex zBuff  = new Complex(0, 0);



  for (int i = 0; i < DEG_POL; i++){
    an[i] = new Complex(map(noise(p[i].x + p[i].y * sin(t[i % 4]), cos(t[(i + 1) % 4])), 0, 1, -4, 4),
                        map(noise(p[i * 2].x + p[i * 2].y * cos(t[i % 4]), sin(t[(i + 1) % 4])), 0, 1, -4, 4));
   // an[i] = new Complex(random(-2, 2), random(-2, 2));
  //  an[i] = new Complex(cos(2 * i * PI/DEG_POL), sin(2 * i * PI/DEG_POL));
  }

  an[0] = an[0].plus(new Complex(averageBand(frameCount, 0, 50), averageBand(frameCount, 50, 100)));
  an[1] = an[1].plus(new Complex(averageBand(frameCount, 100, 150), averageBand(frameCount, 150, 200)));
  an[2] = an[2].minus(new Complex(averageBand(frameCount, 200, 250), averageBand(frameCount, 250, 300)));
  an[3] = an[3].minus(new Complex(averageBand(frameCount, 300, 350), averageBand(frameCount, 350, 512)));

  println(frameCount, spectra.length, an[0], an[1], an[2], an[3]);
  for (int i = 0; i < width / STEP_SIZE; i++ ){
    x0 = x1; 
    x1 = map(i, 0, width / STEP_SIZE, -2, 2);
    if (i == 0) x0 = x1;
    for (int j = 0; j < height / STEP_SIZE; j++ ){
      y0 = y1;
      y1 = map(j, 0, height / STEP_SIZE, -2, 2);
      if (j == 0) y0 = y1;
      z0 = new Complex(x0, y0);
      z1 = new Complex(x0, y1);
      z2 = new Complex(x1, y1);
      zDiv0 = z1;
      zDiv1 = z1;
      for (int n = 1; n <= N_SUBDIV; n++){
        //zn = z0 + n * (z0 -z1)/N_SUBDIV
        zDiv0 = z1.minus(z0).scale(n).scale(1./N_SUBDIV).plus(z1);
        zBuff = z1.minus(z0).scale(n - 1).scale(1./N_SUBDIV).plus(z1);
        zBuff = f(zBuff);
        zDiv0 = f(zDiv0);
        line(map((float)zBuff.re,-1, 1, 0, width), 
            map((float)zBuff.im, -1 * 1., 1 * 1, 0, height),
            map((float)zDiv0.re, -1, 1, 0, width), 
            map((float)zDiv0.im, -1 * 1., 1 * 1., 0, height)); 

        zDiv1 = z1.minus(z2).scale(n).scale(1./N_SUBDIV).plus(z1);
        zBuff = z1.minus(z2).scale(n - 1).scale(1./N_SUBDIV).plus(z1);
        zBuff = f(zBuff);
        zDiv1 = f(zDiv1);

        line(map((float)zBuff.re, -1, 1, 0, width), 
            map((float)zBuff.im,  -1 * 1, 1 * 1., 0, height),
            map((float)zDiv1.re,  -1, 1, 0, width), 
            map((float)zDiv1.im,  -1 * 1., 1 * 1., 0, height)); 

      }

      //for (int k = 0; k < MAXITER; k++){ 
      //  float q = 0.0001;
      //  x0 = map(i, 0, width * UPSAMPLING, -2, 2);
      //  y0 = map(j, 0, height * UPSAMPLING, -2, 2);
      //  //z = smoothMandel(z, new Complex(x0, y0), q, k);
      //  z = mandel(z, new Complex(x0, y0));
      //  if (z.abs() > 4) break;
      //}
      // point(map((float)z.im, -1, 1, 0, width), 
      //     map((float)z.re, -1.5 * 16/9., 1 * 16/9., 0, height)); 
    }
  }
  saveFrame("out/img_####.png");
}
