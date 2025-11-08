class Obstacle {

  PVector pos;
  PVector size;

  Obstacle(PVector pos, PVector size) {
    this.pos = pos;
    this.size = size;
  }

  boolean isPointTouching(PVector point) {
    if (point.x > pos.x && point.x < pos.x + size.x && point.y > pos.y && point.y < pos.y + size.y) {
      return true;
    }
    return false;
  }
  
  void show(){
    stroke(0);
    strokeWeight(1);
    fill(150, 200, 100);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
