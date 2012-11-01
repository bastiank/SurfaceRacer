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

boolean ctrl_pressed = false;

Minim       minim;
//Minim       minim2;
//AudioPlayer player;
AudioOutput out;
Oscil       wave;
Oscil       wave1;
OscP5 oscP5;
// A reference to our box2d world
PBox2D box2d;

int draw_rate = 1;

boolean muted = true;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectanglesd
ArrayList<Car> cars;
ArrayList<CustomBoundary> customBoundaries;
int borderspresent = 0;
PImage bg;
PImage goal;
Vec2 goalPosition =new Vec2(1760,100);//7
Boolean won = false;
int animationState = 0;
int animationCounter1 = 0;
int animationCounter2 = 0;
int animationCounter3 = 0;
int winner = 0;
boolean show_car_info = false;
PFont font;
PFont fps_font;

void setup() {
 size(displayWidth, displayHeight);
 frameRate(60);
  noStroke();
  smooth();
  //frameRate(120);
  //size(displayWidth, displayHeight);
  minim = new Minim(this);
  //minim2 = new Minim(this);
  //player = minim2.loadFile ("win.wav");

  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  wave = new Oscil( 40, 0, Waves.SAW );
  wave1 = new Oscil( 40, 0, Waves.SAW );
  // patch the Oscil to the output
  wave.patch( out );
  wave1.patch( out );
  //size(displayWidth, displayHeight);
  smooth();
  bg = loadImage("120799-2560x1600.jpg");
  goal=loadImage("goal.png");
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

  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  createCars();
  borderspresent = 1;
}

void destroyCars(){
  for(Car car: cars){
    car.killBody();
  }
  cars.clear();
}

void createCars(){
  destroyCars();
  int carstyle1 = 0;
  int carstyle2 = 0;
  while(carstyle1 == carstyle2){
  carstyle1 = int(random(40.));//*5);
  carstyle2 = int(random(40.));//*5);
  }
  cars.add(new Car(100,200,-PI/2,carstyle1,37,39,38,40));
  cars.add(new Car(displayWidth/2,displayWidth/2,0,carstyle2,65,68,87,83));
}

void display_car_info(Car car){
  textFont (createFont("Arial Bold",12));
  Vec2 car_pos = car.getPosition();
  float a = car.getAngle();
  Vec2 car_velocity = car.getLinearVelocity();
  text("("+(int)car_pos.x+","+(int)car_pos.y+")",car_pos.x+20,car_pos.y-20); 
  text("angle : "+a+"("+Math.toDegrees(a)+")",car_pos.x+20,car_pos.y-8); 
  text("speed : "+car_velocity.length(),car_pos.x+20,car_pos.y+2);
  //text("sidewaysAxis : "+new Vec2((float)-Math.sin(a),(float)Math.cos(a)),car_pos.x+20,car_pos.y+2);
}

synchronized void draw() {
  if(won){
    if (animationState == 0){
      image(bg,0,0);
      fill(0,animationCounter1); // use black with alpha 10
      rectMode(CORNER);
      rect(0,0,width,height);
      pushMatrix();
        translate(goalPosition.x,goalPosition.y);
        scale (.35);
        translate(goal.width/2, goal.height/2);
        rotate(animationCounter1/80.0*PI);
        image(goal,-goal.width/2, -goal.height/2);
      popMatrix();
      animationCounter1 = animationCounter1 + 20;
      if(animationCounter1 > 255){
        //player.play ();
        background(0);
        animationState = 1;
      }
    }
    if (animationState == 1){
      if(goalPosition.x  > width/2){ 
        textAlign(RIGHT);
        fill(255);
          textFont (createFont("Arial Bold",80));
        text("PLAYER "+str(winner)+" WINS!",goalPosition.x-20,goalPosition.y+75);
        fill(0,255-animationCounter2); // use black with alpha 10
        rectMode(CORNER);
        rect(goalPosition.x-1000,goalPosition.y,goalPosition.x,goalPosition.y+200);
      }
      else{
        textAlign(LEFT);
        fill(255);
          textFont (createFont("Arial Bold",80));
        text("PLAYER "+str(winner)+" WINS!",goalPosition.x+130,goalPosition.y+75);
        fill(0,255-animationCounter2); // use black with alpha 10
        rectMode(CORNER);
        rect(goalPosition.x+1000,goalPosition.y,goalPosition.x,goalPosition.y+200); 
      }
      pushMatrix();
        translate(goalPosition.x,goalPosition.y);
        scale (.35);
        translate(goal.width/2, goal.height/2);
        rotate(animationCounter1/80.0*PI);
        image(goal,-goal.width/2, -goal.height/2);
      popMatrix();
      animationCounter2 = animationCounter2 + 10;
      if(animationCounter2 > 255){
        animationState = 3;
      }
    }
    if (animationState == 3){
    
    }  
    if (animationState == 4){
      won = false;
      animationState = 0;
      animationCounter1 = 0;
      animationCounter2 = 0;
      animationCounter3 = 0;
      if(!muted){
        wave.setAmplitude(0.1);
        wave1.setAmplitude(0.1);
      }
      
      createCars();
      
    }
  }else{
    
    //println(cars.get(0).getSpeed());
wave.setFrequency(40+(int(cars.get(0).getSpeed()*1.5)));
wave1.setFrequency(40+(int(cars.get(1).getSpeed()*1.5)));
  // We must always step through time!
  
    float frame_render_time = 1/frameRate;
  
   box2d.world.step(frame_render_time,(int)(frame_render_time*120),(int)(frame_render_time*120));

  for (Car car: cars) {
    car.update(frame_render_time);
  }
  
  /*if(frameRate < 20){
    draw_rate++;
  }else if(frameRate >= 20 && draw_rate > 1){
    draw_rate--;
  }*/
  
  if(frameCount%draw_rate==0){ 
    //background(bg);
    image(bg, 0, 0); 
    //background(100);
    pushMatrix();
    translate(goalPosition.x,goalPosition.y);
    scale (0.35);
    image(goal,0,0);
    popMatrix();

  // Display all the people
  for (Car car: cars) {
    car.display();
    if(show_car_info){
      display_car_info(car);
    }
  }
  }
  for (int cc=0; cc<cars.size(); cc++) {
    float d = sqrt(pow(cars.get(cc).getPosition().x-(goalPosition.x+50),2) + pow(cars.get(cc).getPosition().y-(goalPosition.y+50),2));
    if(d < 30) {
      win(cc);
      wave.setAmplitude(0.0);
      wave1.setAmplitude(0.0);
    }
  
  }
  
  }
  
  textFont (createFont("Arial Bold",12));
  text(int(frameRate),20,30);
}

void win(int carNumber) {
 won = true;
 winner = carNumber+1;
}

boolean sketchFullScreen() {
  return true;
}

void keyPressed(KeyEvent e)
{ 
  int keyCode = e.getKeyCode();
  char key = e.getKeyChar();
  if(keyCode == 17) ctrl_pressed = true;
  if(!ctrl_pressed){
    if (won == false){
      for(Car car: cars){
        car.carBody.keyPressed(e);
      }
    }
    else{
      if(keyCode == 32){
        if (animationState == 3){
          animationState = 4;
        }
      }
    }
  }
}

void keyReleased(KeyEvent e)
{ 
  int keyCode = e.getKeyCode();
  char key = e.getKeyChar();
  println("Key "+key+" : "+keyCode);
  if(keyCode == 27) exit();
  if(keyCode == 17) ctrl_pressed = false;
  //Car currentCar = cars.get(0);
  //println(keyCode);
  if(ctrl_pressed){
    println("CTRL + "+keyCode);
       if(keyCode == KeyEvent.VK_I && !show_car_info){
        show_car_info = true;  
      }else if(keyCode == KeyEvent.VK_I && show_car_info){
        show_car_info = false; 
      }
      
       if(keyCode == KeyEvent.VK_M && !muted){
        wave.setAmplitude(0.0);
        wave1.setAmplitude(0.0);
        println("Muted");
        muted = true;  
      }else if(keyCode == KeyEvent.VK_M && muted){
        wave.setAmplitude(0.1);
        wave1.setAmplitude(0.1); 
       println("Unmuted"); 
        muted = false;
      }
  } else { 
    if (won == false){
      for(Car car: cars){
        car.carBody.keyReleased(e);
      }
      //reset cars
      if(keyCode == 49){
        //cars.get(0).reset();
      }
      if(keyCode == 50){
        //cars.get(1).reset();
      }
    }
  }
}

synchronized void oscEvent(OscMessage theOscMessage) { 
   borderspresent = 0;
   for (int i = customBoundaries.size()-1; i > 0; i--) {
   customBoundaries.get(i).killBody();
   customBoundaries.remove(i);
   } 
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
  goalPosition =new Vec2(mouseX-50,mouseY-50);
}


