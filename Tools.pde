class Tools {
  
  Tools() {
    
  }
    

  
  void printArray(float[] a) {
     print("[");
     for(int i = 0; i < a.length; i++) {
        print(a[i] + ", "); 
     }
     print("]\n");
  }
  
  void printDoubleArray(float[][] a) {
     print("[");
     for(int i = 0; i < a.length; i++) {
        print("\n[");
        for(int y = 0; y < a[i].length; y++) {
          print(a[i][y] + ", "); 
        }
        print("]\n");
     }
     print("]\n");
  }
  
  void printTripleArray(float[][][] a) {
      print("[");
     for(int i = 1; i < a.length; i++) {
        print("[");
        for(int y = 0; y < a[i].length; y++) {
          print("[");
          for(int z = 0; z < a[i][y].length; z++) {
             print(a[i][y][z] + ", "); 
          }
          print("]\n");
        }
        print("]\n");
     }
     print("]\n");
  }
}
