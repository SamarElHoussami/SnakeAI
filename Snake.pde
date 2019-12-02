import java.util.*;

class Snake {
  int w = 600;
  int h = 600;

  float[] vision; //the inputs for the neural net
  float[] moves;
  int score;
  float fitness;
  float timeAlive;
  boolean dead;
  int scl = 20;
  PVector direction;
  PVector startingPos;
  Box head;
  ArrayList<Box> body;
  PVector prevHead;
  Box lastBox;
  Food food;
  int maxLife;
  int backNforth = 0;
  int prevDir = 2;
  int curDir = 2;

  
  
  NeuralNet brain;
  
  Snake() {
    startingPos = new PVector(w/2, h/2);
    head = new Box(startingPos);
    body = new ArrayList<Box>();
    direction = new PVector(scl, 0); //start looking right
    dead = false;
    lastBox = head;
    food = new Food();
    score = 0;
    timeAlive = 0;
    prevHead = new PVector(head.pos.x, head.pos.y);
    brain = new NeuralNet(new int[] {24, 18, 4} );
    moves = new float[4];
    fitness = 0;
    maxLife = 200;
  }
  
  //Grows snake
  void addBody() {
    if(body.size() == 0){
      body.add(new Box(new PVector(prevHead.x, prevHead.y)));
    } else {
      body.add(new Box(new PVector(lastBox.pos.x, lastBox.pos.y)));
    }
    lastBox = body.get(body.size()-1);
  }
  
  void reset() {
    head.pos = new PVector(w/2, h/2);
    clearBody();
    direction = new PVector(scl, 0); //start looking right
    dead = false;
    lastBox = head;
    score = 0;
    food.newFood();
  }
  
  void show() {
    dead = isDead();
      if(!dead) {
       head.show();
       for(Box box: body) {
         box.show();
       }
       food.show();
       
       if(foodEaten()) {
          food.newFood(); 
          addBody();
          score++;
       }
    }
  }
  
  void move() {
    
    prevHead = new PVector(head.pos.x, head.pos.y);
    head.pos.add(direction);
      
    checkBackNForth();
    if(!(dead = isDead()) && !(maxLife <= 0) && !(backNforth > 8)) {
      
      timeAlive += 1;
      maxLife -= 1;
   
      for(int i = body.size() - 1; i >= 0; i--) {
        if(i == 0) { 
          body.get(i).move(prevHead); 
        }  else { 
          body.get(i).move(body.get(i-1).pos); 
        }
      }
      
    } else {
      dead = true;
    }
    
    calcFitness();
  }
  
  boolean foodEaten() {
     if(head.pos.x == food.pos.x && head.pos.y == food.pos.y) {
       maxLife += 100; 
       return true; 
     }
     
     return false;
  }
  
  boolean isDead() {
    if(head.pos.x < 0 || head.pos.x + scl > w) { return true; }
    if(head.pos.y < 0 || head.pos.y + scl > h) { return true; }
    if(isOnTail(head.pos.x, head.pos.y)) {return true; }
    
    return false;
  }
  
  boolean isOnTail(float x, float y) {
    for(Box bod : body) {
      if(x == bod.pos.x && y == bod.pos.y){ 
        return true; 
      }
    } 
    
    return false;
  }
  
  void clearBody() {
    while(!body.isEmpty()) {
      body.remove(0);
    } 
  }
  
  void look2() {
    vision = new float[12];
    
    PVector position = new PVector(head.pos.x, head.pos.y);
    
    ArrayList<PVector> directions = new ArrayList<PVector>(
      Arrays.asList(
         new PVector(-scl, 0), //left
         new PVector(0, -scl), //up
         new PVector(scl, 0), //right
         new PVector(0, scl) //down
      )
    ); 
    
   for(int i = 0, y = 0; i < vision.length; i++, y++) {
     //look in desired direction
     position.add(directions.get(y % directions.size()));
     
     //check for food
     if(position.x == food.pos.x && position.y == food.pos.y) {
       vision[i++] = 1; 
     }
     //check for tail
     if(isOnTail(position.x, position.y)) {
       vision[i++] = 1;  
     }
     //check for wall
     if(position.x < 0 || position.x >= w || position.y < 0 || position.y >= w) {
        vision[i++] = 1;
     }
     //go back to original position
     position = new PVector(head.pos.x, head.pos.y);
   }
  }
  
  //looks in 8 directions to find food,walls and its tail
  void look() {
    vision = new float[24];
    //look left
    float[] tempValues = lookInDirection(new PVector(-scl, 0));
    vision[0] = tempValues[0];
    vision[1] = tempValues[1];
    vision[2] = tempValues[2];
    //look left/up  
    tempValues = lookInDirection(new PVector(-scl, -scl));
    vision[3] = tempValues[0];
    vision[4] = tempValues[1];
    vision[5] = tempValues[2];
    //look up
    tempValues = lookInDirection(new PVector(0, -scl));
    vision[6] = tempValues[0];
    vision[7] = tempValues[1];
    vision[8] = tempValues[2];
    //look up/right
    tempValues = lookInDirection(new PVector(scl, -scl));
    vision[9] = tempValues[0];
    vision[10] = tempValues[1];
    vision[11] = tempValues[2];
    //look right
    tempValues = lookInDirection(new PVector(scl, 0));
    vision[12] = tempValues[0];
    vision[13] = tempValues[1];
    vision[14] = tempValues[2];
    //look right/down
    tempValues = lookInDirection(new PVector(scl, scl));
    vision[15] = tempValues[0];
    vision[16] = tempValues[1];
    vision[17] = tempValues[2];
    //look down
    tempValues = lookInDirection(new PVector(0, scl));
    vision[18] = tempValues[0];
    vision[19] = tempValues[1];
    vision[20] = tempValues[2];
    //look down/left
    tempValues = lookInDirection(new PVector(-scl, scl));
    vision[21] = tempValues[0];
    vision[22] = tempValues[1];
    vision[23] = tempValues[2];

  }
  
  void checkBackNForth() {
     if(prevDir == 2 && curDir == 3) backNforth++;
     else if(prevDir == 3 && curDir == 2) backNforth++;
     else if(prevDir == 0 && curDir == 1) backNforth++;
     else if(prevDir == 1 && curDir == 0) backNforth++;
     else if(prevDir == curDir) { if(backNforth > 0 ) backNforth--; }
     else { if(backNforth > 0) backNforth--; }
  }

  float[] lookInDirection(PVector direction) {
    //set up a temp array to hold the values that are going to be passed to the main vision array
    float[] visionInDirection = new float[3];
 
    PVector position = new PVector(head.pos.x, head.pos.y);//the position where we are currently looking for food or tail or wall
    boolean foodIsFound = false;//true if the food has been located in the direction looked
    boolean tailIsFound = false;//true if the tail has been located in the direction looked 
    float distance = 0;
    //move once in the desired direction before starting 
    position.add(direction);
    distance +=1;

    //look in the direction until you reach a wall
    while (!(position.x < 0 || position.y < 0 || position.x >= 600 || position.y >= 600)) {
      
      //check for food at the position
      if (!foodIsFound && position.x == food.pos.x && position.y == food.pos.y) {
        visionInDirection[0] = 1;
        foodIsFound = true; // dont check if food is already found
      }

      //check for tail at the position
      if (!tailIsFound && isOnTail(position.x, position.y)) {
        visionInDirection[1] = 1/distance;
        tailIsFound = true; // dont check if tail is already found
      }

      //look further in the direction
      position.add(direction);
      distance +=1;
    }

    //set the distance to the wall
    visionInDirection[2] = 1/distance;

    return visionInDirection;
  }
  
  void think() {

    int max = 0;
    prevDir = curDir;
    
    moves = brain.output(vision);
    
    for(int i = 1; i < moves.length; i++) {
      if(moves[i] > moves[max]) {
        max = i;
      }
    }
    
    switch(max) {
     case 0:
       direction = new PVector(0, -scl); curDir = 0;
       break;
     case 1: 
       direction = new PVector(-scl, 0); curDir = 3;
       break;
     case 2: 
       direction = new PVector(scl, 0); curDir = 2;
       break;
     case 3:
       direction = new PVector(0, scl); curDir = 1;
       break;
    }
  }
  
  void calcFitness() {
     //fitness = score*20 + timeAlive*0.10;
     //return fitness; 
      if (score < 10) {
          fitness = floor(timeAlive *timeAlive * pow(2, (floor(score))));
        } else {
          //grows slower after 10 to stop fitness from getting stupidly big
          //ensure greater than len = 9
          fitness =  timeAlive * timeAlive;
          fitness *= pow(2, 10);
          fitness *=(score-9);
        }
  }
  
   Snake clone() {
    Snake clone = new Snake();
    clone.brain = brain.clone();
    return clone;
  }
  
  Snake crossover(Snake parent) {
    Snake child = new Snake();
    child.brain = this.brain.crossover(parent.brain);
    return child;
  }
}
