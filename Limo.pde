
class Limo extends Vehicle {

  Limo(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
    if (styleVariant<0) styleVariant = int(random(4.));
    if (styleVariant==0) img=loadImage("Limousine-GTA1-ViceCity.png");
    if (styleVariant==1) img=loadImage("Limousine-GTA1-SanAndreas1.png");
    if (styleVariant==2) img=loadImage("Limousine-GTA1-SanAndreas2.png");
    if (styleVariant>2) img=loadImage("Limousine-GTA1-LibertyCity.png");
    
        carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-10));
    leftRearWheel.ground_friction = 1000;
    Wheel rightRearWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-10));
    rightRearWheel.ground_friction = 1000;
    Wheel leftWheel = new Wheel(carBody, new Vec2(-carBody.width/2,carBody.height/2-104));
    leftWheel.setMotorKeys(up,down);
    leftWheel.setSteeringKeys(left,right);
    leftWheel.ground_friction = 800;
    leftWheel.max_speed = 500;
    leftWheel.max_speed_backwards = 200;
    leftWheel.acceleration_speed = 70;
    
    Wheel rightWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-104));
    rightWheel.setMotorKeys(up,down);
    rightWheel.setSteeringKeys(left,right);
    rightWheel.ground_friction = 800;
    rightWheel.max_speed = 500;
    rightWheel.max_speed_backwards = 200;
    rightWheel.acceleration_speed = 70;
    return carBody;
  }
 
}

