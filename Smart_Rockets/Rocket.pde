class Rocket {
  PVector pos;
  PVector vel;
  PVector acc;

  boolean crashed;
  boolean finished;

  DNA dna;

  float fitness = 0;
  int timeOfDeath = -1;

  Rocket() {
    dna = new DNA(lifetime);

    this.pos = new PVector(5, height/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }

  void reset() {
    this.pos = new PVector(5, height/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);

    this.fitness = 0;
    this.crashed = false;
    this.finished = false;
    this.timeOfDeath = -1;
  }

  void update() {
    if (this.pos.x < 0 || this.pos.x > width || this.pos.y < 0 || this.pos.y > height) {
      this.crashed = true;
      this.timeOfDeath = cycles;
    }
    if(dist(this.pos.x, this.pos.y, targetPos.x, targetPos.y) <= 10){
      finished = true;
    }
    if (!crashed && !finished) {
      this.vel.add(this.acc);
      this.acc.set(0, 0);
      this.pos.add(this.vel);
    }
  }

  void addForce(PVector force) {
    this.acc.add(force);
  }

  void show() {
    noStroke();
    fill(255);
    ellipse(pos.x, pos.y, 5, 5);
  }

  void evaluate() {
    float d = dist(targetPos.x, targetPos.y, this.pos.x, this.pos.y);

    this.fitness = (targetPos.x - d) * fitCorrection;
    if (crashed) {
      this.fitness *= .1;

      this.fitness += this.timeOfDeath;
    }
    if (finished) {
      this.fitness *= 25;
    }
  }
}
