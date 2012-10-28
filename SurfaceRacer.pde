// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Basic example of falling rectangles

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Car> cars;

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

  // Display all the people
  for (Car car: cars) {
    car.display();
  }

  // people that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  /*for (int i = cars.size()-1; i >= 0; i--) {
    Car car = cars.get(i);
    if (cs.done()) {
      polygons.remove(i);
    }
  }*/
}

boolean sketchFullScreen() {
  return true;
}

void keyPressed() {
  if (key == 'w' ) 
  {
    cars.get(0).accelerate(5);
  }
  else if(key == 's'){
    cars.get(0).accelerate(-5);
  } 
  else if(key == 'a'){
    cars.get(0).turn(5);
  } 
  else if(key == 'd'){
    cars.get(0).turn(-5);
  } 

}
/*void mousePressed() {
  CustomShape cs = new CustomShape(mouseX,mouseY);
  polygons.add(cs);
}*/





