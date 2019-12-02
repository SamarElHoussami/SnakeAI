class Box {
 
  int size;
  PVector pos;
  
  Box(PVector Pos) {
    size = 20;
    pos = Pos;
  }
  
  void show() {
    fill(0);
    rect(pos.x, pos.y, size, size);
  }
  
  void move(PVector newPos) {
     pos = new PVector(newPos.x, newPos.y); 
  }
}
