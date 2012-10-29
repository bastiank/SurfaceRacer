import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

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

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class SurfaceRacer extends PApplet {

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Basic example of falling rectangles













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

public void setup() {
  size(1920, 1080);
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  wave = new Oscil( 40, 0.1f, Waves.SAW );
  // patch the Oscil to the output
  wave.patch( out );
  //size(displayWidth, displayHeight);
  //smooth();
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

public synchronized void draw() {
 // background(5);
background(bg);
//println(cars.get(0).getSpeed());
wave.setFrequency(40+(PApplet.parseInt(cars.get(0).getSpeed()*1.5f)));
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

    // Display all the people
  
  /*if (borderspresent==1){
  for (CustomBoundary customBoundary: customBoundaries) {
    customBoundary.display();
    
  }
  }*/
  // people that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  /*for (int i = cars.size()-1; i >= 0; i--) {
    Car car = cars.get(i);
    if (cs.done()) {
      polygons.remove(i);
    }
  }*/
}

public boolean sketchFullScreen() {
  return true;
}

public void keyPressed()
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

public void keyReleased()
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


public synchronized void oscEvent(OscMessage theOscMessage) { 
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

public void mousePressed() {
  int x = (int)(mouseX/2);
  int y = (int)(mouseY/2);
  customBoundaries.add(new CustomBoundary("4:"+(x-5)+"/"+(y-5)+","+(x+5)+"/"+(y-5)+","+(x+5)+"/"+(y+5)+","+(x-5)+"/"+(y+5)));
  //CustomBoundary cs = new CustomBoundary("3:50/50,50/100,100/100");
  
  //customBoundaries.add(cs);
}


// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A fixed boundary class (now incorporates angle)

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  // But we also have to make a body for box2d to know about it
  Body b;

 Boundary(float x_,float y_, float w_, float h_, float a) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = a;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    //bd.restitution = 0.5;
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  // Draw the boundary, it doesn't move so we don't have to ask the Body for location
  public void display() {
    fill(0);
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    float a = b.getAngle();
    pushMatrix();
    translate(x,y);
    rotate(-a);
    rect(0,0,w,h);
    popMatrix();
  }

}

class Car {

  // We need to keep track of a Body and a width and height
  Body body;
  Body leftWheel;
  Body rightWheel;
  Body leftRearWheel;
  Body rightRearWheel;
  RevoluteJoint leftJoint;
  RevoluteJoint rightJoint;
  float engineSpeed = 0;
  float steeringAngle = 0;
  
  float HORSEPOWERS = 800;
  float MAX_STEER_ANGLE = PI/2;
  
  boolean accelerating = false;
  boolean decelerating = false;
  boolean turnleft = false;
  boolean turnright = false;
  
  
  
 PImage img;
 int carwidth = 0;
  // Constructor
  Car(float x, float y, float orientation, float w, float h, int styleVariant) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y),w,h);
    carwidth = PApplet.parseInt(w);
    if (styleVariant==0) img=loadImage("BeastGTS-GTA1.png");
    if (styleVariant==1) img=loadImage("Bulldog-GTA1.png");
    if (styleVariant==2) img=loadImage("Cossie-GTA1.png");
    if (styleVariant==3) img=loadImage("Speeder-GTA1.png");
    if (styleVariant==4) img=loadImage("SquadCar-GTA1-LibertyCity.png");
    if (styleVariant>4)  img=loadImage("Taxi-GTA1-LibertyCity.png");
  }
  public float getSpeed(){
    return  body.getLinearVelocity().length();
  }
  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }
  
  public Vec2 getDirectionVectorFromBody(Body b){
    float a = b.getAngle();
    //Vec2 lv = b.getLinearVelocity();
    Vec2 lv = new Vec2(0,1);
    
    double cs = Math.cos(a);
    double sn = Math.sin(a);
    
    double x = lv.x * cs - lv.y *sn;
    double y = lv.x*sn + lv.y * cs;
    if(lv.length() == 0) return new Vec2(0,0);
    return (new Vec2((float)(x/lv.length()),(float)(y/lv.length())));   
  }
  
  public void update(){
    
    //println("speed: " + str(engineSpeed) + " / steering: " + str(steeringAngle));
    
    if(accelerating && engineSpeed < HORSEPOWERS)
      engineSpeed += 10;
    else if(!accelerating && engineSpeed > 0)
      engineSpeed -= 5;
      
    if(decelerating && engineSpeed > -HORSEPOWERS/2)
      engineSpeed -= 20;
    else if(!decelerating && engineSpeed < 0)
      engineSpeed += 10;

    if(turnleft && steeringAngle < (MAX_STEER_ANGLE))
      //println("left");
      steeringAngle += (PI/20);
    else if(!turnleft && !turnright)
      //println("leftstop");
      steeringAngle = 0;
      
    if(turnright && steeringAngle > -(MAX_STEER_ANGLE))
      //println("right");
      steeringAngle -= (PI/20);
    else if(!turnright && !turnleft)
      //println("rightstop");
      steeringAngle = 0;
    
    killOrthogonalVelocity(leftWheel);
    killOrthogonalVelocity(rightWheel);
    killOrthogonalVelocity(leftRearWheel);
    killOrthogonalVelocity(rightRearWheel);
    float STEER_SPEED = 1.5f; 
    
    Vec2 ldirection = getDirectionVectorFromBody(leftWheel);
    Vec2 rdirection = getDirectionVectorFromBody(rightWheel);
    leftWheel.applyForce(new Vec2(ldirection.x*engineSpeed,ldirection.y*engineSpeed), leftWheel.getPosition());
    rightWheel.applyForce(new Vec2(rdirection.x*engineSpeed,rdirection.y*engineSpeed), rightWheel.getPosition());
 
    //Steering
    float mspeed = steeringAngle - leftJoint.getJointAngle();
    leftJoint.setMotorSpeed(mspeed * STEER_SPEED);
    //float mspeed = steeringAngle - rightJoint.getJointAngle();
    rightJoint.setMotorSpeed(mspeed * STEER_SPEED);
  }
  
  //This function applies a "friction" in a direction orthogonal to the body's axis.
  public void killOrthogonalVelocity(Body targetBody){
    Vec2 localPoint = new Vec2(0,0);
    Vec2 velocity = targetBody.getLinearVelocityFromLocalPoint(localPoint);
    float a = targetBody.getAngle();
     
    Vec2 sidewaysAxis = new Vec2((float)-Math.sin(a),(float)Math.cos(a));
    
    float dp = sidewaysAxis.x*velocity.x + sidewaysAxis.y*velocity.y; 
    
 
     targetBody.setLinearVelocity(new Vec2(sidewaysAxis.x * dp,sidewaysAxis.y * dp));//targetBody.GetWorldPoint(localPoint));*/
  }

  // Drawing the box
  public void display() {
    //displayBody(body);
    displayBody(rightWheel);
    displayBody(leftWheel);
    displayBody(rightRearWheel);
    displayBody(leftRearWheel);
    displayCar(body);
  }
  
  
  
  public void displayCar(Body body){
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation

    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();

     
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a+PI/2);
    scale (0.35f);
    image(img,0-img.width/2,0-img.height/2);
   
    popMatrix();
  }
  public void displayBody(Body body){
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation

    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0);
    stroke(0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  public void makeBody(Vec2 center, float w, float h) {   
    Vec2 leftRearWheelPosition= new Vec2(center.x-w/2,center.x+h/2-10);
    Vec2 rightRearWheelPosition = new Vec2(center.x+w/2,center.x+h/2-10);
    Vec2 leftFrontWheelPosition= new Vec2(center.x-w/2,center.y-h/2+10);
    Vec2 rightFrontWheelPosition = new Vec2(center.x+w/2,center.y-h/2+10);
    
    // define our body
    BodyDef bodyDef = new BodyDef();
    bodyDef.type = BodyType.DYNAMIC;
    bodyDef.linearDamping = 1;
    bodyDef.angularDamping = 1;
    bodyDef.position.set(box2d.coordPixelsToWorld(center));
   
    body = box2d.createBody(bodyDef);
    //body.setMassFromShapes();

 
    BodyDef leftWheelDef = new BodyDef();
    leftWheelDef.type = BodyType.DYNAMIC;
    leftWheelDef.position.set(box2d.coordPixelsToWorld(leftFrontWheelPosition));
    leftWheel = box2d.createBody(leftWheelDef);
    
    BodyDef rightWheelDef = new BodyDef();
    rightWheelDef.type = BodyType.DYNAMIC;
    rightWheelDef.position.set(box2d.coordPixelsToWorld(rightFrontWheelPosition));
    rightWheel = box2d.createBody(rightWheelDef);
    
    BodyDef leftRearWheelDef = new BodyDef();
    leftRearWheelDef.type = BodyType.DYNAMIC;
    leftRearWheelDef.position.set(box2d.coordPixelsToWorld(leftRearWheelPosition));
    leftRearWheel = box2d.createBody(leftRearWheelDef);
    
    BodyDef rightRearWheelDef = new BodyDef();
    rightRearWheelDef.type = BodyType.DYNAMIC;
    rightRearWheelDef.position.set(box2d.coordPixelsToWorld(rightRearWheelPosition));
    rightRearWheel = box2d.createBody(rightRearWheelDef);   
    
    // define our shapes
    PolygonShape boxDef = new PolygonShape();
    FixtureDef boxFix = new FixtureDef();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    boxDef.setAsBox(box2dW,box2dH);
    boxFix.density = 1;
    boxFix.restitution = 0.5f;
    boxFix.shape = boxDef;
    body.createFixture(boxFix);

    //Left Wheel shape
    PolygonShape leftWheelShapeDef = new PolygonShape();
    FixtureDef leftWheelShapeFix = new FixtureDef();
    leftWheelShapeDef.setAsBox(0.2f,0.5f);
    leftWheelShapeFix.density = 1;
    leftWheelShapeFix.shape = leftWheelShapeDef;
    leftWheel.createFixture(leftWheelShapeFix);
    
    //Right Wheel shape
    PolygonShape rightWheelShapeDef = new PolygonShape();
    FixtureDef rightWheelShapeFix = new FixtureDef();
    rightWheelShapeDef.setAsBox(0.2f,0.5f);
    rightWheelShapeFix.density = 1;
    rightWheelShapeFix.shape = rightWheelShapeDef;
    rightWheel.createFixture(rightWheelShapeFix);

    //Left Rear Wheel shape
    PolygonShape leftRearWheelShapeDef = new PolygonShape();
    FixtureDef leftRearWheelShapeFix = new FixtureDef();
    leftRearWheelShapeDef.setAsBox(0.2f,0.5f);
    leftRearWheelShapeFix.density = 1;
    leftRearWheelShapeFix.shape = leftRearWheelShapeDef;
    leftRearWheel.createFixture(leftRearWheelShapeFix);
    
    //Right Rear Wheel shape
    PolygonShape rightRearWheelShapeDef = new PolygonShape();
    FixtureDef rightRearWheelShapeFix = new FixtureDef();
    rightRearWheelShapeDef.setAsBox(0.2f,0.5f);
    rightRearWheelShapeFix.density = 1;
    rightRearWheelShapeFix.shape = rightRearWheelShapeDef;
    rightRearWheel.createFixture(rightRearWheelShapeFix); 
    
    
    RevoluteJointDef leftJointDef = new RevoluteJointDef();
    leftJointDef.initialize(body, leftWheel, leftWheel.getWorldCenter());
    leftJointDef.enableMotor = true;
    leftJointDef.maxMotorTorque = 100;
    
    RevoluteJointDef rightJointDef = new RevoluteJointDef();
    rightJointDef.initialize(body, rightWheel, rightWheel.getWorldCenter());
    rightJointDef.enableMotor = true;
    rightJointDef.maxMotorTorque = 100;
    //rightJointDef.setMotorSpeed(100);
 
    leftJoint = (RevoluteJoint) box2d.world.createJoint(leftJointDef);
    rightJoint= (RevoluteJoint) box2d.world.createJoint(rightJointDef);
 
    PrismaticJointDef leftRearJointDef = new PrismaticJointDef();
    leftRearJointDef.initialize(body, leftRearWheel, leftRearWheel.getWorldCenter(), new Vec2(1,0));
    leftRearJointDef.enableLimit = true;
    leftRearJointDef.lowerTranslation = leftRearJointDef.upperTranslation = 0;
    
    PrismaticJointDef rightRearJointDef = new PrismaticJointDef();
    rightRearJointDef.initialize(body, rightRearWheel, rightRearWheel.getWorldCenter(), new Vec2(1,0));
    rightRearJointDef.enableLimit = true;
    rightRearJointDef.lowerTranslation = rightRearJointDef.upperTranslation = 0;
 
    box2d.createJoint(leftRearJointDef);
    box2d.createJoint(rightRearJointDef);
  }
}

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// A rectangular box
class CustomBoundary {

  // We need to keep track of a Body and a width and height
  Body body;
   
  // Constructor
  CustomBoundary(String bodystring) {
    // Add the box to the box2d world
    makeBody(bodystring);
  }

  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  public boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CORNER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0,0,0,50);
    stroke(0,0,0,0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  public void makeBody(String bodystring) {
   // int[] values = new int[7];
    String[] stringSegments = new String[2];
    stringSegments = bodystring.split(":");
    int numberOfVertices = PApplet.parseInt(stringSegments[0]);
    //println(str(numberOfVertices));
    String vertexString = stringSegments[1];
    String[] vertexStrings = new String[numberOfVertices];
    vertexStrings = trim(vertexString.split(","));
    //println(vertexStrings); 
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    Vec2[] vertices = new Vec2[numberOfVertices];


    for(int i = 0; i < numberOfVertices; i++){
      int[] myvertex = new int[2];
      myvertex = PApplet.parseInt(trim(vertexStrings[i].split("/")));
      //println(myvertex);
      vertices[i] = box2d.vectorPixelsToWorld(new Vec2(myvertex[0]*2,myvertex[1]*2));
    }

    sd.set(vertices, vertices.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(0,0));
    body = box2d.createBody(bd);

    body.createFixture(sd, 1.0f);

  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SurfaceRacer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
