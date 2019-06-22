/*
|
|    Name: Alex Penny
|    Assignment: 4
|    Class: COMP 3490
|    Instructor: John Braico
|    Purpose: Draw museum with visitors and over the shoulder camera
|
|    ACKNOWLEDGEMENTS: Thank you Vecteezy.com and Freepik.com. 
|    Their images are free to use, but require attribution of that sort.
|
*/
int[] position = { 0, 0, 0 };
int[][] obstaclePositions = {{2, 0, 2}, //All exhibits and visitors
{-2, 0, 2},
{-2, 0, -2},
{2, 0, -2},
{-1, 0 ,1},
{0, 0, -3}};

//For you/the avatar
int facing = 0;
float rotateT = 0.0;
float moveT = 0.0;
int ROOM_SIZE = 4;
boolean moving = false;
boolean rotate = false;
int prevX = 0;
int prevZ = 0;
int prevFacing = 0;

//Visitor 1 variables
int prevVis1X = -1;
int prevVis1Z = 1;
int vis1Facing = 2;
int prevVis1Facing = 2;
float vis1MoveT = 0.0;
float vis1RotateT = 0.0;
boolean vis1Moving = false;
boolean vis1Rotate = false;

//Visitor 2 variables
int prevVis2X = -1;
int prevVis2Z = 1;
int vis2Facing = 1;
int prevVis2Facing = 1;
float vis2MoveT = 0.0;
float vis2RotateT = 0.0;
boolean vis2Moving = false;
boolean vis2Rotate = false;

//Non exhibit stuff
PImage floor;
PImage cobble;
PImage wall;

//Exhibit 1
PImage earth;
PShape earthSphere;
PImage moon;
PShape moonSphere;

//Exhibit 2
PImage house;
PImage roof;

//Exhibit 3
PImage cone;
PImage icecream;
PShape icecreamSphere;

//Exhibit 4
PImage lollipop;
PShape lollipopSphere;
PImage stem;
PShape stemBox;

//For animations of exhibits
float textureT = 0;
float houseT = 0;
float iceCreamT = 0;
boolean moveHouseUp = true;
boolean growIceCream = true;

//Over the shoulder stuff
boolean overTheShoulder = false;
float otsX = position[0];
float otsZ = position[2]+1;

void setup() {
  size(1650, 1650, P3D);
  hint(DISABLE_OPTIMIZED_STROKE);
  noStroke();
  textureMode(NORMAL);
  
  //Non exhibit
  cobble = loadImage("assets/cobble.png");
  floor = loadImage("assets/floor.png");
  wall = loadImage("assets/wall.png");
  
  //Exhibit 1
  earth = loadImage("assets/earth.jpg");
  earthSphere = createShape(SPHERE, 0.1);
  earthSphere.setTexture(earth);
  moon = loadImage("assets/moon.jpg");
  moonSphere = createShape(SPHERE, 0.05);
  moonSphere.setTexture(moon);
  
  //Exhibit 2
  house = loadImage("assets/house.png");
  roof = loadImage("assets/roof.png");
 
  //Exhibit 3
  icecream = loadImage("assets/icecream.jpg"); //Created by Freepik
  icecreamSphere = createShape(SPHERE, 0.1);
  icecreamSphere.setTexture(icecream);
  cone = loadImage("assets/cone.png"); //Brought to you by Vecteezy.com
  
  //Exhibit 4
  lollipop = loadImage("assets/lollipop.jpg");
  lollipopSphere = createShape(SPHERE, 0.1);
  lollipopSphere.setTexture(lollipop);
  stem = loadImage("assets/stem.png");
  stemBox = createShape(BOX, 0.025);
  stemBox.setTexture(stem);
  
  strokeWeight(3.5);
  
  frustum(-float(width)/height, float(width)/height, 1, -1, 2.5, 16);
  resetMatrix();
}

void draw() {
  background(0, 0, 0.1);
  //Avatar/FP
  float moveX = position[0];
  float moveZ = position[2];
  float rotateY = -facing * PI/2;
  
  //Visitor 1
  float vis1X = obstaclePositions[4][0];
  float vis1Z = obstaclePositions[4][2];
  float vis1Y = -vis1Facing * PI/2;
  
  //Visitor 2
  float vis2X = obstaclePositions[5][0];
  float vis2Z = obstaclePositions[5][2];
  float vis2Y = -vis2Facing * PI/2;
  
  //Avatar/you rotate
  if(rotate){
    if(prevFacing == 0 && facing == 3){
      rotateY = lerp(-TWO_PI, -facing * PI/2, rotateT);
    }
    else if(prevFacing == 3 && facing == 0){
      rotateY = lerp(-prevFacing * PI/2, -TWO_PI, rotateT);
    }
    else{
      rotateY = lerp(-prevFacing * PI/2, -facing * PI/2, rotateT);
    }
    
    if(facing == 0){
      otsZ = lerp(moveZ, moveZ+1, rotateT);
      if(prevFacing == 1)
        otsX = lerp(moveX+1, moveX, rotateT);
      else if(prevFacing == 3)
        otsX = lerp(moveX-1, moveX, rotateT);
      }
      
    else if(facing == 1){
      otsX = lerp(moveX, moveX+1, rotateT);
      if(prevFacing == 0)
        otsZ = lerp(moveZ+1, moveZ, rotateT);
      else if(prevFacing == 2)
        otsZ = lerp(moveZ-1, moveZ, rotateT);
      }
      
    else if(facing == 2){
      otsZ = lerp(moveZ, moveZ-1, rotateT);
      if(prevFacing == 1)
        otsX = lerp(moveX+1, moveX, rotateT);
      else if(prevFacing == 3)
        otsX = lerp(moveX-1, moveX, rotateT);
      }
      
    else if(facing == 3){
      otsX = lerp(moveX, moveX-1, rotateT);
      if(prevFacing == 0)
        otsZ = lerp(moveZ+1, moveZ, rotateT);
      else if(prevFacing == 2)
        otsZ = lerp(moveZ-1, moveZ, rotateT);
      }
    
    rotateT += 0.1;
    if(rotateT >= 1){
      
      //The purpose of all this "facing ==" stuff is to combat the inaccuracies of floating point.
      if(facing == 0){
        otsX = position[0];
        otsZ = position[2] + 1;
      }
      else if(facing == 1){
        otsX = position[0] + 1;
        otsZ = position[2];
      }
      else if(facing == 2){
        otsX = position[0];
        otsZ = position[2] - 1;
      }
      else if(facing == 3){
        otsX = position[0] - 1;
        otsZ = position[2];
      }
      
      rotateT = 0;
      rotate = false;
    }
  }
  
  //Visitor 1 rotate
  if(vis1Rotate){
    if(prevVis1Facing == 0 && vis1Facing == 3){
      vis1Y = lerp(-TWO_PI, -vis1Facing * PI/2, vis1RotateT);
    }
    else if(prevVis1Facing == 3 && vis1Facing == 0){
      vis1Y = lerp(-prevVis1Facing * PI/2, -TWO_PI, vis1RotateT);
    }
    else{
      vis1Y = lerp(-prevVis1Facing * PI/2, -vis1Facing * PI/2, vis1RotateT);
    }
    
    vis1RotateT += 0.1;
    if(vis1RotateT >= 1){
      vis1RotateT = 0;
      vis1Rotate = false;
    }
  }
  
  //Visitor 2 rotate
  if(vis2Rotate){
    if(prevVis2Facing == 0 && vis2Facing == 3){
      vis2Y = lerp(-TWO_PI, -vis2Facing * PI/2, vis2RotateT);
    }
    else if(prevVis2Facing == 3 && vis2Facing == 0){
      vis2Y = lerp(-prevVis2Facing * PI/2, -TWO_PI, vis2RotateT);
    }
    else{
      vis2Y = lerp(-prevVis2Facing * PI/2, -vis2Facing * PI/2, vis2RotateT);
    }
    
    vis2RotateT += 0.1;
    if(vis2RotateT >= 1){
      vis2RotateT = 0;
      vis2Rotate = false;
    }
  }
  
  //Move the avatar
  if(moving){
    moveX = lerp(prevX, position[0], moveT);
    moveZ = lerp(prevZ, position[2], moveT);
    //Necessary for Over the shoulder stuff.
    if(facing == 0){
      otsX = moveX;
      otsZ = moveZ + 1;
    }
    else if(facing == 1){
      otsX = moveX + 1;
      otsZ = moveZ;
    }
    else if(facing == 2){
      otsX = moveX;
      otsZ = moveZ - 1;
    }
    else if(facing == 3){
      otsX = moveX - 1;
      otsZ = moveZ;
    }
    
    moveT += 0.1;
    
    if(moveT >= 1){
      //The purpose of all this "facing ==" stuff is to combat the inaccuracies of floating point.
      if(facing == 0){
        otsX = position[0];
        otsZ = position[2] + 1;
      }
      else if(facing == 1){
        otsX = position[0] + 1;
        otsZ = position[2];
      }
      else if(facing == 2){
        otsX = position[0];
        otsZ = position[2] - 1;
      }
      else if(facing == 3){
        otsX = position[0] - 1;
        otsZ = position[2];
      }
      moveT = 0;
      moving = false;
    }
  }
  
  //Visitor 1 moving
  if(vis1Moving){
    vis1X = lerp(prevVis1X, obstaclePositions[4][0], vis1MoveT);
    vis1Z = lerp(prevVis1Z, obstaclePositions[4][2], vis1MoveT);
    
    vis1MoveT += 0.1;
    
    if(vis1MoveT >= 1){  
      vis1MoveT = 0;
      vis1Moving = false;
    }
  }
  
  //Visitor 2 movement
  if(vis2Moving){
    vis2X = lerp(prevVis2X, obstaclePositions[5][0], vis2MoveT);
    vis2Z = lerp(prevVis2Z, obstaclePositions[5][2], vis2MoveT);
    
    vis2MoveT += 0.1;
    
    if(vis2MoveT >= 1){  
      vis2MoveT = 0;
      vis2Moving = false;
    }
  }
  
  if(overTheShoulder){
    translate(0, -1, -2);
  
    rotateY(rotateY);
    
    translate(-otsX, 0, -otsZ);
  }
  
  
  else{
    translate(0, -1, -2);
  
    rotateY(rotateY);
  
    translate(-moveX, 0, -moveZ);
  }
  
  //Draw avatar
  pushMatrix();
  translate(moveX, 0, moveZ);
  rotateY(-rotateY);
  fill(255,0,0);
  drawAvatar();
  popMatrix();
  
  //Draw the pyramid boy
  pushMatrix();
  translate(vis1X, 0, vis1Z);
  rotateY(-vis1Y);
  drawPyramidBoy();
  popMatrix();
  
  //Draw the cat
  pushMatrix();
  translate(vis2X, 0, vis2Z);
  rotateY(-vis2Y);
  drawCat();
  popMatrix();
  
  drawFloor();
 
  drawWalls();
  
  drawExhibits();
}

/*
|
|    Method: obstacleBoundary
|    Purpose: Make sure the visitors and the player don't run into each other / exhibits
|
*/
boolean obstacleBoundary(int x, int z, boolean vis1, boolean vis2){
  boolean boundary = false;
  for(int i = 0; i<obstaclePositions.length; i++){
    if(vis1 && i != 4 || vis2 && i != 5 || (!vis1 && !vis2)){ //Make sure the visitors don't check themselves
      if(x == obstaclePositions[i][0] && z == obstaclePositions[i][2])
        boundary = true;
    }
  }
  if(vis1 || vis2){
    if(x == position[0] && z == position[2])
      boundary = true;
  }
  return boundary;
}

/*
|
|    Method: drawAvatar
|    Purpose: Draw the avatar
|
*/
void drawAvatar(){
  //Head
  pushMatrix();
  translate(0, 0.8, 0);
  pushMatrix();
  scale(2.0);
  fill(204, 132, 67);
  drawQuad(null);
  popMatrix();
  
  //Body
  pushMatrix();
  translate(0, -0.3, 0);
  pushMatrix();
  scale(3, 4, 1);
  fill(255,0,0);
  drawQuad(null);
  popMatrix();
  
  //Arm 1
  pushMatrix();
  translate(0.18, 0.15, 0);
  if(moveT <= 0.5) //Move arm1 forward and then back
    rotateX(lerp(0, PI, moveT));
  else
    rotateX(lerp(PI, 0, moveT));
  pushMatrix();
  scale(0.75, 1, 1);
  fill(255,0,0);
  drawQuad(null); //Shoulder
  popMatrix();
  pushMatrix();
  translate(0, -0.2, 0);
  scale(0.25, 3, 1);
  fill(204, 132, 67);
  drawQuad(null); //Arm
  popMatrix();
  popMatrix();
  
  //Arm 2
  pushMatrix();
  translate(-0.18, 0.15, 0);
  if(moveT <= 0.5)
    rotateX(-lerp(0, PI, moveT));
  else
    rotateX(-lerp(PI, 0, moveT));
  pushMatrix();
  scale(0.75, 1, 1);
  fill(255,0,0);
  drawQuad(null); //Shoulder
  popMatrix();
  pushMatrix();
  translate(0, -0.2, 0);
  scale(0.25, 3, 1);
  fill(204, 132, 67);
  drawQuad(null); //Arm
  popMatrix();
  popMatrix();
  
  //Legs
  pushMatrix();
  translate(0, -0.15, 0);
  pushMatrix();
  scale(3, 1, 1);
  fill(255,0,255);
  drawQuad(null); //Dem hips tho
  popMatrix();
  
  pushMatrix();
  translate(0.1, -0.05, 0);
  if(moveT <= 0.5)
    rotateX(-lerp(0, PI, moveT));
  else
    rotateX(-lerp(PI, 0, moveT));
  pushMatrix();
  translate(0, -0.15, 0);
  scale(1, 3, 1);
  drawQuad(null); //Leg 1
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(-0.1, -0.05, 0);
  if(moveT <= 0.5)
    rotateX(lerp(0, PI, moveT));
  else
    rotateX(lerp(PI, 0, moveT));
  pushMatrix();
  translate(0, -0.15, 0);
  scale(1, 3, 1);
  drawQuad(null); //Leg 2
  popMatrix();
  popMatrix();
  
  popMatrix();
  
  popMatrix();
  
  popMatrix();
}

/*
|
|    Method: drawPyramidBoy
|    Purpose: Draws the Pyramid guy. Not Pyramid Head from Silent Hill. I can't do that, so I have a knockoff.
|
*/
void drawPyramidBoy(){
  pushMatrix();
  translate(0, 0.8, 0);
  pushMatrix();
  scale(2.0, 3.5, 2.0);
  fill(204, 132, 67);
  drawPyramid(null); //Head
  popMatrix();
  
  //Body. All of this is the exact same as the avatar aside from the colors/head, so it's probably
  //unnecessary to comment.
  pushMatrix();
  translate(0, -0.3, 0);
  pushMatrix();
  scale(3, 4, 1);
  fill(0,255,0);
  drawQuad(null);
  popMatrix();
  
  //Arms
  pushMatrix();
  translate(0.18, 0.15, 0);
  if(vis1MoveT <= 0.5)
    rotateX(lerp(0, PI, vis1MoveT));
  else
    rotateX(lerp(PI, 0, vis1MoveT));
  pushMatrix();
  scale(0.75, 1, 1);
  fill(0,255,0);
  drawQuad(null); //Shoulder
  popMatrix();
  pushMatrix();
  translate(0, -0.2, 0);
  scale(0.25, 3, 1);
  fill(204, 132, 67);
  drawQuad(null); //Arm
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(-0.18, 0.15, 0);
  if(vis1MoveT <= 0.5)
    rotateX(-lerp(0, PI, vis1MoveT));
  else
    rotateX(-lerp(PI, 0, vis1MoveT));
  pushMatrix();
  scale(0.75, 1, 1);
  fill(0,255,0);
  drawQuad(null);
  popMatrix();
  pushMatrix();
  translate(0, -0.2, 0);
  scale(0.25, 3, 1);
  fill(204, 132, 67);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(0, -0.15, 0);
  pushMatrix();
  scale(3, 1, 1);
  fill(0,255,255);
  drawQuad(null);
  popMatrix();
  
  pushMatrix();
  translate(0.1, -0.05, 0);
  if(vis1MoveT <= 0.5)
    rotateX(-lerp(0, PI, vis1MoveT));
  else
    rotateX(-lerp(PI, 0, vis1MoveT));
  pushMatrix();
  translate(0, -0.15, 0);
  scale(1, 3, 1);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(-0.1, -0.05, 0);
  if(vis1MoveT <= 0.5)
    rotateX(lerp(0, PI, vis1MoveT));
  else
    rotateX(lerp(PI, 0, vis1MoveT));
  pushMatrix();
  translate(0, -0.15, 0);
  scale(1, 3, 1);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  popMatrix();
  
  popMatrix();
  
  popMatrix();
}

/*
|
|    Method: drawCat
|    Purpose: Draw that kitty cat guy. 
*/
void drawCat(){
  //Head
  pushMatrix();
  translate(0, 0.225, 0.2);
  pushMatrix();
  scale(1.5, 1.5, 1.5);
  fill(255, 165, 0);
  drawQuad(null); 
  popMatrix();
  
  //Ears
  pushMatrix();
  translate(0.035, 0.105, 0);
  scale(0.25, 1.25, 0.75);
  drawPyramid(null);
  popMatrix();
  
  pushMatrix();
  translate(-0.035, 0.105, 0);
  scale(0.25, 1.25, 0.75);
  drawPyramid(null);
  popMatrix();
  
  //Body
  pushMatrix();
  translate(0, 0, -0.15);
  pushMatrix();
  scale(1, 1.25, 2.5);
  fill(255, 180, 30);
  drawQuad(null);
  popMatrix();
  
  //Legs
  pushMatrix();
  translate(0.05, -0.075, 0.05);
  if(vis2MoveT <= 0.5)
    rotateX(-lerp(0, PI, vis2MoveT));
  else
    rotateX(-lerp(PI, 0, vis2MoveT));
  pushMatrix();
  translate(0, -0.0125, 0);
  scale(0.25, 1, 0.25);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(-0.05, -0.075, 0.05);
  if(vis2MoveT <= 0.5)
    rotateX(lerp(0, PI, vis2MoveT));
  else
    rotateX(lerp(PI, 0, vis2MoveT));
  pushMatrix();
  translate(0, -0.0125, 0);
  scale(0.25, 1, 0.25);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(0.05, -0.075, -0.05);
  if(vis2MoveT <= 0.5)
    rotateX(-lerp(0, PI, vis2MoveT));
  else
    rotateX(-lerp(PI, 0, vis2MoveT));
  pushMatrix();
  translate(0, -0.0125, 0);
  scale(0.25, 1, 0.25);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  pushMatrix();
  translate(-0.05, -0.075, -0.05);
  if(vis2MoveT <= 0.5)
    rotateX(lerp(0, PI, vis2MoveT));
  else
    rotateX(lerp(PI, 0, vis2MoveT));
  pushMatrix();
  translate(0, -0.0125, 0);
  scale(0.25, 1, 0.25);
  drawQuad(null);
  popMatrix();
  popMatrix();
  
  //Little tail
  pushMatrix();
  translate(0,0.05,-0.175);
  scale(0.25,0.25,1);
  drawQuad(null);
  popMatrix();
  
  popMatrix();
  
  popMatrix();
}

/*
|
|    Method: drawFloor
|    Purpose: Draws the floor
|
*/
void drawFloor(){
  tint(200,200,200); //Make it a slightly different color
  for (int z = -ROOM_SIZE-1; z <= ROOM_SIZE+1; z++) {
    for (int x = -ROOM_SIZE-1; x <= ROOM_SIZE+1; x++) {
      noStroke();
      beginShape(QUADS);
      texture(floor);
      vertex(x-0.5, 0, z-0.5, 0, 0);
      vertex(x+0.5, 0, z-0.5, 1, 0);
      vertex(x+0.5, 0, z+0.5, 1, 1);
      vertex(x-0.5, 0, z+0.5, 0, 1);
      endShape();
      stroke(0,0,0);
    }
  }
  noTint();
}

/*
|
|    Method: drawWalls
|    Purpose: Draws the walls
|
*/
void drawWalls(){
  noStroke();
  
  tint(200,200,200);
  
  beginShape(QUADS);
  texture(wall);
  vertex(-ROOM_SIZE-1.25, 0, -ROOM_SIZE-1.25, 0,0);
  vertex(ROOM_SIZE+1.25, 0, -ROOM_SIZE-1.25, 0, 1);
  vertex(ROOM_SIZE+1.25, 8, -ROOM_SIZE-1.25, 1, 1);
  vertex(-ROOM_SIZE-1.25, 8, -ROOM_SIZE-1.25, 1, 0);
  endShape();
  
  beginShape(QUADS);
  texture(wall);
  vertex(-ROOM_SIZE-1.25, 0, ROOM_SIZE+1.25, 0, 0);
  vertex(ROOM_SIZE+1.25, 0, ROOM_SIZE+1.25, 0, 1);
  vertex(ROOM_SIZE+1.25, 8, ROOM_SIZE+1.25, 1, 1);
  vertex(-ROOM_SIZE-1.25, 8, ROOM_SIZE+1.25, 1, 0);
  endShape();
  
  beginShape(QUADS);
  texture(wall);
  vertex(ROOM_SIZE+1.25, 0, -ROOM_SIZE-1.25, 0, 0);
  vertex(ROOM_SIZE+1.25, 0, ROOM_SIZE+1.25, 0, 1);
  vertex(ROOM_SIZE+1.25, 8, ROOM_SIZE+1.25, 1, 1);
  vertex(ROOM_SIZE+1.25, 8, -ROOM_SIZE-1.25, 1, 0);
  endShape();
  
  beginShape(QUADS);
  texture(wall);
  vertex(-ROOM_SIZE-1.25, 0, -ROOM_SIZE-1.25, 0, 0);
  vertex(-ROOM_SIZE-1.25, 0, ROOM_SIZE+1.25, 0, 1);
  vertex(-ROOM_SIZE-1.25, 8, ROOM_SIZE+1.25, 1, 1);
  vertex(-ROOM_SIZE-1.25, 8, -ROOM_SIZE-1.25, 1, 0);
  endShape();
  stroke(0,0,0);
  noTint();
}

/*
|
|    Method: drawWalls
|    Purpose: Draws all of the exhibits
|
*/
void drawExhibits(){
  pushMatrix();
  translate(obstaclePositions[0][0], obstaclePositions[0][1], obstaclePositions[0][2]);
  drawPedestal();
  exhibitOne();
  popMatrix();
  
  pushMatrix();
  translate(obstaclePositions[1][0], obstaclePositions[1][1], obstaclePositions[1][2]);
  drawPedestal();
  exhibitTwo();
  popMatrix();
  
  pushMatrix();
  translate(obstaclePositions[2][0], obstaclePositions[2][1], obstaclePositions[2][2]);
  drawPedestal();
  exhibitThree();
  popMatrix();
  
  pushMatrix();
  translate(obstaclePositions[3][0], obstaclePositions[3][1], obstaclePositions[3][2]);
  drawPedestal();
  exhibitFour();
  popMatrix();
}

/*
|
|    Method: drawPedestal
|    Purpose: Draws a pedestal
|
*/
void drawPedestal(){
  pushMatrix();
  translate(0, 0.05, 0);
  pushMatrix();
  scale(5.0, 0.5, 5.0);
  drawQuad(cobble);
  popMatrix();
  
  pushMatrix();
  translate(0, 0.3, 0);
  scale(4.0, 5.0, 4.0);
  drawQuad(cobble);
  popMatrix();
  
  pushMatrix();
  translate(0, 0.55, 0);
  scale(5.0, 0.5, 5.0);
  drawQuad(cobble);
  popMatrix();
  
  popMatrix();
}

/*
|
|    Method: exhibitOne
|    Purpose: Draws an Earth with an orbiting moon
|
*/
void exhibitOne(){
  pushMatrix();
  translate(0, 0.9, 0);
  rotateY(lerp(0, TWO_PI, textureT)); //Rotates
  textureT += 0.005;
  pushMatrix();
  
  rotateX(PI);
  noStroke();
  shape(earthSphere); //Draws the earth
  popMatrix();
  pushMatrix();
  translate(0.15, 0.1, 0);
  rotateY(lerp(0, TWO_PI, textureT));
  shape(moonSphere); //Draws the moon
  stroke(0,0,0);
  popMatrix();
  popMatrix();
}

/*
|
|    Method: exhibitTwo
|    Purpose: Draws a house that rotates and moves up and down.
|
*/
void exhibitTwo(){
  float moveHouse = lerp(0.75, 0.85, houseT);
  //Moves the house up and down
  if(moveHouseUp){
    houseT += 0.005;
  }
  if(houseT >= 1 && moveHouseUp){
    moveHouseUp = false;
    houseT = 1;
    houseT -= 0.005;
  }
  if(!moveHouseUp){
    houseT -= 0.005;
  }
  if(houseT <= 0 && !moveHouseUp){
    moveHouseUp = true;
    houseT = 0;
    houseT += 0.005;
  }
  pushMatrix();
  translate(0, moveHouse, 0);
  scale(2);
  pushMatrix();
  rotateY(-lerp(0, TWO_PI, textureT));
  drawQuad(house); //Draw rotating house
  popMatrix();
  
  pushMatrix();
  translate(0, 0.075, 0);
  rotateY(lerp(0, TWO_PI, textureT));
  drawPyramid(roof); //Draw rotating roof
  stroke(0,0,0);
  popMatrix();
  popMatrix();
}

/*
|
|    Method: exhibitThree
|    Purpose: Draws a growing and shrinking ice cream cone
|
*/
void exhibitThree(){
  //Grow the ice cream!
  if(growIceCream){
    iceCreamT += 0.01;
  }
  if(iceCreamT >= 1 && growIceCream){
    growIceCream = false;
    iceCreamT = 1;
    iceCreamT -= 0.01;
  }
  if(!growIceCream){
    iceCreamT -= 0.01;
  }
  if(iceCreamT <= 0 && !growIceCream){
    growIceCream = true;
    iceCreamT = 0;
    iceCreamT += 0.01;
  }
  pushMatrix();
  translate(0, 1.1, 0);
  scale(lerp(1.0, 2.0, iceCreamT));
  shape(icecreamSphere); //Cone
  
  pushMatrix();
  rotate(PI); //Move the cone to the bottom of the ice cream.
  translate(0,0.16,0);
  scale(1, 3, 1);
  drawPyramid(cone);
  popMatrix();
  popMatrix();
  
}

/*
|
|    Method: exhibitFour
|    Purpose: Rotating lollipop in all directions. I like this one the most.
|
*/
void exhibitFour(){
  
  pushMatrix();
  translate(0, 1.1, 0);
  rotateX(lerp(0, TWO_PI, textureT));
  rotateY(-lerp(0, TWO_PI, textureT));
  rotateZ(-lerp(0, TWO_PI, textureT));
  
  pushMatrix();
  scale(0.25, 1, 1);
  shape(lollipopSphere); //Draw lollipop
  popMatrix();
  
  pushMatrix();
  rotate(PI);
  translate(0,0.2,0);
  scale(0.25, 8, 1);
  shape(stemBox); //Draw the stem
  popMatrix();
  popMatrix();
}

/*
|
|    Method: drawQuad
|    Purpose: Draws a quad. Can take a texture if needed. Pretty much self explanatory
|
*/
void drawQuad(PImage texture){
  pushMatrix();
  scale(0.05, 0.05, 0.05);
  stroke(1);
  beginShape(QUADS);
  texture(texture);
  vertex(-1,-1,1,0,0);
  vertex(-1,1,1,1,0);
  vertex(1,1,1,1,1);
  vertex(1,-1,1,0,1);

  vertex(1,-1,1,0,0);
  vertex(1,-1,-1,1,0);
  vertex(1,1,-1,1,1);
  vertex(1,1,1,0,1);

  vertex(1,-1,-1,0,0);
  vertex(-1,-1,-1,1,0);
  vertex(-1,1,-1,1,1);
  vertex(1,1,-1,0,1);

  vertex(-1,-1,-1,0,0);
  vertex(-1,-1,1,1,0);
  vertex(-1,1,1,1,1);
  vertex(-1,1,-1,0,1);

  vertex(-1,1,1,0,0);
  vertex(1,1,1,1,0);
  vertex(1,1,-1,1,1);
  vertex(-1,1,-1,0,1);

  vertex(1,-1,1,0,0);
  vertex(-1,-1,1,1,0);
  vertex(-1,-1,-1,1,1);
  vertex(1,-1,-1,0,1);
  
  endShape();
  popMatrix();
}

/*
|
|    Method: drawPyramid
|    Purpose: Draws a pyramid. Can take a texture if needed. Pretty much self explanatory
|
*/
void drawPyramid(PImage texture){
  pushMatrix();
  scale(0.06, 0.025, 0.06);
  
  stroke(1);
  beginShape(TRIANGLES);
  texture(texture);
  
  vertex(-1,-1,1,1,0);
  vertex(1,-1,1,1,1);
  vertex(0,1,0,0,0.5);

  vertex(1,-1,1,1,0);
  vertex(1,-1,-1,1,1);
  vertex(0,1,0,0,0.5);

  vertex(-1,-1,1,1,0);
  vertex(-1,-1,-1,1,1);
  vertex(0,1,0,0,0.5);

  vertex(1,-1,-1,1,0);
  vertex(-1,-1,-1,1,1);
  vertex(0,1,0,0,0.5);
  endShape();
  
  beginShape(QUADS);
  vertex(1,-1,1);
  vertex(-1,-1,1);
  vertex(-1,-1,-1);
  vertex(1,-1,-1);
  endShape();
  
  popMatrix();
}

/*
|
|    Method: visitorMovement
|    Purpose: Determines the visitors movements. Exact same way as determining avatar positions
|    Except with random numbers instead of keys
|
*/
void visitorMovement(){
  int vis1Key = (int)random(1,5);
  int vis2Key = (int)random(1,5);
  
  //Visitor 1 stuff
  switch (vis1Key) {
  case 1:
    if(!vis1Moving){
      vis1Moving = true;
      prevVis1X = obstaclePositions[4][0];
      prevVis1Z = obstaclePositions[4][2];
      
      obstaclePositions[4][0] += (vis1Facing % 2) * (vis1Facing % 4 == 1 ? -1 : 1);
      if(obstaclePositions[4][0] > ROOM_SIZE || obstaclePositions[4][0] < -ROOM_SIZE 
      || obstacleBoundary(obstaclePositions[4][0], obstaclePositions[4][2], true, false))
        obstaclePositions[4][0] = prevVis1X;
      
      obstaclePositions[4][2] += ((vis1Facing + 1) % 2) * (vis1Facing % 4 == 0 ? -1 : 1);
      if(obstaclePositions[4][2] > ROOM_SIZE || obstaclePositions[4][2] < -ROOM_SIZE
      || obstacleBoundary(obstaclePositions[4][0], obstaclePositions[4][2], true, false))
        obstaclePositions[4][2] = prevVis1Z;
    }
    break;
  case 2:
    if(!vis1Rotate){
      vis1Rotate = true;
      prevVis1Facing = vis1Facing;
      vis1Facing = (vis1Facing + 1) % 4;
    }
    break;
  case 3:
    if(!vis1Moving){
      vis1Moving = true;
      prevVis1X = obstaclePositions[4][0];
      prevVis1Z = obstaclePositions[4][2];
      
      obstaclePositions[4][0] -= (vis1Facing % 2) * (vis1Facing % 4 == 1 ? -1 : 1);
      if(obstaclePositions[4][0] > ROOM_SIZE || obstaclePositions[4][0] < -ROOM_SIZE 
      || obstacleBoundary(obstaclePositions[4][0], obstaclePositions[4][2], true, false))
        obstaclePositions[4][0] = prevVis1X;
      
      obstaclePositions[4][2] -= ((vis1Facing + 1) % 2) * (vis1Facing % 4 == 0 ? -1 : 1);
      if(obstaclePositions[4][2] > ROOM_SIZE || obstaclePositions[4][2] < -ROOM_SIZE
      || obstacleBoundary(obstaclePositions[4][0], obstaclePositions[4][2], true, false))
        obstaclePositions[4][2] = prevVis1Z;
    }
    break;
  case 4:
    if(!vis1Rotate){
      vis1Rotate = true;
      prevVis1Facing = vis1Facing;
      vis1Facing = (vis1Facing + 3) % 4;
    }
    break;
  }
  
  //Visitor 2 stuff
  switch (vis2Key) {
  case 1:
    if(!vis2Moving){
      vis2Moving = true;
      prevVis2X = obstaclePositions[5][0];
      prevVis2Z = obstaclePositions[5][2];
      
      obstaclePositions[5][0] += (vis2Facing % 2) * (vis2Facing % 4 == 1 ? -1 : 1);
      if(obstaclePositions[5][0] > ROOM_SIZE || obstaclePositions[5][0] < -ROOM_SIZE 
      || obstacleBoundary(obstaclePositions[5][0], obstaclePositions[5][2], false, true))
        obstaclePositions[5][0] = prevVis2X;
      
      obstaclePositions[5][2] += ((vis2Facing + 1) % 2) * (vis2Facing % 4 == 0 ? -1 : 1);
      if(obstaclePositions[5][2] > ROOM_SIZE || obstaclePositions[5][2] < -ROOM_SIZE
      || obstacleBoundary(obstaclePositions[5][0], obstaclePositions[5][2], false, true))
        obstaclePositions[5][2] = prevVis2Z;
    }
    break;
  case 2:
    if(!vis2Rotate){
      vis2Rotate = true;
      prevVis2Facing = vis2Facing;
      vis2Facing = (vis2Facing + 1) % 4;
    }
    break;
  case 3:
    if(!vis2Moving){
      vis2Moving = true;
      prevVis2X = obstaclePositions[5][0];
      prevVis2Z = obstaclePositions[5][2];
      
      obstaclePositions[5][0] -= (vis2Facing % 2) * (vis2Facing % 4 == 1 ? -1 : 1);
      if(obstaclePositions[5][0] > ROOM_SIZE || obstaclePositions[5][0] < -ROOM_SIZE 
      || obstacleBoundary(obstaclePositions[5][0], obstaclePositions[5][2], false, true))
        obstaclePositions[5][0] = prevVis2X;
      
      obstaclePositions[5][2] -= ((vis2Facing + 1) % 2) * (vis2Facing % 4 == 0 ? -1 : 1);
      if(obstaclePositions[5][2] > ROOM_SIZE || obstaclePositions[5][2] < -ROOM_SIZE
      || obstacleBoundary(obstaclePositions[5][0], obstaclePositions[5][2], false, true))
        obstaclePositions[5][2] = prevVis2Z;
    }
    break;
  case 4:
    if(!vis2Rotate){
      vis2Rotate = true;
      prevVis2Facing = vis2Facing;
      vis2Facing = (vis2Facing + 3) % 4;
    }
    break;
  }
}

/*
|
|    Method: keyPressed
|    Purpose: Move my guy, move the other guys indirectly, switch to over the shoulder
|
*/
void keyPressed() {
  switch (key) {
  case 'w':
    if(!moving){
      visitorMovement();
      moving = true;
      prevX = position[0];
      prevZ = position[2];
      
      position[0] += (facing % 2) * (facing % 4 == 1 ? -1 : 1);
      if(position[0] > ROOM_SIZE || position[0] < -ROOM_SIZE 
      || obstacleBoundary(position[0], position[2], false, false))
        position[0] = prevX;
      
      position[2] += ((facing + 1) % 2) * (facing % 4 == 0 ? -1 : 1);
      if(position[2] > ROOM_SIZE || position[2] < -ROOM_SIZE
      || obstacleBoundary(position[0], position[2], false, false))
        position[2] = prevZ;
    }
    break;
  case 'a':
    if(!rotate){
      visitorMovement();
      rotate = true;
      prevFacing = facing;
      facing = (facing + 1) % 4;
    }
    break;
  case 's':
    if(!moving){
      visitorMovement();
      moving = true;
      prevX = position[0];
      prevZ = position[2];
      
      position[0] -= (facing % 2) * (facing % 4 == 1 ? -1 : 1);
      if(position[0] > ROOM_SIZE || position[0] < -ROOM_SIZE 
      || obstacleBoundary(position[0], position[2], false, false))
        position[0] = prevX;
        
      position[2] -= ((facing + 1) % 2) * (facing % 4 == 0 ? -1 : 1);
      if(position[2] > ROOM_SIZE || position[2] < -ROOM_SIZE
      || obstacleBoundary(position[0], position[2], false, false))
        position[2] = prevZ;
    }
    break;
  case 'd':
    if(!rotate){
      visitorMovement();
      rotate = true;
      prevFacing = facing;
      facing = (facing + 3) % 4;
    }
    break;
    
  case 'q':
    overTheShoulder = !overTheShoulder;
    break;
  }
}
