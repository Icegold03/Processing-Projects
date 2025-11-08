class Boid {

  //Need to be local
  PVector pos;
  PVector dir;
  Flock parentFlock;
  Grid parentGrid;
  ArrayList<Boid> curInRange;
  boolean isFollowed = false;

  // float maxTurnAngle = (TWO_PI / 360) * .005;

  Boid(float x, float y, Flock parentFlock, Grid parentGrid) {
    this.pos = new PVector();
    this.pos.x = x;
    this.pos.y = y;
    this.dir = new PVector(random(-1, 1), random(-1, 1));
    this.parentFlock = parentFlock;
    this.curInRange = new ArrayList<Boid>();
  }

  void BoidsInRange(Boid[] allBoids) {
    ArrayList<Boid> toRemove = new ArrayList<Boid>();
    for (int i = 0; i < allBoids.length; i++) {
      if (allBoids[i] == this) {
        continue;
      }
      if (dist(this.pos.x, this.pos.y, allBoids[i].pos.x, allBoids[i].pos.y) < fovR) {
        //if (not already in this.curInRange) ...
        if (!this.curInRange.contains(allBoids[i])) {
          this.curInRange.add(allBoids[i]);
        }
      } else {
        if (this.curInRange.size() > 0) {
          for (Boid b : this.curInRange) {
            if (b == allBoids[i]) {
              toRemove.add(b);
            }
          }
        }
      }
    }
    for (int i = 0; i < toRemove.size(); i++) {
      this.curInRange.remove(toRemove.get(i));
      toRemove.remove(toRemove.get(i));
    }
  }

  PVector r1 = new PVector();
  float flockMinDist;
  Boid closestBoid;
  PVector r2 = new PVector();
  PVector flockAvgDir = new PVector();
  PVector r3 = new PVector();
  PVector flockAvgPos = new PVector();
  PVector r4 = new PVector();

  PVector dirAdd = new PVector();

  void update() {

    /*
    if (this.pos.x > width)
     this.pos.x -= width;
     if (this.pos.x < 0)
     this.pos.x += width;
     if (this.pos.y > height)
     this.pos.y -= height;
     if (this.pos.y < 0)
     this.pos.y += height;
     */
    if (this.pos.x < borderSize ||
      this.pos.x > width - borderSize ||
      this.pos.y < borderSize ||
      this.pos.y > height - borderSize) {

      // Rule 4 before: EdgeAvoidance
      this.r4.set(0, 0);
      // Rule 4:
      if (this.pos.x < borderSize) {
        this.r4.x += borderSize - this.pos.x;
      } else if (this.pos.x > width - borderSize) {
        this.r4.x += (width - borderSize) - this.pos.x;
      }
      if (this.pos.y < borderSize) {
        this.r4.y += borderSize - this.pos.y;
      } else if (this.pos.y > height - borderSize) {
        this.r4.y += (height - borderSize)-this.pos.y;
      }
      this.dirAdd.set(
        (this.r4.x) * r4Weight,
        (this.r4.y) * r4Weight);
    }

    if (this.curInRange.size() > 0 ) {
      // Rule 1 before: Seperation
      this.r1.set(0, 0);
      this.flockMinDist = 100000;
      // Rule 2 before: Alignment
      this.flockAvgDir.set(0, 0);
      // Rule 3 before: Cohesion
      this.flockAvgPos.set(0, 0);

      for (Boid b : this.curInRange) {
        // Rule 1:
        if (b.pos.copy().sub(this.pos).mag() < this.flockMinDist) {
          this.closestBoid = b;
          this.flockMinDist = dist(this.closestBoid.pos.x, this.closestBoid.pos.y, this.pos.x, this.pos.y);
        }

        // Rule 2:
        this.flockAvgDir.x += b.dir.x;
        this.flockAvgDir.y += b.dir.y;

        // Rule 3
        this.flockAvgPos.x += b.pos.x;
        this.flockAvgPos.y += b.pos.y;
      }
      //r1 after: Seperation
      if (this.flockMinDist < fovR) {
        this.r1.set(this.pos.copy().sub(this.closestBoid.pos));
        this.r1.setMag((fovR - this.flockMinDist) * r1Weight);
      }
      //Rule 2 after: Alignment
      this.flockAvgDir.div(this.curInRange.size());
      this.r2.set(this.flockAvgDir);
      // Rule 3 after: Cohesion
      this.flockAvgPos.div(this.curInRange.size());
      this.r3.set(this.flockAvgPos);

      this.dirAdd.set(
        (this.r1.x - this.dir.x) * r1Weight +
        (this.r2.x - this.dir.x) * r2Weight +
        (this.r3.x - this.pos.x) * r3Weight +
        (this.r4.x             ) * r4Weight,

        (this.r1.y - this.dir.y) * r1Weight +
        (this.r2.y - this.dir.y) * r2Weight +
        (this.r3.y - this.pos.y) * r3Weight +
        (this.r4.y             ) * r4Weight);

      /*if (this.dirAdd.heading() - this.dir.heading() > maxTurnAngle) {
       dirAdd.set(cos(maxTurnAngle), sin(maxTurnAngle));
       } else if (this.dirAdd.heading() - this.dir.heading() > maxTurnAngle) {
       dirAdd.set(cos(-maxTurnAngle), sin(-maxTurnAngle));
       }*/
    }
    if (this.dirAdd.copy().add(this.dir).mag() != 0) {
      this.dir.add(dirAdd);
    };
    this.dir.setMag(speed);
    this.pos = this.pos.add(this.dir);
    //this.pos.x = clamp(this.pos.x, 0, width);
    //this.pos.y = clamp(this.pos.y, 0, height);
  }

  void show() {


    // FOV RANGE
    if (isFollowed) {
      noStroke();
      fill(#81FF8A, 10);
      ellipse(this.pos.x, this.pos.y, 2 * fovR, 2 * fovR);
    }

    // LINES TO BoidS IN RANGE
    if (ui.checkboxes[0].state) {
      if (this.curInRange.size() > 0) {
        if (!following || this.isFollowed) {
          strokeWeight(1);
          stroke(255, 255, 0, 100);
          for (Boid b : this.curInRange) {
            line(this.pos.x, this.pos.y, b.pos.x, b.pos.y);
          }
        }
        if (this.isFollowed) {
          strokeWeight(3);
          stroke(255, 255, 0, 100);

          line(this.pos.x, this.pos.y, this.pos.x-(closestBoid.pos.x-this.pos.x), this.pos.y-(closestBoid.pos.y-this.pos.y));
          strokeWeight(7.5);
          point(this.pos.x-(closestBoid.pos.x-this.pos.x), this.pos.y-(closestBoid.pos.y-this.pos.y));
        }
      }
    }

    // LINES TO SHOW AVERAGE DIRECTION
    if (ui.checkboxes[1].state) {
      if (!following || this.isFollowed) {
        if (this.curInRange.size() > 0) {
          stroke(255, 0, 255, 100);
          strokeWeight(2.5);
          line(this.pos.x, this.pos.y, this.pos.x + this.flockAvgDir.x * fovR/2 / speed, this.pos.y + this.flockAvgDir.y * fovR/2 / speed);
        }
      }
    }

    // LINES TO SHOW AVERAGE POSITION
    if (ui.checkboxes[2].state) {
      if (!following || this.isFollowed) {
        if (this.curInRange.size() > 0) {
          strokeWeight(1);
          stroke(0, 255, 255, 100);

          for (Boid b : this.curInRange) {
            line(b.pos.x, b.pos.y, this.flockAvgPos.x, this.flockAvgPos.y);
          }
          strokeWeight(5);
          stroke(0, 255, 255, 100);
          point(this.flockAvgPos.x, this.flockAvgPos.y);
        }
      }
    }

    // Boid VISUAL
    //imageMode(CENTER);
    //image(Birb, this.pos.x, this.pos.y, 75, 75);
    strokeWeight(1);
    fill(255);
    stroke(0);
    ellipse(this.pos.x, this.pos.y, 5, 5);

    // DIR VISUAL
    stroke(255);
    line(this.pos.x, this.pos.y, this.pos.x + this.dir.x / this.dir.mag() * boidLength, this.pos.y + this.dir.y / this.dir.mag() * boidLength);
  }
}
