
class Car {

  // We need to keep track of a Body and a width and height
  
  CarBody carBody;
  
  Body leftWheel;
  Body rightWheel;
  Body leftRearWheel;
  Body rightRearWheel;
  RevoluteJoint leftJoint;
  RevoluteJoint rightJoint;
  float engineSpeed = 0;
  float steeringAngle = 0;
  
  //Config Values
  int max_speed = 800;
  int max_speed_backwards = 400;
  float MAX_STEER_ANGLE = PI/7;
  int carwidth = 0;
  int carheight = 0;
  float steering_acceleration_speed = (PI/5);
  float STEER_SPEED = 25;
  int acceleration_speed = 100;
  int deceleration_speed = 50;
  int ground_friction = 600;
  
  boolean accelerating = false;
  boolean decelerating = false;
  boolean turnleft = false;
  boolean turnright = false;
  

 Vec2 carStartPos;
  // Constructor
  Car(float x, float y, float orientation, int styleVariant,int left, int right, int up, int down) {
    // Add the box to the box2d world
    PImage img = new PImage();
    
    if (styleVariant==0) img=loadImage("4x4-GTA1.png");
    if (styleVariant==1) img=loadImage("BeastGTS-GTA1.png");
    if (styleVariant==2) img=loadImage("Brigham-GTA1.png");
    if (styleVariant==3) img=loadImage("Bug-GTA1.png");
    if (styleVariant==4) img=loadImage("Bulldog-GTA1.png");
    if (styleVariant==5) img=loadImage("Challenger-GTA1.png");
    if (styleVariant==6) img=loadImage("Cossie-GTA1.png");
    if (styleVariant==7) img=loadImage("Counthash-GTA1.png");
    if (styleVariant==8) img=loadImage("F-19-GTA1.png");
    if (styleVariant==9) img=loadImage("Flamer-GTA1.png");
    if (styleVariant==10) img=loadImage("goal.png");
    if (styleVariant==11) img=loadImage("Hotrod-GTA1.png");
    if (styleVariant==12) img=loadImage("Impaler-GTA1.png");
    if (styleVariant==13) img=loadImage("Itali-GTA1.png");
    if (styleVariant==14) img=loadImage("ItaliGTB-GTA1.png");
    if (styleVariant==15) img=loadImage("Jugular-GTA1.png");
    if (styleVariant==16) img=loadImage("LeBonham-GTA1.png");
    if (styleVariant==17) img=loadImage("Mamba-GTA1.png");
    if (styleVariant==18) img=loadImage("Mundano-GTA1.png");
    if (styleVariant==19) img=loadImage("Panther-GTA1.png");
    if (styleVariant==20) img=loadImage("Penetrator-GTA1-LibertyCity.png");
    if (styleVariant==21) img=loadImage("Penetrator-GTA1-SanAndreas&ViceCity.png");
    if (styleVariant==22) img=loadImage("Pickup-GTA1-LibertyCity.png");
    if (styleVariant==23) img=loadImage("Pickup-GTA1-SanAndreas&ViceCity.png");
    if (styleVariant==24) img=loadImage("Porka-GTA1.png");
    if (styleVariant==25) img=loadImage("PorkaTurbo-GTA1.png");
    if (styleVariant==26) img=loadImage("Portsmouth-GTA1.png");
    if (styleVariant==27) img=loadImage("Regal-GTA1.png");
    if (styleVariant==28) img=loadImage("RepairVan-GTA1.png");
    if (styleVariant==29) img=loadImage("Roadster-GTA1.png");
    if (styleVariant==30) img=loadImage("Speeder-GTA1.png");
    if (styleVariant==31) img=loadImage("SquadCar-GTA1-LibertyCity.png");
    if (styleVariant==32) img=loadImage("SquadCar-GTA1-SanAndreas.png");
    if (styleVariant==33) img=loadImage("Stallion-GTA1.png");
    if (styleVariant==34) img=loadImage("Stinger-GTA1.png");
    if (styleVariant==35) img=loadImage("StingerZ29-GTA1.png");
    if (styleVariant==36) img=loadImage("Taxi-GTA1-LibertyCity.png");
    if (styleVariant==37) img=loadImage("Taxi-GTA1-SanAndreas.png");
    if (styleVariant==38) img=loadImage("Thunderhead-GTA1.png");
    if (styleVariant==39) img=loadImage("TVVan-GTA1-LibertyCity.png");
    if (styleVariant>39) img=loadImage("Vulture-GTA1.png");
    
    carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-10));
    carBody.wheels.add(leftRearWheel);
    
    Wheel rightRearWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-10));
    carBody.wheels.add(rightRearWheel);
  
    Wheel leftWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-48));
    leftWheel.setMotorKeys(up,down);
    leftWheel.setSteeringKeys(left,right);
    carBody.wheels.add(leftWheel);
    
    Wheel rightWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-48));
    rightWheel.setMotorKeys(up,down);
    rightWheel.setSteeringKeys(left,right);
    carBody.wheels.add(rightWheel);
    
    //leftRearWheel.setMotorKeys(84,71);
    //leftRearWheel.setSteeringKeys(90,72);
    //rightRearWheel.setMotorKeys(90,72);
    
    makeBody();
    //carStartPos = new Vec2(x, y);
    //body.setTransform(body.getPosition(), orientation);
  }
  
  float getSpeed(){
    return  carBody.body.getLinearVelocity().length();
  }
  // This function removes the particle from the box2d world
  void killBody() {
    carBody.killBody();
  }
  
  
  void update(float interval){
    carBody.update(interval);
  }
  
  //This function applies a "friction" in a direction orthogonal to the body's axis.
  /*void killOrthogonalVelocity(Body targetBody){
    Vec2 velocity = targetBody.getLinearVelocity();
    Vec2 sidewaysAxis = getDirectionVectorFromBody(targetBody);
    float dp = sidewaysAxis.x*velocity.x + sidewaysAxis.y*velocity.y; 
    targetBody.setLinearVelocity(new Vec2(sidewaysAxis.x * dp,sidewaysAxis.y * dp));//targetBody.GetWorldPoint(localPoint));
  }*/

  // Drawing the box
  synchronized void display() {
    carBody.display();
  }
  
  Vec2 getPosition(){
    return box2d.getBodyPixelCoord(carBody.body);
  }
  
  float getAngle(){
    return carBody.body.getAngle();
  }
  
  Vec2 getLinearVelocity(){
    return carBody.body.getLinearVelocity();
  }
  
  // This function adds the rectangle to the box2d world
  void makeBody() { 
   
  }
}

