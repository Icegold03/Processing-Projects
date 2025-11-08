color curStroke = color(0);
color curFill = color(255,0,0);
boolean eraserSelected = false;
void selectPencil() {
  println("Pencil Selected");
  eraserSelected = false;
}
void selectEraser(){
  println("Eraser selected");
  eraserSelected = true;
}

int[] brushSizes = {
  
//0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
  1, 2, 3, 4, 6, 7, 9, 12, 15, 20, 25, 30, 35, 40
  
};
