class Car {

  // We need to keep track of a Body and a width and height
  Body body;

  // Constructor
  Car(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  /*boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }*/

  
 void update(){
   float a = body.getAngle();
    
   float l = body.getLinearVelocity().length();
   double x =  -l * Math.sin(a);
   double y =  l * Math.cos(a);
   body.setLinearVelocity(new Vec2((float)x,(float)y))  ; 
 } 

  // Drawing the box
  void display() {
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
    fill(175);
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
  void makeBody(Vec2 center) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();

    Vec2[] vertices = new Vec2[4];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(0,0));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(0, 20));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(10, 20));
    vertices[3] = box2d.vectorPixelsToWorld(new Vec2(10, 0));

    sd.set(vertices, vertices.length);
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    FixtureDef fixDef = new FixtureDef();
    //fixDef.density = 1.0;
    //fixDef.restitution = 2.0;
    //fixDef.friction = 0.0;
    //fixDef.shape = sd;
    
    body.createFixture(sd,1.0);


    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(0,0));
    body.setAngularVelocity(0);
  }
  
  void accelerate(float v){
    //body.applyImpulse(new Vec2(0.5,0),)
    float l = body.getLinearVelocity().length() +v;
    float a =  body.getAngle();
    double x =  -l * Math.sin(a);
    double y =  l * Math.cos(a);
    body.setLinearVelocity(new Vec2((float)x,(float)y))  ;
  }
  
  void turn(float a){
    //float currentAV = body.getAngularVelocity();
    //float newAV =currentAV + a;
    body.applyTorque(a);
 
  }
  
}

