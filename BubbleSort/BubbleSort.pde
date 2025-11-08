int[] toSort;
int numOfElements = 100;
void setup() {
  fullScreen();
  noStroke();
  frameRate(240);
  toSort = new int[numOfElements];
  for (int i = 0; i < toSort.length; i++) {
    toSort[i] = i;
  }
  println(toSort);
  for (int i = 0; i < numOfElements*10; i++) {
    SwapElementsOfArray(toSort, (int)random(numOfElements), (int)random(numOfElements));
  }
  println(toSort);
  println("done");
}
int curIndex = 0;
int maxNotSorted = numOfElements-1;
void draw() {
  background(50);
  for (int i = 0; i < numOfElements; i++) {
    if (curIndex == i) {
      fill(0, 200, 200);
    } else if (curIndex+1 == i) {
      fill(200, 0, 200);
    } else {
      fill(255);
    }

    rect(map(i, 0, numOfElements, 0, width), height, width/numOfElements, map(toSort[i], 0, numOfElements, -20, -height));
  }
  if (curIndex >= maxNotSorted) {
    curIndex = 0;
    maxNotSorted--;
  }
  if (toSort[curIndex] > toSort[curIndex+1]) {
    SwapElementsOfArray(toSort, curIndex, curIndex+1);
  }
  curIndex++;
}

int valAtPointA;
int[] SwapElementsOfArray(int[] ar, int a, int b) {
  valAtPointA = ar[a];
  ar[a] = ar[b];
  ar[b] = valAtPointA;
  return ar;
}
