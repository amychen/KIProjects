import processing.sound.*;
SoundFile sound;

ArrayList<Button> buttons = new ArrayList<Button>();

Button[] patterns = new Button[10];
int currPosInPattern = 0;
int currLength = 0;

int button_h;
int button_w;
int clr;
int x, y;

boolean simonTurn = true;
boolean correct = true;

void setup(){
  size(600, 600);
  frameRate(10);
  button_h = height / 2 - 10;
  button_w = width / 2 - 10;
  
  x = 10;
  y = 10;
  
  //button locations
  for (int i = 1; i <= 4; i++){
    clr = color(random(150,255), random(150, 255), random(150, 255));
    sound  = new SoundFile(this, "a" + str(i) + ".wav");
    buttons.add(new Button(x, y, button_w, button_h, clr, sound));
    if (x >= width - (button_w) - 10){
      y += button_h;
      x = 10;
    } else x += button_w;
  }
  
  this.createPattern();
}

void draw(){
  background(100);
  for (Button b : buttons){
    b.checkState();
    b.display();
  }
  
  if (simonTurn) this.performPattern();
}

void performPattern(){
  patterns[currPosInPattern].state = "PRESSED";
  patterns[currPosInPattern].display();
  /*patterns[currPosInPattern].state = "NOT_PRESSED";
  print(patterns[currPosInPattern].state);*/

  if (currPosInPattern < currLength){
    currPosInPattern++;
  } else{
    simonTurn = false;
    currPosInPattern = 0;
  }
}

void mousePressed(){
  if (!simonTurn){
    for (Button b: buttons){
      b.checkState();
      if (b.state == "PRESSED"){
        b.display();
        if (patterns[currPosInPattern] != b)
          correct = false;
      }
    }
  }
}

void mouseReleased(){
  if (!simonTurn){
    for (Button b : buttons){
      b.checkState();
      if (b.state == "RELEASED")
        b.display();
    }
  
    if (!correct){
      this.createPattern();
      currPosInPattern = 0;
      simonTurn = true;
      correct = true;
    } 
    else {
      if (currPosInPattern < currLength){
        currPosInPattern++;
      } else{
        if (currLength == patterns.length - 1){
          this.createPattern();
        }
        else {
          currLength += 1;
          currPosInPattern = 0;
        }
        simonTurn = true;
      }
      /*if (currLength == patterns.length - 1){
        this.createPattern();
      } else {
        currLength++;
        currPosInPattern = 0;
      }
      simonTurn = true;*/
    } 
  }
}

void createPattern(){
  int random_n;
  for (int i = 0; i < patterns.length; i++){
    random_n = int(random(0, 4));
    patterns[i] = buttons.get(random_n);
  }
  currPosInPattern = 0;
  currLength = 0;
}
