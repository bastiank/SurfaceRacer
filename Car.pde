class Car {

  // We need to keep track of a Body and a width and height
  Body body;
  Body leftWheel;
  Body rightWheel;
  Body leftRearWheel;
  Body rightRearWheel;
  RevoluteJoint leftJoint;
  RevoluteJoint rightJoint;
  float engineSpeed = 0;
  float steeringAngle = 0;
  
  float HORSEPOWERS = 800;
  float MAX_STEER_ANGLE = PI/3;
  
  boolean accelerating = false;
  boolean decelerating = false;
  boolean turnleft = false;
  boolean turnright = false;
  
  
  
 PImage img;
 int carwidth = 0;
  // Constructor
  Car(float x, float y, float orientation, float w, float h, int styleVariant) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y),w,h);
    carwidth = int(w);
    if (styleVariant==0) img=loadImage("BeastGTS-GTA1.png");
    if (styleVariant==1) img=loadImage("Bulldog-GTA1.png");
    if (styleVariant==2) img=loadImage("Cossie-GTA1.png");
    if (styleVariant==3) img=loadImage("Speeder-GTA1.png");
    if (styleVariant==4) img=loadImage("SquadCar-GTA1-LibertyCity.png");
    if (styleVariant>4)  img=loadImage("Taxi-GTA1-LibertyCity.png");
  }
  float getSpeed(){
    return  body.getLinearVelocity().length();
  }
  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  Vec2 getDirectionVectorFromBody(Body b){
    float a = b.getAngle();
    //Vec2 lv = b.getLinearVelocity();
    Vec2 lv = new Vec2(0,1);
    
    double cs = Math.cos(a);
    double sn = Math.sin(a);
    
    double x = lv.x * cs - lv.y *sn;
    double y = lv.x*sn + lv.y * cs;
    if(lv.length() == 0) return new Vec2(0,0);
    return (new Vec2((float)(x/lv.length()),(float)(y/lv.length())));   
  }
  
  void update(){
    
    //println("speed: " + str(engineSpeed) + " / steering: " + str(steeringAngle));
    
    if(accelerating && engineSpeed < HORSEPOWERS)
      engineSpeed += 100;
    else if(!accelerating && engineSpeed > 0)
      engineSpeed -= 30;
      
    if(decelerating && engineSpeed > -HORSEPOWERS/2)
      engineSpeed -= 50;
    else if(!decelerating && engineSpeed < 0)
      engineSpeed += 30;

    if(turnleft && steeringAngle < (MAX_STEER_ANGLE))
      //println("left");
      steeringAngle += (PI/20);
    else if(!turnleft && !turnright)
      //println("leftstop");
      steeringAngle = 0;
      
    if(turnright && steeringAngle > -(MAX_STEER_ANGLE))
      //println("right");
      steeringAngle -= (PI/20);
    else if(!turnright && !turnleft)
      //println("rightstop");
      steeringAngle = 0;
    
    killOrthogonalVelocity(leftWheel);
    killOrthogonalVelocity(rightWheel);
    killOrthogonalVelocity(leftRearWheel);
    killOrthogonalVelocity(rightRearWheel);
    killOrthogonalVelocity(body);
    float STEER_SPEED = 1.5; 
    
    Vec2 ldirection = getDirectionVectorFromBody(leftWheel);
    Vec2 rdirection = getDirectionVectorFromBody(rightWheel);
    leftWheel.applyForce(new Vec2(ldirection.x*engineSpeed,ldirection.y*engineSpeed), leftWheel.getPosition());
    rightWheel.applyForce(new Vec2(rdirection.x*engineSpeed,rdirection.y*engineSpeed), rightWheel.getPosition());
 
    //Steering
    float mspeed = steeringAngle - leftJoint.getJointAngle();
    leftJoint.setMotorSpeed(mspeed * STEER_SPEED);
    //float mspeed = steeringAngle - rightJoint.getJointAngle();
    rightJoint.setMotorSpeed(mspeed * STEER_SPEED);
  }
  
  //This function applies a "friction" in a direction orthogonal to the body's axis.
  void killOrthogonalVelocity(Body targetBody){
    Vec2 localPoint = new Vec2(0,0);
    Vec2 velocity = targetBody.getLinearVelocityFromLocalPoint(localPoint);
    float a = targetBody.getAngle();
     
    Vec2 sidewaysAxis = new Vec2((float)-Math.sin(a),(float)Math.cos(a));
    
    float dp = sidewaysAxis.x*velocity.x + sidewaysAxis.y*velocity.y; 
    
 
     targetBody.setLinearVelocity(new Vec2(sidewaysAxis.x * dp,sidewaysAxis.y * dp));//targetBody.GetWorldPoint(localPoint));*/
  }

  // Drawing the box
  void display() {
    //displayBody(body);
    displayBody(rightWheel);
    displayBody(leftWheel);
    displayBody(rightRearWheel);
    displayBody(leftRearWheel);
    displayCar(body);
  }
  
  
  
  void displayCar(Body body){
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation

    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();

     
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a+PI/2);
    scale (0.35);
    image(img,0-img.width/2,0-img.height/2);
   
    popMatrix();
  }
  void displayBody(Body body){
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation

    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0);
    stroke(0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w, float h) {   
    Vec2 leftRearWheelPosition= new Vec2(center.x-w/2,center.x+h/2-10);
    Vec2 rightRearWheelPosition = new Vec2(center.x+w/2,center.x+h/2-10);
    Vec2 leftFrontWheelPosition= new Vec2(center.x-w/2,center.y-h/2+10);
    Vec2 rightFrontWheelPosition = new Vec2(center.x+w/2,center.y-h/2+10);
    
    // define our body
    BodyDef bodyDef = new BodyDef();
    bodyDef.type = BodyType.DYNAMIC;
    bodyDef.linearDamping = 1;
    bodyDef.angularDamping = 1;
    bodyDef.position.set(box2d.coordPixelsToWorld(center));
   
    body = box2d.createBody(bodyDef);
    //body.setMassFromShapes();

 
    BodyDef leftWheelDef = new BodyDef();
    leftWheelDef.type = BodyType.DYNAMIC;
    leftWheelDef.position.set(box2d.coordPixelsToWorld(leftFrontWheelPosition));
    leftWheel = box2d.createBody(leftWheelDef);
    
    BodyDef rightWheelDef = new BodyDef();
    rightWheelDef.type = BodyType.DYNAMIC;
    rightWheelDef.position.set(box2d.coordPixelsToWorld(rightFrontWheelPosition));
    rightWheel = box2d.createBody(rightWheelDef);
    
    BodyDef leftRearWheelDef = new BodyDef();
    leftRearWheelDef.type = BodyType.DYNAMIC;
    leftRearWheelDef.position.set(box2d.coordPixelsToWorld(leftRearWheelPosition));
    leftRearWheel = box2d.createBody(leftRearWheelDef);
    
    BodyDef rightRearWheelDef = new BodyDef();
    rightRearWheelDef.type = BodyType.DYNAMIC;
    rightRearWheelDef.position.set(box2d.coordPixelsToWorld(rightRearWheelPosition));
    rightRearWheel = box2d.createBody(rightRearWheelDef);   
    
    // define our shapes
    PolygonShape boxDef = new PolygonShape();
    FixtureDef boxFix = new FixtureDef();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    boxDef.setAsBox(box2dW,box2dH);
    boxFix.density = 1;
    boxFix.restitution = 0.5;
    boxFix.shape = boxDef;
    body.createFixture(boxFix);

    //Left Wheel shape
    PolygonShape leftWheelShapeDef = new PolygonShape();
    FixtureDef leftWheelShapeFix = new FixtureDef();
    leftWheelShapeDef.setAsBox(0.2,0.5);
    leftWheelShapeFix.density = 1;
    leftWheelShapeFix.shape = leftWheelShapeDef;
    leftWheel.createFixture(leftWheelShapeFix);
    
    //Right Wheel shape
    PolygonShape rightWheelShapeDef = new PolygonShape();
    FixtureDef rightWheelShapeFix = new FixtureDef();
    rightWheelShapeDef.setAsBox(0.2,0.5);
    rightWheelShapeFix.density = 1;
    rightWheelShapeFix.shape = rightWheelShapeDef;
    rightWheel.createFixture(rightWheelShapeFix);

    //Left Rear Wheel shape
    PolygonShape leftRearWheelShapeDef = new PolygonShape();
    FixtureDef leftRearWheelShapeFix = new FixtureDef();
    leftRearWheelShapeDef.setAsBox(0.2,0.5);
    leftRearWheelShapeFix.density = 1;
    leftRearWheelShapeFix.shape = leftRearWheelShapeDef;
    leftRearWheel.createFixture(leftRearWheelShapeFix);
    
    //Right Rear Wheel shape
    PolygonShape rightRearWheelShapeDef = new PolygonShape();
    FixtureDef rightRearWheelShapeFix = new FixtureDef();
    rightRearWheelShapeDef.setAsBox(0.2,0.5);
    rightRearWheelShapeFix.density = 1;
    rightRearWheelShapeFix.shape = rightRearWheelShapeDef;
    rightRearWheel.createFixture(rightRearWheelShapeFix); 
    
    
    RevoluteJointDef leftJointDef = new RevoluteJointDef();
    leftJointDef.initialize(body, leftWheel, leftWheel.getWorldCenter());
    leftJointDef.enableMotor = true;
    leftJointDef.maxMotorTorque = 100;
    
    RevoluteJointDef rightJointDef = new RevoluteJointDef();
    rightJointDef.initialize(body, rightWheel, rightWheel.getWorldCenter());
    rightJointDef.enableMotor = true;
    rightJointDef.maxMotorTorque = 100;
    //rightJointDef.setMotorSpeed(100);
 
    leftJoint = (RevoluteJoint) box2d.world.createJoint(leftJointDef);
    rightJoint= (RevoluteJoint) box2d.world.createJoint(rightJointDef);
 
    PrismaticJointDef leftRearJointDef = new PrismaticJointDef();
    leftRearJointDef.initialize(body, leftRearWheel, leftRearWheel.getWorldCenter(), new Vec2(1,0));
    leftRearJointDef.enableLimit = true;
    leftRearJointDef.lowerTranslation = leftRearJointDef.upperTranslation = 0;
    
    PrismaticJointDef rightRearJointDef = new PrismaticJointDef();
    rightRearJointDef.initialize(body, rightRearWheel, rightRearWheel.getWorldCenter(), new Vec2(1,0));
    rightRearJointDef.enableLimit = true;
    rightRearJointDef.lowerTranslation = rightRearJointDef.upperTranslation = 0;
 
    box2d.createJoint(leftRearJointDef);
    box2d.createJoint(rightRearJointDef);
  }
}

