//TODO: Lizenz einfuegen

//import all important imports
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
import org.newdawn.slick.geom.Polygon;

// Sound stuff
Minim       minim;
AudioOutput out;
Oscil       wave;
Oscil       wave1;
// An OSC listener to connect to the M$ Surface
OscP5 oscP5;
// A reference to our box2d world
PBox2D box2d;

int draw_rate = 1;

// A list for all of our outer boundaries
ArrayList<Boundary> boundaries;
// A list for all our polygon boundaries
ArrayList<CustomBoundary> customBoundaries;
// A list for all of our vehicles
ArrayList<Vehicle> vehicles;
// Background image
PImage bg;
// Goal graphic
PImage goal;
// Where is our goal?
Vec2 goalPosition =new Vec2(1760,100);
// Has anybody won THE GAME yet?
Boolean won = false;
// Several counters for the WIN animation
int animationState = 0;
int animationCounter1 = 0;
int animationCounter2 = 0;
int animationCounter3 = 0;
// Which player has won?
int winner = 0;
// Are there already borders?
int borderspresent = 0;
// Wanna have debug car infos displayed?
boolean show_car_info = true;
boolean ctrl_pressed = false;
// Is the sound muted?
boolean muted = true;
// Fonts for game infos
PFont font;
PFont fps_font;

void setup() {
  // Full size playfield
  size(displayWidth, displayHeight);
  // Set fixed framerate
  frameRate(60);
  noStroke();
  // Render it smoooooth!
  smooth();
  /*frameRate(120);
  size(displayWidth, displayHeight);*/
  
  // Our sound generator
  minim = new Minim(this);
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  // An oscillator for each car
  wave = new Oscil( 40, 0, Waves.SAW );
  wave1 = new Oscil( 40, 0, Waves.SAW );
  // patch the Oscil to the output
  wave.patch( out );
  wave1.patch( out );
  // Load background image 
  bg = loadImage("120799-2560x1600.jpg");
  // Load goal image
  goal=loadImage("goal.png");
  // Initialize OSC listener
  oscP5 = new OscP5(this,57120);
  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, 0);

  // Create ArrayLists  
  vehicles = new ArrayList<Vehicle>();
  boundaries = new ArrayList<Boundary>();
  customBoundaries = new ArrayList<CustomBoundary>();
  // Add outer boundaries to fixed boundaries array
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  // Create the cars
  createVehicles();
  // We has borders!
  borderspresent = 1;
}
 
void destroyVehicles(){
  // Iterate over all vehicles, kill their bodies and clear them
  for(Vehicle car: vehicles){
    car.killBody();
  }
  vehicles.clear();
}

void createVehicles(){
  // Avoid redundancies. Destroy all cars before creating new ones. Save the planet!
  destroyVehicles();
  // Create a random vehicle
  switch(int(random(6))){
    case 0:
      vehicles.add(new Bike(100,100,-PI/2,-1,37,39,38,40));
      break;  
    case 1:
      vehicles.add(new Car(100,100,-PI/2,-1,37,39,38,40));
      break;  
    case 2:
      vehicles.add(new Limo(100,100,-PI/2,-1,37,39,38,40));
      break;  
    case 3:
      vehicles.add(new Truck(100,100,-PI/2,-1,37,39,38,40));
      break;  
    case 4:
      vehicles.add(new Bus(100,100,-PI/2,-1,37,39,38,40));
      break;
    case 5:
      vehicles.add(new CarBack(100,100,-PI/2,-1,37,39,38,40));
      break;  
  }
  // Create another random vehicle
  switch(int(random(6))){
    case 0:
      vehicles.add(new Bike(displayWidth-100,displayHeight-100,PI/2,-1,65,68,87,83));
      break;  
    case 1:
      vehicles.add(new Car(displayWidth-100,displayHeight-100,PI/2,-1,65,68,87,83));
      break;  
    case 2:
      vehicles.add(new Limo(displayWidth-100,displayHeight-100,PI/2,-1,65,68,87,83));
      break;  
    case 3:
      vehicles.add(new Truck(displayWidth-100,displayHeight-100,PI/2,-1,65,68,87,83));
      break;  
    case 4:
      vehicles.add(new Bus(displayWidth-100,displayHeight-100,PI/2,-1,65,68,87,83));
      break;
    case 5:
      vehicles.add(new CarBack(displayWidth-100,displayHeight-100,PI/2,-1,65,68,87,83));
      break;  
  }
}

// Display the car info for each car right next to it
void display_car_info(Vehicle car){
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
  // Has anybody won the THE GAME?
  // If so, play the WIN animation 
  if(won){
    // The WIN animation is separated into different animation states
    // which follow each other. Each state ends if it's counter expires.
    if (animationState == 0){
      // state 0: fade the background to black... 
      image(bg,0,0);
      fill(0,animationCounter1);
      rectMode(CORNER);
      rect(0,0,width,height);
      //...and rotate the goal graphic
      pushMatrix();
        translate(goalPosition.x,goalPosition.y);
        scale (.35);
        translate(goal.width/2, goal.height/2);
        rotate(animationCounter1/80.0*PI);
        image(goal,-goal.width/2, -goal.height/2);
      popMatrix();
      animationCounter1 = animationCounter1 + 20;
      if(animationCounter1 > 255){
        background(0);
        animationState = 1;
      }
    }
    if (animationState == 1){
      // state 1: create the text and blend it in from black by using
      // a rectangle to cover it. if the goal marker is more to the right,
      // the text is drawn on it's left side and vice versa.
      if(goalPosition.x  > width/2){ 
        textAlign(RIGHT);
        fill(255);
        textFont (createFont("Arial Bold",80));
        text("PLAYER "+str(winner)+" WINS!",goalPosition.x-20,goalPosition.y+75);
        
        fill(0,255-animationCounter2);
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
      // Draw the goal image
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
      // In this state, we wait for the keypress that sets
      // The state to 4. While we wait, we can observe the 
      // impressive grahpical effects of the WIN animation
    }  
    if (animationState == 4){
      // Shut down the WIN animation in a professional fashion
      won = false;
      animationState = 0;
      animationCounter1 = 0;
      animationCounter2 = 0;
      animationCounter3 = 0;
      // Turn the vehicle sound back on if it is not muted
      if(!muted){
        wave.setAmplitude(0.1);
        wave1.setAmplitude(0.1);
      }
      // Now get me a new set of vehicles!
      createVehicles();
    }
 
  }else{    
    // Nobody has won yet, kust render the game.
    // Match the vehicle sound pitch to their speeds
    wave.setFrequency(40+(int(vehicles.get(0).getSpeed()*1.5)));
    wave1.setFrequency(40+(int(vehicles.get(1).getSpeed()*1.5)));
    // We must always step through time!
    float frame_render_time = 1/frameRate;
    box2d.world.step(frame_render_time,(int)(frame_render_time*120),(int)(frame_render_time*120));
    for (Vehicle car: vehicles) {
      car.update(frame_render_time);
    }
  
  /*if(frameRate < 20){
    draw_rate++;
  }else if(frameRate >= 20 && draw_rate > 1){
    draw_rate--;
  }*/
  
  if(frameCount%draw_rate==0){ 
    // Draw background
    image(bg, 0, 0); 
    // Draw scaled goal graphic
    pushMatrix();
    translate(goalPosition.x,goalPosition.y);
    scale (0.35);
    image(goal,0,0);
    popMatrix();

  // Display all the vehicles
  for (Vehicle car: vehicles) {
    car.display();
    // If flag set, show car info for debugging
    if(show_car_info){
      display_car_info(car);
    }
  }
  // Display polygon boundaries
  for (CustomBoundary cs: customBoundaries){
    cs.display();
  }

  }
  for(Vehicle vehicle: vehicles){
    // Check if any of the cars is at goal position and trigger WIN if true
    float d = sqrt(pow(vehicle.getPosition().x-(goalPosition.x+50),2) + pow(vehicle.getPosition().y-(goalPosition.y+50),2));
    if(d < 30) {
      win(vehicles.indexOf(vehicle));
    }
  }
  }
  // Display FPS
  textFont (createFont("Arial Bold",12));
  text(int(frameRate),20,30);
}

// If a player wins, mute vehicle sounds, initialize WIN animation
void win(int carNumber) {
 wave.setAmplitude(0.0);
 wave1.setAmplitude(0.0);
 won = true;
 winner = carNumber+1;
}

boolean sketchFullScreen() {
  return true;
}

// Scan keyboard and steer cars
void keyPressed(KeyEvent e)
{ 
  int keyCode = e.getKeyCode();
  char key = e.getKeyChar();
  if(keyCode == 17) ctrl_pressed = true;
  if(!ctrl_pressed){
    if (won == false){
      for(Vehicle car: vehicles){
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
  //Vehicle currentVehicle = vehicles.get(0);
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
      for(Vehicle car: vehicles){
        car.carBody.keyReleased(e);
      }
      //reset vehicles
      if(keyCode == 49){
        //vehicles.get(0).reset();
      }
      if(keyCode == 50){
        //vehiclesz.get(1).reset();
      }
    }
  }
}

synchronized void oscEvent(OscMessage theOscMessage) { 
  // If a new OSC Message is received, refresh all 
  // polygon boundaries after clearing the old ones. 
  borderspresent = 0;
  for (CustomBoundary cs: customBoundaries) {
    cs.killBody();
  } 
  customBoundaries.clear();
  print (customBoundaries);
  int counter = 0;
  String i = "fg";
  while(true){
    i = (theOscMessage.get(counter).stringValue());
    println (i);
    if (i.equals("END"))break;
    try{
       createCustomBoundariesFromString(i);
    }catch(Exception e){
    }
    counter ++;
  }
  print (customBoundaries);
  borderspresent = 1;
}

// Move goal position on mouse click
void mousePressed() {
  int x = (int)(mouseX/2);
  int y = (int)(mouseY/2);
  goalPosition =new Vec2(mouseX-50,mouseY-50);
  
}

 void createCustomBoundariesFromString(String bodystring){   
   // Parse an OSC message string, extract points and create
   // a polygon from it.  
    String[] stringSegments = new String[2];
    stringSegments = bodystring.split(":");
    int numberOfVertices = int(stringSegments[0]);
    //println(str(numberOfVertices));
    String vertexString = stringSegments[1];
    String[] vertexStrings = new String[numberOfVertices];
    vertexStrings = trim(vertexString.split(","));
    //println(vertexStrings); 
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    Vec2[] vertices = new Vec2[numberOfVertices];
    
    Polygon poly = new Polygon();

    for(int i = 0; i < numberOfVertices; i++){
      int[] myvertex = new int[2];
      myvertex = int(trim(vertexStrings[i].split("/")));
      //println(myvertex);
      poly.addPoint(myvertex[0]*2,myvertex[1]*2);
      //vertices[i] = box2d.vectorPixelsToWorld(new Vec2(myvertex[0]*2,myvertex[1]*2));
    }
    
    ArrayList<Polygon> convex_polys = ShapeUtil.makeConvex(poly);

    for(Polygon convex_poly: convex_polys){
       CustomBoundary cs = new CustomBoundary(convex_poly);
       customBoundaries.add(cs);   
    }
    

  } 


