
class CarBack extends Vehicle {
  
  CarBack(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
    if (styleVariant<0) styleVariant = int(random(14.));
    if (styleVariant==0) img=loadImage("BeastGTS-GTA1.png");
    if (styleVariant==1) img=loadImage("Challenger-GTA1.png");
    if (styleVariant==2) img=loadImage("Cossie-GTA1.png");
    if (styleVariant==3) img=loadImage("Counthash-GTA1.png");
    if (styleVariant==4) img=loadImage("F-19-GTA1.png");
    if (styleVariant==5) img=loadImage("Flamer-GTA1.png");
    if (styleVariant==6) img=loadImage("Hotrod-GTA1.png");
    if (styleVariant==7) img=loadImage("Jugular-GTA1.png");
    if (styleVariant==8) img=loadImage("Panther-GTA1.png");
    if (styleVariant==9) img=loadImage("Penetrator-GTA1-SanAndreas&ViceCity.png");
    if (styleVariant==10) img=loadImage("Speeder-GTA1.png");
    if (styleVariant==11) img=loadImage("Stallion-GTA1.png");
    if (styleVariant==12) img=loadImage("Stinger-GTA1.png");
    if (styleVariant==13) img=loadImage("StingerZ29-GTA1.png");
    if (styleVariant>13) img=loadImage("Thunderhead-GTA1.png");
    
    carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-10));
    leftRearWheel.setMotorKeys(up,down);
    Wheel rightRearWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-10));
    rightRearWheel.setMotorKeys(up,down);
    Wheel leftWheel = new Wheel(carBody, new Vec2(-carBody.width/2,carBody.height/2-48));
    
    leftWheel.setSteeringKeys(left,right);
    leftWheel.ground_friction = 800;
    Wheel rightWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-48));
    
    rightWheel.setSteeringKeys(left,right);
    rightWheel.ground_friction = 800;
    return carBody;
  }
 
}

