import processing.video.*;
import gab.opencv.*;

Capture cam;
ColorWheel colorwheel;

PImage paintedImg; 
color drawingPoint = color(0, 0);
color penColor;
boolean wheelOn = false;
boolean drawOn = false;
int threshold;

void setup(){
  frameRate(30);
  size(640, 480);
  noStroke();
  pushStyle();
    colorMode(HSB, 360);
    colorwheel = new ColorWheel(width, height);
  popStyle();
  
  threshold = 15;
  
  paintedImg = createImage(width, height, ARGB);
  cam = new Capture(this, 640, 480);
  cam.start();
}

void draw(){
  if (cam.available()){
    cam.read();
    cam.loadPixels();
  } 
  
  int count = 0;
  int sumX = 0, sumY = 0;
  float avgX = 0, avgY = 0;
  
  for (int y = 0; y < cam.height; y++){
    for (int x = 0; x < cam.width; x++){
      
      int index = x + y * cam.width; 
      
      float r = red(cam.pixels[index]);
      float g = green(cam.pixels[index]);
      float b = blue(cam.pixels[index]);
      
      if (r > red(drawingPoint) - threshold && r < red(drawingPoint) + threshold
      && g > green(drawingPoint) - threshold && g < green(drawingPoint) + threshold
      && b > blue(drawingPoint) - threshold && b < blue(drawingPoint) + threshold){
        cam.pixels[index] = color(0, green(drawingPoint), 0);
        sumX += x;
        sumY += y;
        count++;
      }
    }
  }
  cam.updatePixels();
  image(cam, 0, 0);
  
  if (count > 0){
    avgX = sumX / count;
    avgY = sumY / count;
  }
  
  if (wheelOn) penColor = colorwheel.display();
  else if (drawOn){
    for (int y = 0; y < paintedImg.height; y++){
      for (int x = 0; x < paintedImg.width; x++){
        int index = x + y * cam.width; 
        if (dist(x, y, avgX, avgY) < count/100)
          paintedImg.pixels[index] = penColor;
      }
    }
  } else penColor = color(0, 0);
  
  paintedImg.updatePixels();
  
  if (!wheelOn){
    image(paintedImg, 0, 0);
    fill(255, 0, 0);
    ellipse(avgX, avgY, 10, 10);
  }
}

void mousePressed(){
  if (!wheelOn)  drawingPoint = cam.get(mouseX, mouseY);
}

void keyPressed(){
  if (keyCode == ' '){
    if (wheelOn)  wheelOn = false;
    else          wheelOn = true;
  } else if (key == 'd'){
    if (!drawOn)  drawOn = true;
    else          drawOn = false;
  } else if (key == 'e') penColor = color(0,0);
    else if (key == 'c')  clearCanvas();
}

void clearCanvas(){
  for (int y = 0; y < paintedImg.height; y++){
    for (int x = 0; x < paintedImg.width; x++){
      int index = x + y * paintedImg.width;
      paintedImg.pixels[index] = color(0,0);
    }
  }
}