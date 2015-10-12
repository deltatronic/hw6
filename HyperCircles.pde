final int GRID_SIZE = 10;
final float GRID_PADDING = 50;
final float FRACTION_PER_FRAME = .25;
final int MAX_HISTORY_POINTS = 40;

// track the origin and destination for each line
int oldX, oldY;
int newX, newY;

float fraction = 0;

ArrayList<PVector> historyPoints;

void setup() {
  size(500, 500);

  newX = floor(random(GRID_SIZE));
  newY = floor(random(GRID_SIZE));

  historyPoints = new ArrayList<PVector>();
  setNewDestination();
}

void setNewDestination() {
  fraction = 0;
  oldX = newX;
  oldY = newY;
  newX = floor(random(GRID_SIZE));
  newY = floor(random(GRID_SIZE));

  // add the old destination to the history
  historyPoints.add(0, new PVector(oldX, oldY));

  // remove any extra history points.
  while (historyPoints.size () > MAX_HISTORY_POINTS) {
    historyPoints.remove(historyPoints.size()-1);
  }
}

float gridToCoordinates(float input) {
  return GRID_PADDING+input*(500 - 2*GRID_PADDING)/(GRID_SIZE-1);
}

void drawHistory() {
  fill(255);
  noStroke();
  for (int i = 0; i < historyPoints.size (); i++) {
    PVector hp = historyPoints.get(i);
    // draw progressively smaller circles for each historical point.
    ellipse(gridToCoordinates(hp.x), gridToCoordinates(hp.y), MAX_HISTORY_POINTS-i, MAX_HISTORY_POINTS-i);
  }
}  

void drawGrid() {
  fill(255);
  noStroke();
  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      ellipse(gridToCoordinates(i), gridToCoordinates(j), 3, 3);
    }
  }
}

void drawLine() {
  stroke(255);
  strokeWeight(4);
  float cOldX = gridToCoordinates(oldX);
  float cOldY = gridToCoordinates(oldY);
  float cNewX = gridToCoordinates(newX);
  float cNewY = gridToCoordinates(newY);

  line(cOldX + (cNewX - cOldX)*fraction, 
       cOldY + (cNewY - cOldY)*fraction, 
       cOldX + (cNewX - cOldX)*min(fraction+FRACTION_PER_FRAME, 1), 
       cOldY + (cNewY - cOldY)*min(fraction+FRACTION_PER_FRAME, 1));
}

void draw() {
  background(0);
  if (fraction >= 1) {
    setNewDestination();
  }

  drawHistory();
  drawGrid();
  drawLine();

  if (! mousePressed) {
    fraction += FRACTION_PER_FRAME;
  }
}
