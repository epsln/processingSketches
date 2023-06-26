class Variation {
  float[] preTransform  = new float[6];
  float[] postTransform = new float[6];
  float[] params        = new float[6];
  float blending;
  float[] col = new float[3];

  Variation setBlending(float nBlend){
    this.blending= nBlend;
    return this;
  }

  Variation setPreTransform(float[] transfo){
    this.preTransform = transfo;
    return this;
  }

  Variation setPostTransform(float[] transfo){
    this.preTransform = transfo;
    return this;
  }

  Variation(){
    this.blending = random(0, 1);
    blending = 1;

    col[0] = 1;
    col[1] = 1;
    col[2] = 1;
    for (int i = 0; i < 6; i++){
      this.preTransform[i]  = random(-1, 1);
      this.postTransform[i] = random(-1, 1);
      this.params[i] = random(-1, 1);
    }
  }

  PVector applyTransfo(PVector v, float[] transfo){
    float x = transfo[0] * v.x + transfo[1] * v.y + transfo[2];
    float y = transfo[3] * v.x + transfo[4] * v.y + transfo[5];
    return new PVector(x, y);
  }

  PVector variaFun(PVector p){
    return p.copy();
  }

  PVector applyVariation(PVector p){
    PVector v = this.applyTransfo(p, this.preTransform); 

    v = this.variaFun(v);

    v = this.applyTransfo(v, this.postTransform);
    return v;
  }
}

class linear extends Variation{
  linear(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(p.x, p.y);
  }
} 

class sinusoidal extends Variation{
  sinusoidal(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(sin(p.x), sin(p.y));
  }
} 

class spherical extends Variation{
  spherical(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(p.x, p.y).div(pow(p.mag(), 2));
  }
} 

class swirl extends Variation{
  swirl(){
    super();
  }
  PVector variaFun(PVector p){
    float r = p.mag();
    return new PVector(p.x * sin(r * r) - p.y * cos(r * r), p.x * cos(r * r) + p.y * sin(r * r));
  }
} 

class horseshoe extends Variation{
  horseshoe(){
    super();
  }
  PVector variaFun(PVector p){
    float r = p.mag();
    return new PVector((p.x - p.y) * (p.x + p.y), 2 * p.x * p.y).div(r);
  }
} 

class polar extends Variation{
  polar(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(theta/PI, r - 1);
  }
} 

class handkerchief extends Variation{
  handkerchief(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(sin(theta + r), cos(theta - r)).mult(r);
  }
} 

class disc extends Variation{
  disc(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(sin(PI* r), cos(PI * r)).mult(theta/PI);
  }
} 

class spiral extends Variation{
  spiral(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(sin(theta) + sin(r), sin(theta) - cos(r)).mult(1.0/r);
  }
} 

class hyperbolic extends Variation{
  hyperbolic(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(sin(theta)/r, r * cos(theta));
  }
} 

class diamond extends Variation{
  diamond(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(sin(theta) * cos(r), sin(r) * cos(theta));
  }
} 

class ex extends Variation{
  ex(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    float p0 = sin(theta + r);
    float p1 = sin(theta - r);
    return new PVector(pow(p0, 3) + pow(p1, 3), pow(p0, 3) - pow(p1, 3) );
  }
} 

class julia extends Variation{
  julia(){
    super();
  }
  PVector variaFun(PVector p){
    float r = p.mag();
    float theta = atan2(p.y,p.x);
    float phi = int(random(0, 2)) * PI;
    return new PVector(cos(theta/2 + phi), sin(theta/2. + phi)).mult(sqrt(r));
  }
} 

class bent extends Variation{
  bent(){
    super();
  }
  PVector variaFun(PVector p){
    if (p.x >= 0 && p.y >= 0) return new PVector(p.x, p.y);
    else if (p.x <  0 && p.y >= 0) return new PVector(2 * p.x, p.y);
    else if (p.x >= 0 && p.y < 0) return new PVector(p.x, p.y / 2.);
    else return new PVector(2 * p.x, p.y / 2.);
  }
} 

class waves extends Variation{
  waves(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(p.x + this.params[1] * sin(p.y / pow(this.params[2], 2)), p.y + this.params[4] * sin(p.x / pow(this.params[5], 2)));
  }
} 

class fisheye extends Variation{
  fisheye(){
    super();
  }
  PVector variaFun(PVector p){
    float r = p.mag();
    return new PVector(p.y, p.x).mult(2/(r + 1));
  }
} 

class popcorn extends Variation{
  popcorn(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(p.x + this.params[0] * sin(tan(3 * p.y)), p.y + this.params[1] * sin(tan(3 * p.x)));
  }
} 

class exponential extends Variation{
  exponential(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(cos(PI * p.y), sin(PI * p.y)).mult(exp(p.x - 1));
  }
} 

class power extends Variation{
  power(){
    super();
  }
  PVector variaFun(PVector p){
    float theta = atan2(p.y,p.x);
    float r = p.mag();
    return new PVector(cos(theta), sin(theta)).mult(pow(r, sin(theta)));
  }
} 

class cosine extends Variation{
  cosine(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(cos(PI * p.x) * cosh(p.y), -sin(PI * p.x) * sinh(p.y));
  }
} 

class eyefish extends Variation{
  eyefish(){
    super();
  }
  PVector variaFun(PVector p){
    float r = p.mag();
    return new PVector(p.x, p.y).mult(2 / (r + 1));
  }
} 

class bubble extends Variation{
  bubble(){
    super();
  }
  PVector variaFun(PVector p){
    float r = p.mag();
    return new PVector(p.x, p.y).mult(4. / (pow(r, 2) + 4.));
  }
} 

class cylinder extends Variation{
  cylinder(){
    super();
  }
  PVector variaFun(PVector p){
    return new PVector(sin(p.x), p.y);
  }
} 
