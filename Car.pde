
class Car extends Vehicle {
  
  Car(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
 if (styleVariant<0) styleVariant = int(random(26.));
    if (styleVariant==0) img=loadImage("4x4-GTA1.png");
    if (styleVariant==1) img=loadImage("Brigham-GTA1.png");
    if (styleVariant==2) img=loadImage("Bug-GTA1.png");
    if (styleVariant==3) img=loadImage("Bulldog-GTA1.png");
    if (styleVariant==6) img=loadImage("Impaler-GTA1.png");
    if (styleVariant==7) img=loadImage("Itali-GTA1.png");
    if (styleVariant==8) img=loadImage("ItaliGTB-GTA1.png");
    if (styleVariant==9) img=loadImage("LeBonham-GTA1.png");
    if (styleVariant==10) img=loadImage("Mamba-GTA1.png");
    if (styleVariant==11) img=loadImage("Mundano-GTA1.png");
    if (styleVariant==12) img=loadImage("Penetrator-GTA1-LibertyCity.png");
    if (styleVariant==13) img=loadImage("Pickup-GTA1-LibertyCity.png");
    if (styleVariant==14) img=loadImage("Pickup-GTA1-SanAndreas&ViceCity.png");
    if (styleVariant==15) img=loadImage("Porka-GTA1.png");
    if (styleVariant==16) img=loadImage("PorkaTurbo-GTA1.png");
    if (styleVariant==17) img=loadImage("Portsmouth-GTA1.png");
    if (styleVariant==18) img=loadImage("Regal-GTA1.png");
    if (styleVariant==19) img=loadImage("RepairVan-GTA1.png");
    if (styleVariant==20) img=loadImage("Roadster-GTA1.png");
    if (styleVariant==21) img=loadImage("SquadCar-GTA1-LibertyCity.png");
    if (styleVariant==22) img=loadImage("SquadCar-GTA1-SanAndreas.png");
    if (styleVariant==23) img=loadImage("Taxi-GTA1-LibertyCity.png");
    if (styleVariant==24) img=loadImage("Taxi-GTA1-SanAndreas.png");
    if (styleVariant==25) img=loadImage("TVVan-GTA1-LibertyCity.png");
    if (styleVariant>25) img=loadImage("Vulture-GTA1.png");
    
    carBody = new CarBody(img, new Vec2(x,y), orientation);
    
    Wheel leftRearWheel = new Wheel(carBody,new Vec2(-carBody.width/2,carBody.height/2-10));
    
    Wheel rightRearWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-10));
  
    Wheel leftWheel = new Wheel(carBody, new Vec2(-carBody.width/2,carBody.height/2-48));
    leftWheel.setMotorKeys(up,down);
    leftWheel.setSteeringKeys(left,right);
    
    Wheel rightWheel = new Wheel(carBody,new Vec2(carBody.width/2,carBody.height/2-48));
    rightWheel.setMotorKeys(up,down);
    rightWheel.setSteeringKeys(left,right);
    return carBody;
  }
 
}

