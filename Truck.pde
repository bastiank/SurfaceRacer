
class Truck extends Vehicle {

  Truck(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
    
    //if (styleVariant>0) img=loadImage("Juggernaut-GTA1.png");
    img=loadImage("Juggernaut-GTA1.png");
    CarBody carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-6));
    leftRearWheel.setMotorKeys(up,down);
    leftRearWheel.ground_friction = 2000;
    leftRearWheel.max_speed = 500;
    leftRearWheel.max_speed_backwards = 200;
    leftRearWheel.acceleration_speed = 70;
    Wheel rightRearWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-6));
    rightRearWheel.setMotorKeys(up,down);
    rightRearWheel.ground_friction = 2000;
    rightRearWheel.max_speed = 500;
    rightRearWheel.max_speed_backwards = 200;
    rightRearWheel.acceleration_speed = 70;
    
    Wheel leftMiddleWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-20));
    leftMiddleWheel.setMotorKeys(up,down);
    leftMiddleWheel.ground_friction = 2000;
    leftMiddleWheel.max_speed = 500;
    leftMiddleWheel.max_speed_backwards = 200;
    leftMiddleWheel.acceleration_speed = 70;
    Wheel rightMiddleWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-20));
    rightMiddleWheel.setMotorKeys(up,down);
    rightMiddleWheel.ground_friction = 2000;
    rightMiddleWheel.max_speed = 500;
    rightMiddleWheel.max_speed_backwards = 200;
    rightMiddleWheel.acceleration_speed = 70;
   
    Wheel leftWheel = new Wheel(carBody, new Vec2(-carBody.width/2+3,carBody.height/2-80));
    leftWheel.setSteeringKeys(left,right);
    leftWheel.ground_friction = 2000;
    Wheel rightWheel = new Wheel(carBody,new Vec2(carBody.width/2-3,carBody.height/2-80));
    rightWheel.setSteeringKeys(left,right);
    rightWheel.ground_friction = 2000;
    return carBody;
  }
 
}

