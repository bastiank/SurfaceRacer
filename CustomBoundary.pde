// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// A rectangular box
class CustomBoundary {

  // We need to keep track of a Body and a width and height
  Body body;
   
  // Constructor
  CustomBoundary(String bodystring) {
    // Add the box to the box2d world
    makeBody(bodystring);
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
  void makeBody(String bodystring) {
   // int[] values = new int[7];
    String[] stringSegments = new String[2];
    stringSegments = bodystring.split(":");
    int numberOfVertices = int(stringSegments[0]);
    println(str(numberOfVertices));
    String vertexString = stringSegments[1];
    String[] vertexStrings = new String[numberOfVertices];
    vertexStrings = trim(vertexString.split(","));
    //println(vertexStrings); 
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    Vec2[] vertices = new Vec2[numberOfVertices];


    for(int i = 0; i < numberOfVertices; i++){
      int[] myvertex = new int[2];
      myvertex = int(trim(vertexStrings[i].split("/")));
      //println(myvertex);
      vertices[i] = box2d.vectorPixelsToWorld(new Vec2(myvertex[0]*2,myvertex[1]*2));
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

