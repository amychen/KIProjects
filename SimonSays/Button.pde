class Button{
  float w_l, h_l;
  float xPos, yPos;
  color clr;
  String state = "NOT_PRESSED"; 
  SoundFile sound;
  boolean prevPress = false;
  
  Button(float x, float y, float w, float h, int c, SoundFile s){
    xPos = x;
    yPos = y;
    w_l = w;
    h_l = h;
    clr = c;
    
    state = "NOT_PRESSED";
    
    sound = s;
  }
  
  void checkState(){
    boolean currPress = false;
    if (mouseX > xPos && mouseX < xPos + w_l && mouseY > yPos && mouseY < yPos + h_l){
      state = "HOVER";
      if (mousePressed){
        currPress = true;
        state = "PRESSED";
      } else if (prevPress){
        state = "RELEASED";
      }
    } else{
      state = "NOT_PRESSED";
    }
    prevPress = currPress;
  }

  void display(){
    pushStyle();
    noStroke();
    switch(state){
      case "NOT_PRESSED": 
        fill(clr);
        break;
      case "PRESSED":
        sound.play();
        fill(255);
        break;
      case "HOVER":
        fill(clr, 200);
        break;
      case "RELEASED":
        fill(clr);
        break;
    }
    rect(xPos, yPos, w_l, h_l);
    popStyle();
  }
}