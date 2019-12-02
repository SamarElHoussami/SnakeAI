class Population {

  Snake[] players;  
  
  Snake globalBestPlayer;
  float globalBestScore;
  int highScore;          //keeps track of highest number of apples eaten throughout the generations
    
  int notDeadI = 0;      //index of next alive snake in array
  int gen;

  Tools t;

  int popID;
  
  Population(int size){
    t = new Tools();
    
    players = new Snake[size];
    
    for (int i = 0; i < players.length; i++) {
      players[i] = new Snake();
    }
    
    popID = floor(random(20000));
    
    globalBestPlayer = players[0].clone();

    gen = 0;
    highScore = 0;
    globalBestScore = 0;
  }
  
  //uses a genetic algorithm to reproduce snakes and create the next generation
  void naturalSelection() {
    
    setBestPlayer();
    
    Snake[] newPlayers = new Snake[players.length];
    
    newPlayers[0] = globalBestPlayer.clone();  //add global best player to each generation

    for(int i = 1; i < players.length; i++) {
         newPlayers[i] = selectPlayer().crossover(selectPlayer()); 
         newPlayers[i].brain.mutate(0.01);    
    }
  
    players = clonePlayers(newPlayers);

    gen += 1;
  }
  
  //clones every player
  Snake[] clonePlayers(Snake[] newPlayers) {
      Snake[] clones = new Snake[newPlayers.length];
      
     for(int i = 0; i < newPlayers.length; i++) {
       clones[i] = newPlayers[i].clone();
     }
     
     return clones;
  }
  
  void mutateAll() {
    for(int i = 0; i < players.length; i++) {
       players[i].brain.mutate(0.4);
     }
  }
  
  //updates best global payer
  void setBestPlayer() {
    
    //find the best player in this generation
    int max = 0;
    for(int i = 1; i < players.length; i++) {
       if(players[i].fitness > players[max].fitness) {
         max = i;
       }
    }
 
    //if best player is better than best global player, set it to best global player
    if(players[max].fitness > globalBestScore) {
      globalBestScore = players[max].fitness;
      globalBestPlayer = players[max].clone();
    }
  }
  
  //selects a player in the generation based on their fitness
  Snake selectPlayer() {
    float fitnessSum = 0;
    for(int i = 0; i < players.length; i++) {
       fitnessSum += players[i].fitness;
    }
    
    float rand = random(fitnessSum);
    
    float runningSum = 0;

    for (int i = 0; i< players.length; i++) {
      runningSum += players[i].fitness; 
      if (runningSum > rand) {
        return players[i];
      }
    }
    
    return players[0];
  }
  
  void saveTopPlayer() {
    //globalBestPlayer.savePlayer(notDeadI, highScore, popID);
  }
  
  //calculates fitness of entire generation
  float getGlobalFitness(Snake[] plays) {
    float fitness = 0;
    for(int i = 0; i < plays.length; i++) {
        fitness += plays[i].fitness;
    }
    
    return fitness;
  }
  
  //checks if all snakes in generation have died
  boolean done() {
    int i;
    for(i = 0; i < players.length; i++) {
       if(!players[i].dead) {
         notDeadI = i;
         return false; 
       }
    }

    return true; 
  }
  
  //show best snake
  //if dead, show snake that's not dead
  void show() {
    if(!players[0].dead)
      players[0].show();
      
     else {
       players[notDeadI].show(); 
     }
     
    updateAlive();
  }

  //update all non dead snakes
  void updateAlive() {
    for (int i = 0; i< players.length; i++) {
      if (!players[i].dead) {
        players[i].look();//get inputs for brain 
        players[i].think();//use outputs from neural network
        players[i].move();//move the player according to the outputs from the neural network
        if(players[i].score > highScore) highScore = players[i].score;
      } 
    }
  }
}
