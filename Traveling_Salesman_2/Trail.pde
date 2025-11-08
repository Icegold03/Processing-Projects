class Trail{
  
  float tau = .000001;
  float eta;
  float d;
  
  
  Node n1, n2;
  
  Trail(Node n_1, Node n_2){
    n1 = n_1;
    n2 = n_2;
    
    d = dist(n1.x, n1.y, n2.x, n2.y);
    eta = 1 / d;
  }
  
  void evaporate(){
    tau *= rho;
  }
  boolean containsNode(Node n){
    if(n == n1){
      return true;
    }
    if(n == n2){
      return true;
    }
    return false;
  }
  
}
