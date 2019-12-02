int speed = 10;
int scl = 20;
int w = 600;
int h = 600;

PFont font;

String fitness;
Population pop;
Snake player;

void setup() {
  size(900, 600);
  frameRate(speed);
  font = loadFont("AgencyFB-Reg-48.vlw");
  
  pop = new Population(1000);
  player = new Snake();
}

void draw() {
  frameRate(speed);
  background(255);
  fill(100);
  drawGrid();
  displayScore();
  
  //player.show();
  //player.move();
  pop.show();
  if(pop.done()) {
     pop.naturalSelection(); 
  }
}

void keyPressed() {
  if (key == CODED) {
      if (keyCode == UP) {
        player.direction = new PVector(0, -scl);
      } else if (keyCode == LEFT) {
        player.direction = new PVector(-scl, 0);
      } else if (keyCode == RIGHT) {
        player.direction = new PVector(scl, 0);
      } else if (keyCode == DOWN) {
        player.direction = new PVector(0, scl);
      }
  } else {
    switch(key) {
      case ' ': 
        pop.players[0].addBody();
        break;
      case 'm':
        pop.mutateAll();
        print("MUTATE\n");
        break;
      case 'w': 
        speed+= 10;
        break;
      case 's':
        if(speed > 10) speed-= 10;
        break;
    }
    
  }
}

void drawGrid() {
  
  //vertical lines
 for(int i = 0; i < h/scl + 1; i++) {
   line(i*scl, 0, i*scl, h);
 }
 
 //horizontal lines
 for(int y = 0; y < w/scl + 1; y++) {
  line(0, y*scl, w, y*scl);
 }
}

void displayScore() {
  textFont(font);
  fill(0);
  textAlign(LEFT);   
  text("HGIH SCORE: " + pop.highScore, 650, 60);
  text("GENERATION: " + pop.gen, 650, 150);
  
  if(!pop.players[0].dead) {
    fill(0,0,255);
    textAlign(LEFT);
    text("BEST", 710, 400);    
  }
  
  textSize(30);
  fill(0, 255, 0);
  fitness = "FITNESS [ " + pop.notDeadI + " ] = " + pop.players[pop.notDeadI].fitness + " ";
  text(fitness, 610, 500);
}
