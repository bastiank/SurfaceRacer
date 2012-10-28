// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Basic example of falling rectangles

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Car> cars;

float HORSEPOWERS = 100;
float MAX_STEER_ANGLE = PI/3;

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, 0);

  // Create ArrayLists  
  cars = new ArrayList<Car>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  //boundaries.add(new Boundary(width/4,height-5,width/2-50,10,0));
  //boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  
  Car car = new Car(100,100);
  cars.add(car);
}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }
  for (Car car: cars) {
    car.update();
  }
  // Display all the people
  for (Car car: cars) {
    car.display();
  }
}

boolean sketchFullScreen() {
  return true;
}

void keyPressed()
{ 
  Car currentCar = cars.get(0);
  println(keyCode);
  if(keyCode == 38){
    println("UP");
    currentCar.engineSpeed = HORSEPOWERS;
  }
  if(keyCode == 40){
    println("DOWN");
    currentCar.engineSpeed = -HORSEPOWERS;
  }
  if(keyCode == 39){
    println("RIGHT");
    currentCar.steeringAngle = -MAX_STEER_ANGLE;
  }
  if(keyCode == 37){
    println("LEFT");
    currentCar.steeringAngle = MAX_STEER_ANGLE;
  }
}
 
void keyReleased()
{ 
  Car currentCar = cars.get(0);
  println(keyCode);
  if(keyCode == 38){
    println("UP");
    currentCar.engineSpeed = HORSEPOWERS;
  }
  if(keyCode == 40){
    println("DOWN");
    currentCar.engineSpeed = -HORSEPOWERS;
  }
  if(keyCode == 39){
    println("RIGHT");
    currentCar.steeringAngle = 0;
  }
  if(keyCode == 37){
    println("LEFT");
    currentCar.steeringAngle = 0;
  }
}





