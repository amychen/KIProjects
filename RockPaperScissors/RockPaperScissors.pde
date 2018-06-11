import de.voidplus.leapmotion.*;
LeapMotion leap;
String[] moves =  {"AT_REST", "ROCK", "PAPER", "SCISSORS"};
PImage r, p, s;
PImage one, two, three;
boolean startGame;
boolean readyToPlay;
String comp_move, your_move;
int tie, win, lose;
int m, sec;

void setup() {
  leap = new LeapMotion(this);
  size(800, 500, P3D);
  background(255);
  fill(0);
  
  startGame = true;
  readyToPlay = false;
  
  comp_move = "AT_REST";
  your_move = "AT_REST";
  
  imageMode(CENTER);
  r       = loadImage("rock.jpg");
  p       = loadImage("paper.png");
  s       = loadImage("scissors.jpg");
  one     = loadImage("1.png");
  two     = loadImage("2.png");
  three   = loadImage("3.png");
  
  int w = one.width/2;
  int h = one.height/2;
  one.resize(w, h);
  two.resize(w, h);
  three.resize(w, h);
  
  tie = 0;
  win = 0;
  lose = 0;
}

void draw() {
  background(255);
  m = millis();
  this.time();
  this.displayMoves();
  this.displayScore();
  this.replaceHumanHand();
  if (sec == 0 && readyToPlay && startGame){
    this.representCompHand();
    this.checkWinner();
    readyToPlay = false;
  } else if (sec != 0 && startGame){
    this.checkIfEndGame();
    this.displayMoves();
    readyToPlay = true;
    pushStyle();
    if (sec == 1)      image(one, width/2, height/2);
    else if (sec == 2) image(two, width/2, height/2);
    else if (sec == 3) image(three, width/2, height/2);
    popStyle();
  } else  this.checkIfEndGame();
}

void checkHand(){
  for (Hand hand : leap.getHands()) {
    float   handGrab           = hand.getGrabStrength();
    ArrayList<Finger> fingers  = hand.getOutstretchedFingers();
    boolean isScissor          = false;
    int correctFinger          = 0;
    
    if (handGrab > 0.8)
          your_move = "ROCK";
    else{
      for (Finger finger : fingers){
        if (finger.getType() == 1 || finger.getType() == 2){
          isScissor = true;
          correctFinger++;
        } 
      }
      if (isScissor && correctFinger == 2 && fingers.size() == 2)    
             your_move = "SCISSORS";
      else   your_move = "PAPER";
    }
    
    text("Number of Stretched Finger: ", width - 250, height - 50);
    text(fingers.size(), width - 50, height - 50);
    text("Hand grip strength: ", width - 250, height - 35);
    text(int(handGrab), width - 50, height - 35);
  }
}

void checkIfEndGame(){
  int count = 0;
  for (Hand hand : leap.getHands()){
    count++;
  }
  if (count >= 2) startGame = false;
  else startGame = true;
}

void checkWinner(){
  String state = "";
  pushStyle();
  textSize(30);
  if (your_move == comp_move)   state = "TIE";
  else if (your_move == "SCISSORS"){
    if (comp_move == "ROCK")    state = "LOSE";
    else                        state = "WIN";
  } else if (your_move == "PAPER"){
    if (comp_move == "ROCK")    state = "WIN";
    else                        state = "LOSE";
  } else if (your_move == "ROCK"){
    if (comp_move == "PAPER")   state = "LOSE";
    else                        state = "WIN";
  }
  text(state, width/2, height/2);
  popStyle();
  
  this.scoreTracker(state);
}

void scoreTracker(String s){
  if (s == "TIE")        tie++;
  else if (s == "WIN")   win++;
  else if (s == "LOSE")  lose++;
}

void displayScore(){
  text("Ties: ", 50, 50);
  text(tie, 100, 50);
  text("Wins: ", 50, 70);
  text(win, 100, 70);
  text("Lose: ", 50, 90);
  text(lose, 100, 90);
}

void replaceHumanHand(){
  for (Hand hand : leap.getHands()){
    PVector handPosition = hand.getSpherePosition();
    if (your_move == "ROCK")        image(r, handPosition.x, handPosition.y);
    if (your_move == "PAPER")       image(p, handPosition.x, handPosition.y, p.width/4, p.height/4);
    if (your_move == "SCISSORS")    image(s, handPosition.x, handPosition.y, p.width/4, p.height/4);
  }
}

void representCompHand(){
  int shift = 150;
  if (comp_move == "ROCK")        image(r, width/2 - shift, height/2);
  if (comp_move == "PAPER")       image(p, width/2 - shift, height/2, p.width/4, p.height/4);
  if (comp_move == "SCISSORS")    image(s, width/2 - shift, height/2, p.width/4, p.height/4);
}

void displayMoves(){
  text("YOUR MOVE: ", width/2, 20);
  this.checkHand();
  text(your_move, width/2 + 100, 20);
  text("COMP MOVE: ", width/2, 40);
  text(comp_move, width/2 + 100, 40);
}

void time(){
  sec = (m / 1000) % 4 + 1;
  sec = int(map(sec, 1, 4, 3, 0));
  if (sec == 0){
    int choice = int(random(1,4));
    comp_move = moves[choice];
  }
}
