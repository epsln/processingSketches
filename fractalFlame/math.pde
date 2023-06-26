float cosh(float x){
  return (1 + exp(-2 * x))/(2 * exp(-x));
}

float sinh(float x){
  return (1 - exp(-2 * x))/(2 * exp(-x));
}

float tanh(float x){
  return (exp(2 * x) + 1)/(exp(2 * x) - 1);
}
