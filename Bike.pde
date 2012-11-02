
class Bike extends Vehicle {

  Bike(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
    //if (styleVariant<0) styleVariant = int(random(4.));
   img=loadImage("Bike-GTA1.png");
    
        carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(0,carBody.height/2-10));
    leftRearWheel.ground_friction = 1000;
    leftRearWheel.setMotorKeys(up,down);
    
    leftRearWheel.ground_friction = 800;
    leftRearWheel.max_speed = 500;
    leftRearWheel.max_speed_backwards = 200;
    leftRearWheel.acceleration_speed = 70;
    Wheel leftWheel = new Wheel(carBody, new Vec2(0,carBody.height/2-35));
    leftWheel.setSteeringKeys(left,right);
    
    return carBody;
  }
 
}

