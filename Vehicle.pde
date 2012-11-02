abstract class Vehicle{
  
  VehiclePart carBody;
  float x;
  float y;
  float orientation;
  int styleVariant;
  int left;
  int right;
  int up;
  int down;

  // Constructor
  Vehicle(float x, float y, float orientation, int styleVariant, int left, int right, int up, int down) {
    this.x = x;
    this.y = y;
    this.orientation = orientation;
    this.styleVariant = styleVariant;
    this.left = left;
    this.right = right;
    this.up = up;
    this.down =down;
    carBody = buildVehicle();
  }
  
  abstract VehiclePart buildVehicle();
  
  float getSpeed(){
    return  carBody.body.getLinearVelocity().length();
  }
  // This function removes the particle from the box2d world
  void killBody() {
    carBody.killBody();
  }
  
  
  void update(float interval){
    carBody.update(interval);
  }
  
  //This function applies a "friction" in a direction orthogonal to the body's axis.
  /*void killOrthogonalVelocity(Body targetBody){
    Vec2 velocity = targetBody.getLinearVelocity();
    Vec2 sidewaysAxis = getDirectionVectorFromBody(targetBody);
    float dp = sidewaysAxis.x*velocity.x + sidewaysAxis.y*velocity.y; 
    targetBody.setLinearVelocity(new Vec2(sidewaysAxis.x * dp,sidewaysAxis.y * dp));//targetBody.GetWorldPoint(localPoint));
  }*/

  // Drawing the box
  synchronized void display() {
    carBody.display();
  }
  
  Vec2 getPosition(){
    return carBody.getPosition();
  }
  
  float getAngle(){
    return carBody.getAngle();
  }
  
  Vec2 getLinearVelocity(){
    return carBody.body.getLinearVelocity();
  }
}
