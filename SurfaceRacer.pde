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
import oscP5.*;
import org.jbox2d.dynamics.contacts.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;
OscP5 oscP5;
// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Car> cars;
ArrayList<CustomBoundary> customBoundaries;
int borderspresent = 0;
PImage bg;
PFont font;

void setup() {
 size(1920, 1080);
  noStroke();
  smooth();
  //size(displayWidth, displayHeight);
  minim = new Minim(this);
  font = createFont("Arial Bold",48);
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  wave = new Oscil( 40, 0.1, Waves.SAW );
  // patch the Oscil to the output
  wave.patch( out );
  //size(displayWidth, displayHeight);
  smooth();
  bg = loadImage("120799-2560x1600.jpg");
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
  /*for(int x = 0; x<= 500; x+=50){
    for(int y = 0; y<= 500; y+=50){
      customBoundaries.add(new CustomBoundary("4:"+(x-5)+"/"+(y-5)+","+(x+5)+"/"+(y-5)+","+(x+5)+"/"+(y+5)+","+(x-5)+"/"+(y+5)));
    }
  }*/
  //customBoundaries.add(new CustomBoundary("4:0/0,960/0,960/540,0/540"));
  
  //customBoundaries.add(new CustomBoundary("4:100/100,100/200,200/200,200/100"));
  //customBoundaries.add(new CustomBoundary("4:960/540,960/440,860/440,860/540"));
  // Add a bunch of fixed boundaries
  //boundaries.add(new Boundary(width/4,height-5,width/2-50,10,0));
  //boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  
  Car car = new Car(500,500,0,30,52,6);
  Car car1 = new Car(600,600,0,30,52,1);
  cars.add(car);
  cars.add(car1);
  CustomBoundary cs = new CustomBoundary("3:0/1,1/0,1/1");
  customBoundaries.add(cs);
  borderspresent = 1;
}

synchronized void draw() {
  //background(255);
 
background(bg);
//println(cars.get(0).getSpeed());
wave.setFrequency(40+(int(cars.get(0).getSpeed()*1.5)));
  // We must always step through time!
  
  float frame_render_time = 1/frameRate;
  
  box2d.world.step(frame_render_time,(int)(frame_render_time*120),(int)(frame_render_time*120));

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }
  for (Car car: cars) {
    car.update(frame_render_time);
  }
  // Display all the people
  for (Car car: cars) {
    car.display();
  }

   // oversampled fonts tend to look better
  textFont(font,12);
  // white float frameRate
  //fill(0);
  //text(frameRate,20,20);
  // gray int frameRate display:
  //fill(100);
  text(int(frameRate),20,30);
}

boolean sketchFullScreen() {
  return true;
}

void keyPressed()
{ 
  //Car currentCar = cars.get(0);
  //println(keyCode);
  if(keyCode == 38){
    cars.get(0).accelerating = true;
  }
  if(keyCode == 40){
    cars.get(0).decelerating = true;
  }
  if(keyCode == 39){
    cars.get(0).turnright = true;
  }
  if(keyCode == 37){
    cars.get(0).turnleft = true;
  }
  if(keyCode == 87){
    cars.get(1).accelerating = true;
  }
  if(keyCode == 83){
    cars.get(1).decelerating = true;
  }
  if(keyCode == 68){
    cars.get(1).turnright = true;
  }
  if(keyCode == 65){
    cars.get(1).turnleft = true;
  }
}

void keyReleased()
{ 
  //Car currentCar = cars.get(0);
  //println(keyCode);
  if(keyCode == 38){
    cars.get(0).accelerating = false;
  }
  if(keyCode == 40){
    cars.get(0).decelerating = false;
  }
  if(keyCode == 39){
    cars.get(0).turnright = false;
  }
  if(keyCode == 37){
    cars.get(0).turnleft = false;
  }
  if(keyCode == 87){
    cars.get(1).accelerating = false;
  }
  if(keyCode == 83){
    cars.get(1).decelerating = false;
  }
  if(keyCode == 68){
    cars.get(1).turnright = false;
  }
  if(keyCode == 65){
    cars.get(1).turnleft = false;
  }
}


synchronized void oscEvent(OscMessage theOscMessage) { 
   borderspresent = 0;
   println("Killing everybody...");
   for (int i = customBoundaries.size()-1; i > 0; i--) {
    println("KILL!!");
   customBoundaries.get(i).killBody();
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

void mousePressed() {
  int x = (int)(mouseX/2);
  int y = (int)(mouseY/2);
  customBoundaries.add(new CustomBoundary("4:"+(x-5)+"/"+(y-5)+","+(x+5)+"/"+(y-5)+","+(x+5)+"/"+(y+5)+","+(x-5)+"/"+(y+5)));
  //CustomBoundary cs = new CustomBoundary("3:50/50,50/100,100/100");
  
  //customBoundaries.add(cs);
}


