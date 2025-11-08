class Grid{
  int cols, rows;
  PVector cellSize;
  Flock[][] flocks;
  
  Grid(int numOfBoids, int cols, int rows){
    this.cols = cols;
    this.rows = rows;
    
    this.cellSize = new PVector(width / this.cols, height / this.rows);
    
    int boidsPerCell = floor(numOfBoids / this.cols / this.rows);
    
    flocks = new Flock[cols][rows];
    for (int x = 0; x < cols; x++){
      for (int y = 0; y < rows; y++){
        flocks[x][y] = new Flock(boidsPerCell, new PVector(x*cellSize.x, y*cellSize.y), cellSize, this);
      }
    }
  }
  
  void update(){
    for (int x = 0; x < cols; x++){
      for (int y = 0; y < rows; y++){
        flocks[x][y].update();
      }
    }
  }
  
  void show(){
    for (int x = 0; x < cols; x++){
      for (int y = 0; y < rows; y++){
        flocks[x][y].show();
        
        stroke(0);
        //line(x * cellSize.x, 0, x * cellSize.x, height);
        //line(0, y * cellSize.y, width, y * cellSize.y);
      }
    }
  }
  
}
