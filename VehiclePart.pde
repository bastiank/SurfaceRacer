abstract class VehiclePart implements KeyListener{
  Body body;
  BodyDef bodyDef;
  VehiclePart parent;
  
  ArrayList<VehiclePart> parts = new ArrayList<VehiclePart>();
  
  public Vec2 start_position;
  public float start_orientation;
  
  PImage img;
  int width;
  int height;
  
  VehiclePart(Vec2 position, float orientation){
     start_position = position;
     start_orientation = orientation;
  }
  
  VehiclePart(Vec2 position){
    this(position,0);
  }
  
  void setImage(PImage img){
    this.img = img; 
    width = (int)(img.height*0.33);
    height = (int)(img.width*0.33);
    //width = (int)(img.height);
    //height = (int)(img.width);
  }
  
  void setImage(String img_path){
    setImage(loadImage(img_path));
  }
  
    float getAngle(){
    return body.getAngle();
  }
  
  Vec2 getPosition(){
    return box2d.getBodyPixelCoord(body);
  }
  
  void update(float interval){
    for(VehiclePart part: parts){
      part.update(interval);
    }
  }
  
  void attach(VehiclePart part){
    part.parent = this;
    parts.add(part);
  }
  
  synchronized void display(){
    for(VehiclePart part: parts){
      part.display();
    }
    draw();
  }
  
  void draw(){
    // We look at each body and get its screen position
    Vec2 pos =getPosition();
    // Get its angle of rotation

    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();

     
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    if(img == null){
      rotate(-a);
      fill(0);
      stroke(0);
      beginShape();
      // For every vertex, convert to pixel vector
      for (int i = 0; i < ps.getVertexCount(); i++) {
        Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
        vertex(v.x, v.y);
      }
      endShape(CLOSE);
    } else {
      rotate(-a+PI/2);
      scale (0.33);
      image(img,0-img.width/2,0-img.height/2);
    }
    /*pushStyle();
    fill(255,0,0);
    ellipse(0, 0, 5, 5);
    popStyle();*/
    popMatrix();  
  }
  
  void killBody() {
    box2d.destroyBody(body);
    for(VehiclePart part: parts){
      part.killBody();
    }
  }
  
  Vec2 getDirectionVector(){
    float a = body.getAngle();
    return new Vec2((float)-Math.sin(a),(float)Math.cos(a));
  }
  
  void keyPressed(KeyEvent e){
    for(VehiclePart part: parts){
       part.keyPressed(e);
     }
  }
  
  void keyReleased(KeyEvent e){
     for(VehiclePart part: parts){
       part.keyReleased(e);
     }
  } 
  
}
