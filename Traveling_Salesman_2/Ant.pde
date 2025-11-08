int allowedNodeCount;

class Ant {
  /*
  The ant has the following functions:
   Ant()
   comparePossibleConnections();
   chooseAndMove();
   evaluateRoute();
   spreadPheromones();
   traceCycle();
   resetAnt();
   */
  ArrayList<Node> tabu = new ArrayList<Node>();
  Node curNode;
  ArrayList<Node> allowedNodes = new ArrayList<Node>();

  Ant(Node startingTown) {
    tabu.add(startingTown);

    curNode = tabu.get(0);

    for (Node n : nodes) {
      if ( n != curNode ) {
        allowedNodes.add(n);
      }
    }
  }

  // Used for the possibility fraction:
  float numerator;
  float denominator;
  float[] probabilities;

  boolean nodeAllowed;

  Trail curTrail;

  void comparePossibleConnections() {
    print("comparePossibleConnections() called\n");
    // memory leak? Gotta <3 Java gc
    probabilities = new float[allowedNodeCount];

    // Denominator logic
    denominator = 0.0000000001;
    for (Node n : allowedNodes) {
      for (Trail t : trails) {
        if ( t.containsNode(curNode) ) {
          if ( t.containsNode(n)) {
            denominator += pow(t.tau, alpha) * pow(t.eta, beta);
          }
        }
      }
    }

    // Numerator logic
    for (int i = 0; i < allowedNodeCount; i++) {
      for (Trail t : trails) {
        if (!t.containsNode(curNode)) {
          continue;
        } else {
          if (t.containsNode(allowedNodes.get(i))) {
            curTrail = t;
            break;
          } else {
            continue;
          }
        }
      }
      if(curTrail.tau == 0) {
      } else {
      numerator = pow(curTrail.tau, alpha) * pow(curTrail.eta, beta);
      probabilities[i] = numerator/denominator;
    }
    }
  }


  float pAll;
  float pChoice;
  float pCumulative;

  void chooseAndMove() {
    print("chooseandMove() called\n");
    if (allowedNodeCount <= 1) {
      tabu.add(allowedNodes.get(0));
      curNode = allowedNodes.get(0);
      allowedNodes.remove(0);
    } else {
      pAll = 0;
      for (float p : probabilities) {
        pAll += p;
      }
      pChoice = random(pAll);
      pCumulative = 0;
      for (int i = 0; i < probabilities.length; i++) {
        pCumulative += probabilities[i];
        if ( pCumulative >= pChoice ) {

          tabu.add(allowedNodes.get(i));
          curNode = allowedNodes.get(i);
          allowedNodes.remove(i);
          break;
        } else {
          continue;
        }
      }

      curNode = tabu.get(tabu.size()-1);
      allowedNodes.remove(curNode);
    }
  }

  float routeLength;
  void evaluateRoute() {
    print("evaluateRouteLength() called\n");
    routeLength = 0;
    for (int i = 0; i < tabu.size(); i++) {
      switch (i) {
      case 0:
        routeLength += dist(tabu.get(i).x, tabu.get(i).y, tabu.get(tabu.size()-1).x, tabu.get(tabu.size()-1).y);
        break;
      default:
        routeLength += dist(tabu.get(i).x, tabu.get(i).y, tabu.get(i-1).x, tabu.get(i-1).y);
        break;
      }
    }
  }
  void spreadPheromones() {
    // DEBUGGING IF STATEMENT
    if(tabu.size()==1){
      return;
    }
    print("spreadPheromones() called\n");
    for (Trail t : cycle) {
      t.tau += (t.d / routeLength) * Q;
    }
  }
  // This function should be obsolete. --- Optimize by moving logic to the chooseandmove function
  Trail[] cycle = new Trail[nodeCount];
  void traceCycle() {
    // DEBUGGING IF STATEMENT
    if(tabu.size()==1){
      return;
    }
    print("traceCycle() called\n");

    Node n1;
    Node n0;

    Trail trailUsed = trails[0];

    for (int i = 0; i < nodeCount; i++) {
      n1 = tabu.get(i);

      if (i==0) {
        n0 = tabu.get(tabu.size()-1);
      } else {
        n0 = tabu.get(i-1);
      }

      for (Trail t : trails) {
        if (t.containsNode(n0)) {
          if (t.containsNode(n1)) {
            trailUsed = t;
          } else {
            continue;
          }
        } else {
          continue;
        }
      }
      cycle[i] = trailUsed;
    }
  }

  void resetAnt() {
    print("resetAnt() called\n");
    // Tabu
    for (int i = tabu.size()-1; i >= 1; i--) {
      tabu.remove(tabu.get(i));
    }
    // curNode
    curNode = tabu.get(0);
    // AllowedNodes
    allowedNodes.clear();
    for (Node n : nodes) {
      if ( n != curNode ) {
        allowedNodes.add(n);
      }
    }
  }
}
