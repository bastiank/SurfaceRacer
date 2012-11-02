
class Bus extends Vehicle {

  Bus(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
    if (styleVariant<0) styleVariant = int(random(4.));
    if (styleVariant==0) img=loadImage("Bus-GTA1-ViceCity.png");
    if (styleVariant==1) img=loadImage("Bus-GTA1-SanAndreas.png");
    if (styleVariant==2) img=loadImage("Coach-GTA1.png");
    if (styleVariant>2) img=loadImage("Bus-GTA1-LibertyCity.png");
    
        carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-20));
    leftRearWheel.ground_friction = 1000;
    leftRearWheel.setMotorKeys(up,down);
    leftRearWheel.max_speed = 600;
    leftRearWheel.max_speed_backwards = 200;
    leftRearWheel.acceleration_speed = 80;
    Wheel rightRearWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-20));
    rightRearWheel.ground_friction = 1000;
    rightRearWheel.setMotorKeys(up,down);
    rightRearWheel.max_speed = 600;
    rightRearWheel.max_speed_backwards = 200;
    rightRearWheel.acceleration_speed = 80;
    
    Wheel leftWheel = new Wheel(carBody, new Vec2(-carBody.width/2,carBody.height/2-104));
    leftWheel.setSteeringKeys(left,right);
    leftWheel.ground_friction = 2000;    
    Wheel rightWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-104));
    rightWheel.setSteeringKeys(left,right);
    rightWheel.ground_friction = 2000;

    return carBody;
  }
 
}

