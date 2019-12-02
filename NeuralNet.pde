class NeuralNet {
 float[][] output;      //output[layer][neuron]
 float[][] bias;        //bias[layer][neuron]
 float[][][] weights;   //weights[layer][neuron][prevNeuron]
 
 int NETWORK_SIZE;          //number of layers in network
 int[] NETWORK_LAYER_SIZE;  //sizes of each layer
  
  NeuralNet(int[] lSizes) {
    NETWORK_LAYER_SIZE = lSizes;
    NETWORK_SIZE = NETWORK_LAYER_SIZE.length;
    
    output = new float[NETWORK_SIZE][];
    bias = new float[NETWORK_SIZE][];
    weights = new float[NETWORK_SIZE][][];
    
    for(int i = 0; i < NETWORK_SIZE; i++) {
      output[i] = new float[NETWORK_LAYER_SIZE[i]];
      bias[i] = createRandomArray(NETWORK_LAYER_SIZE[i], -1 , 1);
      
      //every layer except the first one (input layer) has weights
      if(i > 0) {
         weights[i] = createRandomDoubleArray(NETWORK_LAYER_SIZE[i], NETWORK_LAYER_SIZE[i-1], -1, 1); 
      }
    }
  }
  
  float[] output(float[] input) {
       output[0] = input;  //set first layer of outputs to input
       
       for(int layer = 1; layer < NETWORK_SIZE; layer++) {
         for(int neuron = 0; neuron < NETWORK_LAYER_SIZE[layer]; neuron++) {
           
           float sum = bias[layer][neuron];
           for(int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZE[layer-1]; prevNeuron++) {
              sum += output[layer-1][prevNeuron] * weights[layer][neuron][prevNeuron];
           }
           output[layer][neuron] = sigmoid(sum);
         }
     }
     
     return output[NETWORK_SIZE - 1];
  }
  
  float sigmoid(float x) {
    float y = 1 / (1 + pow((float)Math.E, -x));
    return y;
  }
  
  float[] createRandomArray(int size, float lower, float upper) {
     float[] rArray = new float[size];
     
     for(int i = 0; i < size; i++) {
        rArray[i] = random(lower, upper); 
     }
     
     return rArray;
  }
  
  float[][] createRandomDoubleArray(int sizeX, int sizeY, float lower, float upper) {
     float[][] rArray = new float[sizeX][sizeY];
     for(int i = 0; i < sizeX; i++) {
        rArray[i] = createRandomArray(sizeY, lower, upper); 
     }
     
     return rArray;
  }
  
  //returns neural net made from combining two neural nets
  NeuralNet crossover(NeuralNet parent) {
    NeuralNet child = new NeuralNet(NETWORK_LAYER_SIZE);
    float rand;
     
     //combine weigths
     for(int i = 1; i < weights.length; i++) {
        for(int y = 0; y < weights[i].length; y++) {
           for(int z = 0; z < weights[i][y].length; z++) {
              rand = random(1);
              if(rand > 0.5){    //50% chance of having each parent's value
                child.weights[i][y][z] = parent.weights[i][y][z];
              } else {
                child.weights[i][y][z] = this.weights[i][y][z];
              }
           }
        }
     }
     
     //combine biases
     for(int i = 0; i < bias.length; i++) {
        for(int y = 0; y < bias[i].length; y++) {
            rand = random(1);
            if(rand > 0.5){
              child.bias[i][y] = parent.bias[i][y];
            } else {
              child.bias[i][y] = this.bias[i][y];
            }
        }
     }
     
     return child;
  }
  
  //Mutates neural net according to mutation rate
  void mutate(float mutationRate) {
    float rand;
    
    //mutate weights
    for(int i = 1; i < weights.length; i++) {
        for(int y = 0; y < weights[i].length; y++) {
           for(int z = 0; z < weights[i][y].length; z++) {
              rand = random(1);
              if(rand < mutationRate){
                weights[i][y][z] += randomGaussian()/5;
                
                if(weights[i][y][z] > 1) weights[i][y][z] = 1;
                if(weights[i][y][z] < -1) weights[i][y][z] = -1;
              }
           }
        }
     }
     
     //mutate biases
     for(int i = 0; i < bias.length; i++) {
        for(int y = 0; y < bias[i].length; y++) {
            rand = random(1);
              if(rand < mutationRate){
                bias[i][y] += randomGaussian()/5;
                
                if(bias[i][y] > 1) bias[i][y] = 1;
                if(bias[i][y] < -1) bias[i][y] = -1;
              } 
        }
     }
  }
  
  //clones neural net
  NeuralNet clone() {
     NeuralNet clone = new NeuralNet(NETWORK_LAYER_SIZE);
    
    //clone weights
     for(int i = 1; i < weights.length; i++) {
        for(int y = 0; y < weights[i].length; y++) {
           for(int z = 0; z < weights[i][y].length; z++) {
              clone.weights[i][y][z] = this.weights[i][y][z];
           }
        }
     }
     
     //clone biases
      for(int i = 0; i < bias.length; i++) {
        for(int y = 0; y < bias[i].length; y++) {
           clone.bias[i][y] = this.bias[i][y];
        }
     }
     
     return clone;
  }
}
