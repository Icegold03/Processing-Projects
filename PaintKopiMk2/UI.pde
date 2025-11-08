int marginHeight = 100;
color marginColor = color(200);
color outliningColor = color(0);

//in margin
int boxSize = 40;
int boxSpace = 10;
int boxOrgX = 5;
int boxOrgY = 5;
int boxCount = 14;
int drawAreaX = windowSizeX * 1/5;
color boxFill = color(255);
color boxLines = color(0);
Table sizeBoxes;
Table brushBoxes;

//color picker
int curHue = 150;
int curSat = 255;
int curBright = 150;

int hueXPos = 4*(windowSizeX/5);
int hueYPos = 1*(marginHeight/4)-10;
int satXPos = 4*(windowSizeX/5);
int satYPos = 2*(marginHeight/4)-10;
int brightXPos = 4*(windowSizeX/5);
int brightYPos = 3*(marginHeight/4)-10;
int sliderHeight = 20;

void drawUI() {

  //making the header
  fill(marginColor);
  stroke(outliningColor);
  strokeWeight(1);
  
  rect(-1, 0, windowSizeX+1, marginHeight);
  
  //sizeBoxes
  sizeBoxes = drawBoxes(boxOrgX, boxOrgY, drawAreaX, boxCount, boxSize, boxSpace, boxLines, boxFill);
  sizeBoxIcons();
  
  //BrushBoxes
  brushBoxes = drawBoxes(400, 5, 40*3, 8, boxSize, boxSpace, boxLines, boxFill);
  brushBoxIcons();
  

  //color picker  
  colorMode(HSB, 255);
  for (int i = 0; i < 255; i++){
    stroke(i, curSat, curBright);
    line(hueXPos+i, hueYPos, hueXPos+i, hueYPos+sliderHeight);
    
    stroke(curHue, i, curBright);
    line(hueXPos+i, satYPos, hueXPos+i, satYPos+sliderHeight);
    
    stroke(curHue, curSat, i);
    line(hueXPos+i, brightYPos, hueXPos+i, brightYPos+sliderHeight);
  }
  colorMode(RGB, 255);
  //Draw border to HSB boxes
  fill(0,0,0,0);
  stroke(0);
  rect(hueXPos, hueYPos, 255, sliderHeight);
  rect(satXPos, satYPos, 255, sliderHeight);
  rect(brightXPos, brightYPos, 255, sliderHeight);
  
  //Draw cursor to selected HSB
  colorMode(HSB, 255);
  fill(0,0,255);
  stroke(0,255,0);
  rect(hueXPos+curHue-4,hueYPos-3,8,26);
  rect(satXPos+curSat-4,satYPos-3,8,26);
  rect(brightXPos+curBright-4,brightYPos-3,8,26);
  colorMode(RGB, 255);
  
  
  //Reset whatever settings the UI tab may have messed with
  strokeWeight(brushSizes[brushSizeSelected]);
  stroke(curStroke);
}

Table drawBoxes(int startX, int startY, int drawWidth, int numOfBoxes, int boxLength, int padding, color boxOutline, color boxBackground) {

  Table result = new Table();
  result.addColumn("xPos");
  result.addColumn("yPos");
  result.addColumn("boxWidth");
  result.addColumn("boxHeight");
  result.addColumn("text");

  int drawY = startY;
  int drawX;

  int row = 0;
  int rowLength = 0;

  for (int i = 0; i < numOfBoxes; i++) {
    if (row > 0) {
      drawX = startX + (i - rowLength*row) * (boxLength + padding);
    } else {
      drawX = startX + i*(boxLength + padding);
    }
    
    stroke(boxOutline);
    fill(boxBackground);
    rect(drawX, drawY, boxLength, boxLength);
    
    TableRow curRow = result.addRow();
    curRow.setInt("xPos", drawX);
    curRow.setInt("yPos", drawY);
    curRow.setInt("boxWidth", boxLength);
    curRow.setInt("boxHeight", boxLength);
    curRow.setString("text", ""+i);
    
    if (drawX - startX >= drawWidth) {
      drawY += padding + boxLength;
      row++;
      rowLength = (i+1)/row;
    }
  }
  return result;
}

void sizeBoxIcons(){
  for (int i = 0; i < sizeBoxes.getRowCount(); i++){
    int xPos = sizeBoxes.getInt(i, 0);
    int yPos = sizeBoxes.getInt(i, 1);
    int xSize = sizeBoxes.getInt(i, 2);
    int ySize = sizeBoxes.getInt(i, 3);
    
    
    strokeWeight(brushSizes[i]);
    point(xPos+xSize/2, yPos+ySize/2);
    
    strokeWeight(1);
    
    fill(0);
    
    textSize(xSize/2);
    text(""+(i+1), xPos, yPos+ySize);
  }
}
void brushBoxIcons(){
  for (int i = 0; i < brushBoxes.getRowCount(); i++){
    
    int xPos = brushBoxes.getInt(i, 0);
    int yPos = brushBoxes.getInt(i, 1);
    int xSize = brushBoxes.getInt(i, 2);
    int ySize = brushBoxes.getInt(i, 3);
    
    switch (i){
      case 0:
        strokeWeight(1);
        line(xPos, yPos, xPos+xSize, yPos + ySize);
        break;
      case 1:
        rect(xPos+xSize/4, yPos+ySize/4, xSize/2, ySize/2);
        break;
    }
  }
}

boolean checkForUI(int x, int y) {

  if (y < marginHeight) {
    return true;
  } else {
    return false;
  }
}

void updateColorSelected(){
  
  colorMode(HSB, 255);
  curStroke = color(curHue, curSat, curBright);
  stroke(curStroke);
  colorMode(RGB, 255);
  
}
void updateColorPicker(){
  if (mouseX > hueXPos && mouseX < hueXPos + 255){
    print(1);
    if (mouseY > hueYPos && mouseY < hueYPos + sliderHeight){
      curHue = mouseX - hueXPos;
      print(2);
    } else if (mouseY > satYPos && mouseY < satYPos + sliderHeight){
      curSat = mouseX - satXPos;
      print(3);
    } else if (mouseY > brightYPos && mouseY < brightYPos + sliderHeight){
      curBright = mouseX - brightXPos;
      print(4);
    }
    drawUI();
  }
  print(5);
    
}
