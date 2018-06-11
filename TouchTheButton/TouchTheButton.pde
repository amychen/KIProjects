import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import gab.opencv.*;
import controlP5.*;

Kinect2 kinect2;
OpenCV opencv;
ControlP5 cp5;

PImage depthImg;
PImage colorImg;
PVector closestPos;

int bangXPos;
int bangYPos;
int bangHeight;
int bangWidth;
int point;
int millis;

void setup(){
  size(512, 424, P2D);
  
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();
  
  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight);
  opencv = new OpenCV(this, depthImg);
  
  cp5 = new ControlP5(this);
  createNewBang();
    
  point = 0;
}

void draw(){
  //background(0);
  millis = millis();
  colorImg = kinect2.getRegisteredImage().copy();
  
  int[] rawDepth = kinect2.getRawDepth();
  depthImg.loadPixels();
  colorImg.loadPixels();
  for (int i = 0; i < rawDepth.length; i++){
    int depth = rawDepth[i];
    
    if (depth <= 1500 && depth != 0){
      float w = map(depth, 0, 1500, 255, 0);
      depthImg.pixels[i] = color(w);
    } else {
      depthImg.pixels[i] = color(0);
    }
  }
  
  depthImg.updatePixels();
  colorImg.updatePixels();
  image(depthImg, 0, 0);
  opencv.loadImage(depthImg);
  
  opencv.dilate();
  opencv.erode();
  
  closestPos = opencv.max();
  if (closestPos.x < width/2 && closestPos.y < height / 2){
    fill(255, 0, 0);
    ellipse(closestPos.x, closestPos.y, 30, 30);
  } else if (closestPos.x < width/2 && closestPos.y > height / 2){
    fill(0, 255, 0);
    rect(closestPos.x, closestPos.y, 30, 30);
  } else if (closestPos.x > width / 2 && closestPos.y > height / 2){
    fill(0, 0, 255);
    ellipse(closestPos.x, closestPos.y, 30, 30);
  } else {
    fill(255, 255, 0);
    rect(closestPos.x, closestPos.y, 30, 30);
  }
  
  if (closestPos.x >= bangXPos && closestPos.x <= bangXPos + bangWidth
     && closestPos.y >= bangYPos && closestPos.y <= bangYPos + bangHeight){
    createNewBang();
    point++;
  }
  
  text("Points: ", 10, 20);
  text(point, 50, 20);
}

void createNewBang(){
  bangHeight = int(random(5, 20));
  bangWidth = int(random(5, 20));
  bangXPos = int(random(5, width));
  bangYPos = int(random(5, height));
  cp5.addBang("bang")
   .setPosition(bangXPos, bangYPos)
   .setSize(bangWidth, bangHeight);
}
