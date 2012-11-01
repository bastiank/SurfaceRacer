class CarBody  implements KeyListener{

  Body body;
  PImage img;
  int width;
  int height;
  BodyDef bodyDef;
  Vec2 start_position;
  float start_orientation;
  ArrayList<Wheel> wheels = new ArrayList<Wheel>();
  
  CarBody(PImage img, Vec2 position, float orientation){
    this.img = img; 
    width = (int)(img.height*0.33);
    height = (int)(img.width*0.33);
    start_position = position;
    start_orientation = orientation;
    makeBody();
  }
  
  CarBody(String img, Vec2 position, float orientation){
    this(loadImage(img), position, orientation);
  }
  
  void makeBody(){
    if(body != null) killBody();
    // define our body
    bodyDef = new BodyDef();
    bodyDef.type = BodyType.DYNAMIC;
    bodyDef.linearDamping = 1;
    bodyDef.angularDamping = 1;
    bodyDef.position.set(box2d.coordPixelsToWorld(start_position));
    bodyDef.angle = start_orientation;
    //bodyDef.angle = start_orientation;
   
    body = box2d.createBody(bodyDef);
  
    // define our shapes
    PolygonShape boxDef = new PolygonShape();
    FixtureDef boxFix = new FixtureDef();
    float box2dW = box2d.scalarPixelsToWorld(width/2);
    float box2dH = box2d.scalarPixelsToWorld(height/2);
    boxDef.setAsBox(box2dW,box2dH);
    boxFix.density = 1;
    boxFix.restitution = 0.5;
    boxFix.shape = boxDef;
    body.createFixture(boxFix); 
  }
  
  float getAngle(){
    return body.getAngle();
  }
  
  Vec2 getPosition(){
    return box2d.getBodyPixelCoord(body);
  }
  
  void update(float interval){
    for(Wheel wheel: wheels){
      wheel.update(interval);
    }
  }
  
  synchronized void display(){
    for(Wheel wheel: wheels){
      wheel.display();
    }
    
    // We look at each body and get its screen position
    Vec2 pos =getPosition();
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
  
  void killBody() {
    box2d.destroyBody(body);
    for(Wheel wheel: wheels){
      wheel.killBody();
    }
  } 
 
   void keyPressed(KeyEvent e){
     for(Wheel wheel: wheels){
       wheel.keyPressed(e);
     }
  }
  
  void keyReleased(KeyEvent e){
    for(Wheel wheel: wheels){
       wheel.keyReleased(e);
     }
  } 

}
