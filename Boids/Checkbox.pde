class Checkbox {
  boolean state;
  PVector pos;
  float len;

  Checkbox(PVector pos, float len, boolean startState) {
    this.pos = pos;
    this.len = len;
    this.state = startState;
  }
  
  void show() {
    strokeWeight(1);
    if (this.state) {
      stroke(0);
      fill(255);
      rect(this.pos.x, this.pos.y, len, len);
      fill(50);
      noStroke();
      rectMode(CENTER);
      rect(this.pos.x + len / 2, this.pos.y + len / 2, len * 3 / 4, len * 3 / 4);
      rectMode(CORNER);
    } else {
      stroke(0);
      fill(255);
      rect(this.pos.x, this.pos.y, len, len);
    }
  }
  
  void changeState(){
    this.state = !this.state;
  }
  
  boolean mouseOver() {
    if (mouseX > this.pos.x && mouseX < this.pos.x + this.len &&
      mouseY > this.pos.y && mouseY < this.pos.y + this.len) {
      return true;
    }
    return false;
  }
}
