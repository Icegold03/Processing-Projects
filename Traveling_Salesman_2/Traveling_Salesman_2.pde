// Weight of trailintensity in ant decision making
float alpha = 2;
// Weight of visibility in ant decision making
float beta = 2;
// Amount of trail to spread throughout the ants routes
float Q = .5;
// Coefficient of leftover pheromones after evaporation
float rho = .05;

int nodeCount = 8;
int antCountPerNode = 10;

Node[] nodes = new Node[nodeCount];
Trail[] trails;
Ant[] ants = new Ant[nodeCount * antCountPerNode];


void setup() {
  size(600, 400);

  initNodes();
  initTrails();
  initAnts();
}

void draw() {
  background(50);
  drawTrails();
  drawNodes();
  textSize(25);
  text(cycleCount, 10, height-10);
}
float time;
void keyPressed() {
  print(keyCode);
  if (keyCode == 32) {
    time = millis();
    runAntSystemCycle();
    time = millis() - time;
    print("Cycle: ", cycleCount, " took: ", time, " ms");
  }
}
int cycleCount = 0;
ArrayList<Trail> newTrailsArray = new ArrayList<Trail>();
void runAntSystemCycle() {
  cycleCount++;
  allowedNodeCount = nodeCount - 1;
  for (Trail t : trails) {
    t.evaporate();
  }
  while (allowedNodeCount > 0) {
    for (Ant a : ants) {
      a.comparePossibleConnections();
      a.chooseAndMove();
    }
    allowedNodeCount--;
  }
  for (Ant a : ants) {
    a.traceCycle();
    a.evaluateRoute();
    a.spreadPheromones();
    a.resetAnt();
  }
}

float colorStrength;
void drawTrails() {
  // stroke(255, 0, 0);
  for (Trail t : trails) {
    colorStrength = map(t.tau/t.d, 0, .01, 0, 255);
    stroke(255, 0, 0, colorStrength);
    line(t.n2.x, t.n2.y, t.n1.x, t.n1.y);
    PVector avgPos = new PVector((t.n2.x + t.n1.x)/2, (t.n2.y + t.n1.y)/2);
    textSize(10);
    fill(255, 255, 255, colorStrength);
    text(t.tau, avgPos.x, avgPos.y);
  }
}

void drawNodes() {
  noStroke();
  fill(255);
  for (Node n : nodes) {
    ellipse(n.x, n.y, 8, 8);
  }
}

void initNodes() {
  // Initialize nodes at random points
  for (int i = 0; i < nodes.length; i++) {
    nodes[i] = new Node(random(width), random(height));
  }
}

void initTrails() {
  // The number of connections between nodes are "c = (n-1) + (n-2) + ... + (n-n)"
  int trailCount = 0;
  for (int n = nodeCount; n > 0; n--) {
    trailCount += n - 1;
  }

  // Initialize trails between nodes
  trails = new Trail[trailCount];
  int trailsInitialized = 0;
  for (int i = 0; i < nodeCount; i++) {
    // This inner loop is genious and I'm proud of coming up with it :D
    for (int j = i+1; j < nodeCount; j++) {
      trails[trailsInitialized] = new Trail(nodes[i], nodes[j]);
      trailsInitialized++;
    }
  }
}

void initAnts() {
  for (int i = 0; i < nodeCount; i++) {
    for (int j = 0; j < antCountPerNode; j++) {
      ants[i*antCountPerNode+j] = new Ant(nodes[i]);
    }
  }
}
