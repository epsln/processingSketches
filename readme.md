# Processing Projects
This repository is a compilation of all the small projects I have done in processing for the past few years. Most of them are math themed. 

## Compiling and running the sketchs
You can use the Processing IDE to load and run the sketch. If you're not looking to leave your terminal, you could always use the 
` processing-java --sketch=\<sketch-path>\ --output=\<output-dir>\ --force --run \`

# Sketches Index

## biffmap
A bifurcation diagram implementation. Now with another function other than the logistic one !

## blancmange
A simple plot of the Blancmange function, a continuous function that is also non differentiable everywhere. 

## chaosBits 
Creates interesting patterns using a 2d function on the coordinates of each pixel that outputs an integer, and then checking if a particular bit is set to up in the binary representation of this integer.

## chaosParadox 
Creates fractals using the escape time algorithm with the function representation of paradoxes using real valued logic. 

## circleMap 
Creates a fractal based upon the canonical circle map (or forced oscillator) which depends on the rotation number.

## clifford
Creates the Clifford fratal, which is based on a histogram of the trajetories of the function f(x, y) = {sin(a * y) + c * cos(a * x), sin(b * y) + d * cos(b * y)}

## complexBiffMap 
Creates a complex bifurcation diagram. Since the complex are 2D, their trajectories will be a sequence of 2D points and we only have 3 Dimensions to play with, we reduce the domain using a Hilbert curve, which passes through all points of a subset of the complex plane. Using points on this curve, we iterate and show the trajectories in 2D space, with the third being used to move through the Hilbert Curve.  

## complexPlot
Creates a plot of complex polynomials using domain coloring. For each output of a complex function, we color the corresponding pixel using HSV. The argument determines the Hue, and the magnitude determines the saturation. In particular, we show the roots of a particular function after N iterations, or Nth cycles. This grows toward a fractal similar to Julia.

# devilStaircase 
Simple plot of a continuous monotonous function with 0 derivative almost everywhere.

## doublePendulumRainbow 
Show an animation of a Million double pendulum with a very tiny amount of difference in the initial condition. 

## expSum
Creates plots of exponential sums of the form exp(i/a + i^2/b + i^3/c) with a,b,c being integers. Each point in the serie is connected by a line, creating some nice flowers. 

## fractalFlame
Simple implementation of the fractal flame algorithm.

## gameOfLife
Simple implementation of the game of life with random rules.

## gaussianIntegers
An implementation of the Gaussian Integers. Plot the points whose rounded distance to the origin is prime. 

## polynomialIterations
Show the attractor of random 2D polynomials. Uses an histogram to do so, and computes the Lyapunov exponent of the current polynomial and only show it if its positive, indicating a chaotic trajectory (but not necessarily a "good" attractor).

## polyRoots
Shows the roots of all polynomial a + bx + cx^2 with parameters between [-1; 1].   

## polyRoots
Shows the popcorn attractor using an histogram.

## Ullam
An implementation of the Ullam Spiral. Quite simple yet creates cool looking patterns based on the distribution of primes in a integer spiral.

## weierstrass
Shows the plot of the Weierstrass function, continuous everywhere, differentiable nowhere.

