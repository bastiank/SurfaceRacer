// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Basic example of falling rectangles

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import oscP5.*;

OscP5 oscP5;
// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Car> cars;
ArrayList<CustomBoundary> customBoundaries;
int borderspresent = 0;
void setup() {
  size(1200,800);
  smooth();
  oscP5 = new OscP5(this,57120);
  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, 0);

  // Create ArrayLists  
  cars = new ArrayList<Car>();
  boundaries = new ArrayList<Boundary>();
  customBoundaries = new ArrayList<CustomBoundary>();
  // Add a bunch of fixed boundaries
  //boundaries.add(new Boundary(width/4,height-5,width/2-50,10,0));
  //boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
  boundaries.add(new Boundary(0,0,width,5,0));
  //boundaries.add(new Boundary(5,height/2,10,height,1));
  
  Car car = new Car(100,100);
  cars.add(car);
  CustomBoundary cs = new CustomBoundary("3:0/1,1/0,1/1");
  customBoundaries.add(cs);
  borderspresent = 1;
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
    // Display all the people
  
  if (borderspresent==1){
  for (CustomBoundary customBoundary: customBoundaries) {
    customBoundary.display();
    
  }
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

void oscEvent(OscMessage theOscMessage) { 
   borderspresent = 0;
   println("Killing everybody...");
   for (int i = customBoundaries.size()-1; i > 0; i--) {
    println("KILL!!");
   customBoundaries.remove(i);
   } 
   println("Everybody DEAD!");
      print (customBoundaries);
   int counter = 0;
   String i = "fg";
   while(true){
     i = (theOscMessage.get(counter).stringValue());
     println (i);
     if (i.equals("END"))break;
     CustomBoundary cs = new CustomBoundary(i);
     customBoundaries.add(cs);
     counter ++;
   }
   print (customBoundaries);
   borderspresent = 1;
}
/*
void mousePressed() {
  CustomBoundary cs = new CustomBoundary("3:50/50,50/100,100/100");
  customBoundaries.add(cs);
}
*/


