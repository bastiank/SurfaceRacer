// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// A rectangular box

import org.newdawn.slick.geom.Polygon;
class CustomBoundary {

  // We need to keep track of a Body and a width and height
  Body body;
   
  // Constructor
  CustomBoundary(Polygon poly) {
    // Add the box to the box2d world
    makeBody(poly);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CORNER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0,0,0,50);
    stroke(0,0,0,0);
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
  void makeBody(Polygon poly) {
    poly.setClosed(true);
    PolygonShape sd = new PolygonShape();
    int numberOfVertices = poly.getPointCount();
    Vec2[] vertices = new Vec2[poly.getPointCount()];


    for(int i = 0; i < numberOfVertices; i++){
      vertices[i] = box2d.vectorPixelsToWorld(new Vec2(poly.getPoint(i)[0],poly.getPoint(i)[1]));
    }

    sd.set(vertices, vertices.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(0,0));
    body = box2d.createBody(bd);

    body.createFixture(sd, 1.0);

  }
}


