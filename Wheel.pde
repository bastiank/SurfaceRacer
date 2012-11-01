class Wheel implements KeyListener{
  
  CarBody carBody;
  Vec2 start_position;
  Body body;
  BodyDef bodyDef;
  Joint joint;
  RevoluteJoint revoluteJoint;
  
  int accelerateKeyCode = -1;
  int decelerateKeyCode = -1;
  int steeringLeftKeyCode = -1;
  int steeringRightKeyCode = -1;
  
  float engineSpeed = 0;
  float steeringAngle = 0;
    
  //Config Values
  int max_speed = 800;
  int max_speed_backwards = 400;
  float maxSteerAngle = PI/7;
  float steeringAccelerationSpeed = (PI/5);
  float steerSpeed = 25;
  int acceleration_speed = 100;
  int deceleration_speed = 50;
  int ground_friction = 600;
  
  boolean accelerating = false;
  boolean decelerating = false;
  boolean turnleft = false;
  boolean turnright = false;
  
  Wheel(CarBody carBody, Vec2 position){
    this.carBody = carBody;
    this.start_position = position;
    makeBody();
  }
  
  void reset(){
    killBody();
    makeBody();
  }
  
  void makeBody(){
    bodyDef = new BodyDef();
    bodyDef.type = BodyType.DYNAMIC;
    bodyDef.position.set(box2d.coordPixelsToWorld(new Vec2(carBody.start_position.x+start_position.x,carBody.start_position.y+start_position.y)));
    body = box2d.createBody(bodyDef);
    
    //Left Rear Wheel shape
    PolygonShape bodyShapeDef = new PolygonShape();
    FixtureDef bodyShapeFix = new FixtureDef();
    bodyShapeDef.setAsBox(0.2,0.5);
    bodyShapeFix.density = 1;
    bodyShapeFix.shape = bodyShapeDef;
    body.createFixture(bodyShapeFix);
    makeStaticJoint();
  }
  
  void makeStaticJoint(){
    killJoint();
    PrismaticJointDef jointDef = new PrismaticJointDef();
    jointDef.initialize(carBody.body, body, body.getWorldCenter(), new Vec2(1,0));
    jointDef.enableLimit = true;
    jointDef.lowerTranslation = jointDef.upperTranslation = 0;

    joint= box2d.createJoint(jointDef);
  }
  
  void makeSteerableJoint(){
    killJoint();
    RevoluteJointDef jointDef = new RevoluteJointDef();
    jointDef.initialize(carBody.body, body, body.getWorldCenter());
    jointDef.enableMotor = true;
    jointDef.maxMotorTorque = 100;
 
    revoluteJoint = (RevoluteJoint) box2d.world.createJoint(jointDef);
    joint = revoluteJoint;
  }
  
  void killBody() {
    box2d.world.destroyBody(body);
  }  
  
  void killJoint(){
    if(joint != null) box2d.world.destroyJoint(joint);
  }
  
  void display(){
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
 
 Vec2 getDirectionVector(){
    float a = body.getAngle();
    return new Vec2((float)-Math.sin(a),(float)Math.cos(a));
  }
 
 void update(float interval){    
    if(accelerating && engineSpeed < max_speed)
      engineSpeed += acceleration_speed*interval*6;
    else if(!accelerating && engineSpeed > 0)
      engineSpeed = 0;
      
    if(decelerating && engineSpeed > -max_speed_backwards)
      engineSpeed -= deceleration_speed*interval*6;
    else if(!decelerating && engineSpeed < 0)
      engineSpeed = 0;
      
    if(turnleft && steeringAngle < (maxSteerAngle))
      steeringAngle += steeringAccelerationSpeed*interval*6;
    else if(!turnleft && !turnright)
      steeringAngle = 0;
        
    if(turnright && steeringAngle > -(maxSteerAngle))
      steeringAngle -= steeringAccelerationSpeed*interval*6;
    else if(!turnright && !turnleft)
      steeringAngle = 0;
      
    
    apply_ground_friction(interval);
    
    
    if(revoluteJoint != null){
    //Steering
      float mspeed = steeringAngle - revoluteJoint.getJointAngle();
      revoluteJoint.setMotorSpeed(mspeed * steerSpeed);
    }
    
    Vec2 directionVector = getDirectionVector();
    body.applyForce(new Vec2(directionVector.x*engineSpeed,directionVector.y*engineSpeed), body.getPosition());
  }
  
  void apply_ground_friction(float interval){
    Vec2 velocity = body.getLinearVelocity();
    float a = body.getAngle();
    Vec2 sidewaysAxis = new Vec2((float)Math.cos(a),(float)Math.sin(a));
    float dp = sidewaysAxis.x*velocity.x + sidewaysAxis.y*velocity.y; 
    body.applyForce(new Vec2(sidewaysAxis.x*ground_friction*interval*-dp,sidewaysAxis.y*ground_friction*interval*-dp), body.getPosition());
  }
  
  void setMotorKeys(int accelerateKeyCode, int decelerateKeyCode){
    this.accelerateKeyCode = accelerateKeyCode;
    this.decelerateKeyCode = decelerateKeyCode;
  }
  
  void setSteeringKeys(int steeringLeftKeyCode, int steeringRightKeyCode){
    makeSteerableJoint();
    this.steeringLeftKeyCode = steeringLeftKeyCode; 
    this.steeringRightKeyCode = steeringRightKeyCode;
  }
  
  void keyPressed(KeyEvent e){
    if(e.getKeyCode() == accelerateKeyCode) accelerating = true;
    if(e.getKeyCode() == decelerateKeyCode) decelerating = true;
    if(e.getKeyCode() == steeringLeftKeyCode) turnleft = true;
    if(e.getKeyCode() == steeringRightKeyCode) turnright = true;
  }
  
  void keyReleased(KeyEvent e){
    if(e.getKeyCode() == accelerateKeyCode) accelerating = false;
    if(e.getKeyCode() == decelerateKeyCode) decelerating = false;
    if(e.getKeyCode() == steeringLeftKeyCode)  turnleft = false;
    if(e.getKeyCode() == steeringRightKeyCode) turnright = false;
  }
  
}
