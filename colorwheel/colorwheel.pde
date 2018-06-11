PImage colorWheel;
PImage colorSlider;

float rad; 
float wheelX; 
float wheelY;

color clr;
color selectedClr; 
int brightness = 360;

void setup(){
  size(500,500);
  smooth();
  noStroke();
  
  wheelX = width/2;
  wheelY = height/2-50;
  rad = height/2.8;
  
  colorMode(HSB, 360);
  
  colorWheel = createImage(width,height, RGB);
  colorSlider = createImage(450, 50, RGB);
}

void draw(){
  background(0);
  
  createColorHue();
  image(colorWheel,0,0);
  
  pushStyle();
  hsbColorSlider();
  imageMode(CENTER);
  image(colorSlider, width/2, height-40);
  popStyle();
  
  selectedClr();
  
  if (mouseY > height-65 && mouseY < height-15 && mouseX > 25 && mouseX < width-25)
    clr = colorSlider.pixels[mouseX-25 + (mouseY-425)*(colorSlider.width)];
  else if (mouseX < 475)
    clr = colorWheel.get(mouseX, mouseY);
    
  if (clr != color(0,0,360)){
    fill(clr);
    stroke(255);
  } else {
    noFill();
    noStroke();
  }
  
  ellipseMode(CORNER);
  ellipse(mouseX,mouseY,30,30);
  
  colorInfo();
}

void createColorHue(){
  colorWheel.loadPixels();
  
  for (int y = 0; y < colorWheel.height; y++){
    for (int x = 0; x < colorWheel.width; x++){
      int index = x + y * colorWheel.width;
      if (dist(wheelX, wheelY, x, y) < rad){
        int h = int(map(atan2(x-wheelX, y-wheelY), -PI, PI, 0, 360));
        int s = int(map(dist(x, y, wheelX, wheelY), 0, rad, 0, 360));
        colorWheel.pixels[index] = color(h, s, brightness);
      } else colorWheel.pixels[index] = color(0,0,360);
    }
  }
  colorWheel.updatePixels();
}

void hsbColorSlider(){
  colorSlider.loadPixels();
  
  for (int y = 0; y < colorSlider.height; y++){
    for (int x = 0; x < colorSlider.width; x++){
      int index = x + y * colorSlider.width;
      int h = int(map(x, 0, colorSlider.width, 0, 360));
      
      colorSlider.pixels[index] = color(h, 360, brightness+100);
    }
  }
  
  colorSlider.updatePixels();
}

void mouseDragged(){
  if (mouseX < pmouseX){
    brightness--;
  } else if (brightness < 360){
    brightness++;
  }
}

void mousePressed(){
  if (mouseY > height-75 && mouseY < height-25 && mouseX > 25 && mouseX < width-25)
    selectedClr = colorSlider.pixels[mouseX-25 + (mouseY-425)*(colorSlider.width)];
  else selectedClr = colorWheel.get(mouseX, mouseY);
}

void colorInfo(){
  fill(0);
  text("color:", 10, 20);
  text(clr, 45, 20);
  text("hue:", 10, 40);
  text(int(hue(clr)), 40, 40);
  text("saturation:", 10, 60);
  text(int(saturation(clr)), 75, 60);
  text("brightness:", 10, 80);
  text(int(brightness(clr)), 78, 80);
  text("hex:#", 10, 100);
  text(hex(clr), 45, 100);
}

void selectedClr(){
  pushStyle();
  noStroke();
  fill(selectedClr);
  rect(width-40, 25, 20, 350);
  popStyle();
  
  text(hex(selectedClr), width-60, 18);
  text("h:", width-50, 390);
  text(int(hue(selectedClr)), width-35, 390);
  text("s:", width-50, 410);
  text(int(saturation(selectedClr)), width-35, 410);
  text("b:", width-50, 430);
  text(int(brightness(selectedClr)), width-35, 430);
}
