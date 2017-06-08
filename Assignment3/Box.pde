class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  color col = 255;
  float rate = 0;


  // Constructor
  Box(float x_, float y_) {
    float x = x_;
    float y = y_;

    //w = random(25,150);
    //h = w;

    w = 40;
    h = 40;

    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);
    //box2d.setGravity(8.0,10.0);

    // "this" refers to this box object
    body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation

    globalX = pos.x;
    globalY = pos.y;

    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    rect(0, 0, w, h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }




  // Change color when hit
  void change() {
    Vec2 pos = box2d.getBodyPixelCoord(body);

    col = color(random(0, 255), random(0, 255), random(0, 255));
    println("hit_colChnage");

    rate();

    //pos.x = globalX;
    //pos.y = globalY;

    ////////////   Bottom Wall Sounds

    //play(rate,volume) <---- 

    if (pos.y>height-h-5 && pos.x > 0 && pos.x < width/2) {
      //Play the sound
      // bassFile[2].play(rate, 2);
      celloFile[0].play(rate, 1);

      println("Hit Bottom Wall Note1");
      println(pos.y);
      println(pos.x);
    } else 
    if (pos.y>height-h-5 && pos.x < width && pos.x > width/2) {
      //Play the sound
      //  bassFile[3].play(rate, 3);
      celloFile[3].play(rate, 1);
      println("Hit Bottom Wall Note2");
      println(pos.y);
      println(pos.x);
    }

    /////////////  Top Wall Sounds

    //    if (pos.y<0+h+3 && pos.x > 0 && pos.x < width/2) {
    //      //Play the sound
    //      drumsFile[1].play(rate, 0.5);
    //      println("Hit Top Wall Note1");
    //      println(pos.y);
    //      println(pos.x);
    //    } else 
    //    if (pos.y<0+h+3 && pos.x < width && pos.x > width/2) {
    //      //Play the sound
    //      drumsFile[2].play(rate, 0.5);
    //      println("Hit Top Wall Note2");
    //      println(pos.y);
    //      println(pos.x);
    //    }

    if (pos.y<0+h+3 && pos.x > 0 && pos.x < width/2) {
      //Play the sound
      vioFile[0].play(rate, 0.5);
      println("Hit Top Wall Note1");
      println(pos.y);
      println(pos.x);
    } else 
    if (pos.y<0+h+3 && pos.x < width && pos.x > width/2) {
      //Play the sound
      vioFile[1].play(rate, 0.5);
      println("Hit Top Wall Note2");
      println(pos.y);
      println(pos.x);
    }


    /////////////// Left Wall Sounds

    if (pos.x<0+w+3 && pos.y > 0 && pos.y < height/2) {
      //Play the sound
      gitFile[1].play(rate, 0.3);
      println("Hit Left Wall Note1");
      println(pos.y);
      println(pos.x);
    } else 
    if (pos.x<0+w+3 && pos.y < height && pos.y > height/2) {
      //Play the sound
      gitFile[2].play(rate, 0.3);
      println("Hit Left Wall Note2");
      println(pos.y);
      println(pos.x);
    }

    ///////////// Right Wall Sounds

    if (pos.x>width-w-5 && pos.y > 0 && pos.y < height/2) {
      //Play the sound
      symbFile[1].play(rate, 1);
      println("Right Bottom Wall Note1");
      println(pos.y);
      println(pos.x);
    } else 

    if (pos.x>width-w-5 && pos.y > 0 && pos.y > height/2) {
      //Play the sound
      symbFile[0].play(rate, 1);
      println("Right Bottom Wall Note1");
      println(pos.y);
      println(pos.x);
    } 

    //else {
    //  gongFile[1].play(rate, 1);
    //}
    //
  }

  ///////////////


  void rate()
  {
    rate = random(0.1, 1);
    // rate= 0.25;
  }

  void gong()
  {
    gongFile[1].play(rate, 0.5);
  }
}