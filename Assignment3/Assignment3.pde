import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

//import GUI lib
import controlP5.*; 

// importing minim
import ddf.minim.*;


/// Importing sound lib
import processing.sound.*;
AudioDevice device;
SoundFile[] bassFile;
SoundFile[] drumsFile;
SoundFile[] gitFile;
SoundFile[] symbFile;
SoundFile[] gongFile;
SoundFile[] celloFile;
SoundFile[] vioFile;


// A reference to box2d world
Box2DProcessing box2d;

// A list used to track fixed objects
ArrayList boundaries;

ArrayList sections;

// Just a single box this time
Box box;
Box box2;

// gui 
ControlP5 cp5;

// The Spring that will attach to the box from the mouse
Spring spring;

// counts the amount of no hits
int NoHitCount =0;

// Current note in list
int currentNote = 0;

float globalX;
float globalY;

float bGroundCol = 0;
boolean drawOn = false; 


float z = 0; //  noise value for noise background

PImage splashScreen;
boolean splashOn = true;

void setup() {
  size(600, 400, P2D);
//fullScreen(P2D); // very slow :( 
  smooth();

  // set up splash screen
  splashScreen = loadImage("splashScreen.jpg");

  if (splashOn)
  {
    image(splashScreen, 0, 0);
  }



  //set up gui 
  cp5 = new ControlP5(this);
  Button b = cp5.addButton("Background");


  // create button

  b.setValue(0);
  b.setPosition(0, 0);
  b.setSize(60, 15);
  b.setColorBackground(0);
  b.setColorLabel(255);

  // Loading sound files from data folder
  device = new AudioDevice(this, 48000, 32);

  bassFile = new SoundFile[5];
  drumsFile = new SoundFile[5];
  gitFile = new SoundFile[5];
  symbFile = new SoundFile[3];
  gongFile = new SoundFile[2];
  celloFile = new SoundFile[5];
  vioFile = new SoundFile[2];


  /////////////// Load Sound Files 

  // Load 5 soundfiles from a folder in a for loop. 
  for (int i = 0; i < bassFile.length; i++) {
    bassFile[i] = new SoundFile(this, "bass"+(i+1) + ".wav");
    currentNote = i;
  }


  for (int i = 0; i < drumsFile.length; i++) {
    drumsFile[i] = new SoundFile(this, "drums"+(i+1) + ".wav");
    currentNote = i;
  }

  for (int i = 0; i < gitFile.length; i++) {
    gitFile[i] = new SoundFile(this, "git"+(i+1) + ".wav");
    currentNote = i;
  }

  for (int i = 0; i < symbFile.length; i++) {
    symbFile[i] = new SoundFile(this, "symb"+(i+1) + ".wav");
    currentNote = i;
  }

  for (int i = 0; i < gongFile.length; i++) {
    gongFile[i] = new SoundFile(this, "gong"+(i+1) + ".wav");
    currentNote = i;
  }

  for (int i = 0; i < celloFile.length; i++) {
    celloFile[i] = new SoundFile(this, "cello"+(i+1) + ".wav");
    currentNote = i;
  }
  for (int i = 0; i < vioFile.length; i++) {
    vioFile[i] = new SoundFile(this, "vio"+(i+1) + ".wav");
    currentNote = i;
  }

  //////////////




  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, -10);


  // Turn on collision listening!
  box2d.listenForCollisions();


  // boxes = new ArrayList<Box>();


  // Make the box
  box = new Box(width/2, height/2);
  box2 = new Box(width/1.5, height/1.5);


  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();

  // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2, height-5, width, 10, 0));
  boundaries.add(new Boundary(width/2, 5, width, 10, 0));
  boundaries.add(new Boundary(width-5, height/2, 10, height, 0));
  boundaries.add(new Boundary(5, height/2, 10, height, 0));
}



// When the mouse is released we're done with the spring
void mouseReleased() {
  spring.destroy();
}

// When the mouse is pressed we. . .
void mousePressed() {
  
  if(splashOn == true)
  {
    splashOn = false;
  }
  
  // Check to see if the mouse was clicked on the box
  if (box.contains(mouseX, mouseY)) {
    // And if so, bind the mouse location to the box with a spring
    spring.bind(mouseX, mouseY, box);
  }

  if (box2.contains(mouseX, mouseY)) {
    // And if so, bind the mouse location to the box with a spring
    spring.bind(mouseX, mouseY, box2);
  }
}



void draw() {

  if (splashOn == false) {

    backgroundDraw();

    // We must always step through time!
    box2d.step();

    // Always alert the spring to the new mouse location
    spring.update(mouseX, mouseY);


    ////////////////////// Noise Background ////////////
    noStroke();
    // fill(0, 10);
    //  rect(width/2, height/2, height, width);

    stroke(255, 100);
    // float y = 0; creates decimal variable y and assigns value 0 to it
    // loop repeats as long as y < height; is true
    // y = y + 20 increments y in the end of each iteration.
    for (float y = 0; y < height; y = y + 20) {
      // float x = 0; creates decimal variable x and assigns value 0 to it
      // loop repeats as long as x < width; is true
      // x = x + 1 increments the x in the end of each iteration.
      for (float x = 0; x < width; x = x + 1) {
        point(x, y + map(noise(x/150, y/150, z), 0, 1, -100, 100));
      }
    }
    // when y is 500 the program will move forward. In this case increment z
    z = z + 0.02;


    /////////////////////////////////////////


    // Draw the boundaries
    for (int i = 0; i < boundaries.size(); i++) {
      Boundary wall = (Boundary) boundaries.get(i);
      wall.display();
    }

    // Draw the box
    box.display();
    box2.display();

    // Draw the spring (it only appears when active)
    spring.display();
  }
}

// Collision event functions!
void beginContact(Contact cp) {

  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  println("Object1 = " + o1);
  println("Object2 = " + o2);

  Box p1 = (Box) b1.getUserData();


  if (o1.getClass() == Box.class && o2.getClass() == Box.class) {
    println("Box Collision");
    p1.gong();
    box2d.setGravity(random(-20, 20), random(-20, 20));
    //bGroundCol = 255;
    //p1.col = 0;
  }
  if (o2.getClass() == Boundary.class) {

    p1.change();
    println("Object1 = " + o1);
    println("Object2 = " + o2);
  }
}

// Objects stop touching each other
void endContact(Contact cp) {

  NoHitCount++;
  Fixture f1 = cp.getFixtureA();
  Body b1 = f1.getBody();
  //Box p1 = (Box) b1.getUserData();

  println("No contact "+NoHitCount);
}

public void Background() {
  drawOn = !drawOn;
}

void backgroundDraw() {
  if (drawOn) {
    background(bGroundCol);
  } else
    return;
}