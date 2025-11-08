class UI {
  Slider[] sliders;
  Checkbox[] checkboxes;

  UI(Slider[] sliders, Checkbox[] checkboxes) {
    this.sliders = sliders;
    this.checkboxes = checkboxes;
  }

  void show() {
    for (int i = 0; i < this.sliders.length; i++) {
      this.sliders[i].show();
    }
    for (int i = 0; i < this.checkboxes.length; i++) {
      this.checkboxes[i].show();
    }
  }

  void update() {
    for (int i = 0; i < this.sliders.length; i++) {
      if (this.sliders[i].mouseOver()) {
        if (mousePressed) {
          this.sliders[i].update();
        }
      }
    }
  }
}
