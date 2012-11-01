class CarBody extends VehiclePart{
  
  CarBody(PImage img, Vec2 position, float orientation){
    super(position,orientation);
    setImage(img); 
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


}
