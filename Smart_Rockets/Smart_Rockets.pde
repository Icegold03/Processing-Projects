int popSize = 20;
int lifetime = 300;
int cycles;
int fitCorrection = 1;
int generation = 0;
float mutationChance = .01;

Rocket[] population;
ArrayList<DNA> matingpool;
Obstacle[] obstacles;

PVector gravity = new PVector(0, .05);
float forceMultiplier = .2;

PVector targetPos;

void setup() {
  size(600, 400);
  targetPos = new PVector(width-50, height/2);

  population = new Rocket[popSize];
  for (int i = 0; i < population.length; i++) {
    population[i] = new Rocket();
  }
  matingpool = new ArrayList<DNA>();

  obstacles = new Obstacle[2];
  obstacles[0] = new Obstacle(new PVector(width/4, height/4), new PVector(25, height/2));
  obstacles[1] = new Obstacle(new PVector(3*width/5, height/2), new PVector(25, height/2));
}

void draw() {
  background(50);
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i].show();
  }
  for (int i = 0; i < population.length; i++) {
    for (int j = 0; j < obstacles.length; j++) {
      if(obstacles[j].isPointTouching( population[i].pos )){
        population[i].crashed = true;
      }
    }
    population[i].addForce(gravity);
    population[i].addForce(population[i].dna.genes[cycles]);
    population[i].update();
    population[i].show();
  }

  noStroke();
  fill(255, 0, 50);
  ellipse(targetPos.x, targetPos.y, 10, 10);

  if (cycles != lifetime - 1) {
    cycles++;
  } else {


    resetSim();
  }
}

void resetSim() {
  cycles = 0;

  float highestFitness = 0;
  float lowestFitness = 2000000000;

  for (int i = matingpool.size()-1; i > 0; i--) {
    matingpool.remove(matingpool.get(i));
  }

  for (int i = 0; i < population.length; i++) {
    population[i].evaluate();
    if (population[i].fitness > highestFitness) {
      highestFitness = population[i].fitness;
    } else if (population[i].fitness < lowestFitness) {
      lowestFitness = population[i].fitness;
    }
    for (int j = 0; j < map(population[i].fitness, lowestFitness, highestFitness, 1, 100); j++) {
      matingpool.add(population[i].dna);
    }
  }
  for (int i = 0; i < population.length; i++) {
    //Do stuff with matingpool and fitness and stuff
    DNA parent1 = matingpool.get(floor(random(0, matingpool.size())));
    DNA parent2 = matingpool.get(floor(random(0, matingpool.size())));
    DNA child = parent1.crossover(parent2);

    population[i].dna = child;
    population[i].reset();
  }
  generation++;
  println("   Lowest fitness:", lowestFitness, "   Highest fitness:", highestFitness, "   Size of matingpool:", matingpool.size(), "   Generation:", generation);
}
