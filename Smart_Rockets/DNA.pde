class DNA {

  PVector[] genes;

  DNA(int genecount) {
    genes = new PVector[genecount];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = PVector.random2D().setMag(forceMultiplier);
    }
  }

  DNA crossover(DNA other) {
    DNA result = new DNA(other.genes.length);
    for (int i = 0; i < result.genes.length; i++) {
      if (random(1) < mutationChance) {
        result.genes[i] = PVector.random2D().setMag(forceMultiplier);
        continue;
      }
      int r = floor(random(2));
      if (r == 0) {
        result.genes[i] = this.genes[i];
      } else {
        result.genes[i] = other.genes[i];
      }
    }
    return result;
  }
}
