PImage colorWheel;
float wheelX, wheelY;
float rad;
int wndWidth, wndHeight;

class ColorWheel{
  
  ColorWheel(int w, int h){
    wndWidth = w;
    wndHeight = h;
    colorWheel = createImage(wndWidth, wndHeight, RGB);
    wheelX = width/2;
    wheelY = height/2;
    rad = height/2.8;
    
    colorWheel.loadPixels();
    
    for (int y = 0; y < colorWheel.height; y++){
      for (int x = 0; x < colorWheel.width; x++){
        int index = x + y * colorWheel.width;
        if (dist(wheelX, wheelY, x, y) < rad){
          int hue = int(map(atan2(x-wheelX, y-wheelY), -PI, PI, 0, 360));
          int sat = int(map(dist(x, y, wheelX, wheelY), 0, rad, 0, 360));
          colorWheel.pixels[index] = color(hue, sat, 360, 1);
        } else colorWheel.pixels[index] = color(255, 255, 255, 0);
      }
    }
    colorWheel.updatePixels();
  }
  
  color display(){
    image(colorWheel, 0, 0);
    pushStyle();
      color clr = colorWheel.get(mouseX, mouseY);
      float r = red(clr);
      float g = green(clr);
      float b = blue(clr);
      noStroke();
      fill(clr);
      ellipse(20, 20, 20, 20);
    popStyle();
    return color(r, g, b, 200);
  }
}