int windowSizeX = 1440;
int windowSizeY = 810;

int pmouseX;
int pmouseY;

boolean isCursorOnUI;
int brushSizeSelected = 0;

void setup() {
  size(1440, 810);
  background(255);
  stroke(0);
  surface.setResizable(false);
  surface.setTitle("Paint.Weber");
  drawUI();
  selectPencil();
  stroke(curStroke);
}

void draw() {
  if (checkForUI(mouseX, mouseY) || checkForUI(pmouseX, pmouseY)) {
    isCursorOnUI = true;
  } else {
    isCursorOnUI = false;
  }

  if (mousePressed) {
    if (!isCursorOnUI) {
      if (eraserSelected == true){
        stroke(255);
      } else {
        updateColorSelected();
      }
      line(pmouseX, pmouseY, mouseX, mouseY);
    } else {
      updateColorPicker();
    }
  }

  pmouseX = mouseX;
  pmouseY = mouseY;
}

void mouseClicked() {
  if (checkForUI(mouseX, mouseY)) {
    if (boxClicked (sizeBoxes) != -1) {
      brushSizeSelected = boxClicked (sizeBoxes);
      strokeWeight(brushSizes[brushSizeSelected]);
      stroke(curStroke);
    } else if (boxClicked (brushBoxes) != -1){
      int x = boxClicked (brushBoxes);
      println(x);
      switch(x){
        
        case 0:
          selectPencil();
          break;
        case 1:
          selectEraser();
          break;
        case 2:
          break;
        case 3:
          break;
        case 4:
          break;
        case 5:
          break;
        case 6:
          break;
        case 7:
          break;
        
      }
    }
  }
}
void mouseReleased() {
  drawUI();
}

int boxClicked(Table UIBoxes) {
  for (int i = 0; i < UIBoxes.getRowCount(); i++) {
    int leftEdge = UIBoxes.getInt(i, 0);
    int topEdge = UIBoxes.getInt(i, 1);
    int rightEdge = leftEdge + UIBoxes.getInt(i, 2);
    int bottomEdge = topEdge + UIBoxes.getInt(i, 3);

    if (mouseX > leftEdge && mouseX < rightEdge && mouseY > topEdge && mouseY < bottomEdge) {
      return i;
    }
  }
  return -1;
}
