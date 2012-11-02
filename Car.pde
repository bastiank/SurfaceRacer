
class Car extends Vehicle {
  
  Car(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    super( x,  y, orientation,  styleVariant, left,  right,  up,  down); 
  }
  
  VehiclePart buildVehicle() {
    // Add the box to the box2d world
    PImage img = new PImage();
    if (styleVariant<0) styleVariant = int(random(40.));
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

