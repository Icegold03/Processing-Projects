Grid g;
Grid visualG;

static PImage Birb;
static UI ui;

//Should be global
Slider spdSlider;
float speed = 2;
float borderSize = 200;
float fovR = 75;
float boidLength = 15;
Checkbox followCheckbox;
boolean following = false;

//Seperation
float r1Weight = .075;
Slider r1Slider;
Checkbox r1checkbox;

//Alignment
float r2Weight = .2;
Slider r2Slider;
Checkbox r2checkbox;

//Cohesion
float r3Weight = .002;
Slider r3Slider;
Checkbox r3checkbox;

//Edge avoidance
float r4Weight = .001;


void setup() {
  //size(600, 400);
  fullScreen();

  g = new Grid(125, 1, 1);
  //visualG = new Grid(0, 16, 9);

  Birb = loadImage("birb.jpg");
  r1Slider = new Slider("Seperation", new PVector(20, 20), new PVector(200, 20), .075, .0, .375);
  r2Slider = new Slider("Alignment", new PVector(20, 50), new PVector(200, 20), .2, 0, 1);
  r3Slider = new Slider("Cohesion", new PVector(20, 80), new PVector(200, 20), .002, 0, .01);
  spdSlider = new Slider("Speed", new PVector(20, 110), new PVector(200, 20), 5, .1, 10);
  r1checkbox = new Checkbox(new PVector(230, 20), 20, false);
  r2checkbox = new Checkbox(new PVector(230, 50), 20, false);
  r3checkbox = new Checkbox(new PVector(230, 80), 20, false);
  followCheckbox = new Checkbox(new PVector(width-30, 10), 20, false);

  ui = new UI(new Slider[4], new Checkbox[4]);
  ui.sliders[0] = r1Slider;
  ui.sliders[1] = r2Slider;
  ui.sliders[2] = r3Slider;
  ui.sliders[3] = spdSlider;
  ui.checkboxes[0] = r1checkbox;
  ui.checkboxes[1] = r2checkbox;
  ui.checkboxes[2] = r3checkbox;
  ui.checkboxes[3] = followCheckbox;
}

void draw() {
  background(50);
  push();
  if (followCheckbox.state) {
    PVector translation = new PVector(width/2 - g.flocks[0][0].boids[0].pos.x, height/2 - g.flocks[0][0].boids[0].pos.y);
    translate(translation.x, translation.y);
    g.flocks[0][0].boids[0].isFollowed = true;
    following = true;
  } else {
    g.flocks[0][0].boids[0].isFollowed = false;
    following = false;
  }

  g.update();
  g.show();
  //visualG.show();
  pop();

  ui.update();
  ui.show();
  
  speed = spdSlider.getValue();
  r1Weight = r1Slider.getValue();
  r2Weight = r2Slider.getValue();
  r3Weight = r3Slider.getValue();
}
void mouseClicked() {
  for (int i = 0; i < ui.checkboxes.length; i++) {
    if (ui.checkboxes[i].mouseOver()) {
      ui.checkboxes[i].changeState();
    }
  }
}
float clamp(float val, float min, float max) {
  if (val < min) {
    return min;
  } else if (val > max) {
    return max;
  } else {
    return val;
  }
}
