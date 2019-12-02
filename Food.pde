class Food {
 
  int w = 600;
  int h = 600;
  int scl = 20;
  PVector pos = new PVector(0, 0);
  
  Food() {
    newFood();
  }
  
  void newFood() {
    
    pos.x = scl * (int)random(w/scl);
    pos.y = scl * (int)random(h/scl);
  }
  
  
  void show() {
     fill(255, 0, 0);
     rect(pos.x, pos.y, scl, scl);
  }
}
