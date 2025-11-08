class Slider {
  PVector pos;
  PVector size;
  float curPercent;
  String text;
  float min, max;

  Slider(String text, PVector pos, PVector size, float startValue, float min, float max) {
    this.text = text;
    this.pos = pos;
    this.size = size;
    this.curPercent = map(startValue, min, max, 0, 1);
    this.min = min;
    this.max = max;
  }

  void show() {
    strokeWeight(1);
    stroke(0);
    fill(0);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    fill(255);
    rect(this.pos.x, this.pos.y, map(curPercent, 0, 1, 0, this.size.x), this.size.y);

    fill(150, 50, 75);
    textAlign(LEFT, CENTER);
    textSize(20);
    text(this.text, this.pos.x + 10, this.pos.y + this.size.y/2 -2.5);
  }

  float getValue() {
    return map(curPercent, 0, 1, this.min, this.max);
  }
  
  void update(){
    curPercent = map(mouseX, this.pos.x, this.pos.x + this.size.x, 0, 1);
  }
  
  boolean mouseOver() {
    if (mouseX > this.pos.x && mouseX < this.pos.x + this.size.x &&
      mouseY > this.pos.y && mouseY < this.pos.y + this.size.y) {
      return true;
    }
    return false;
  }
}
