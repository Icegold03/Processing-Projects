class Flock {

  Boid[] boids;
  Grid grid;

  Flock(int numOfBoids, PVector spawnPos, PVector spawnPosSize, Grid grid) {
    boids = new Boid[numOfBoids];
    this.grid = grid;
    for (int i = 0; i < boids.length; i++) {
      boids[i] = new Boid(random(spawnPos.x+spawnPosSize.x), random(spawnPos.y,spawnPosSize.y), this, this.grid);
    }
  }
  void update() {
    for (int i = 0; i < boids.length; i++) {
      boids[i].BoidsInRange(boids);
      boids[i].update();
    }
  }
  void show() {

    for (int i = 0; i < boids.length; i++) {
      boids[i].show();
    }
  }
  
  boolean contains(Boid b){
    for (int i = 0; i < boids.length; i++){
      if (boids[i] == b){
        return true;
      } else {
        continue;
      }
    }
    return false;
  }
}
