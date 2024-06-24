class Lane extends Rectangle {
  //Calling the obstacle array to use within the lanes
  Obstacle[] obstacles;
  int type;
  PImage laneImage;
  PImage laneImage2;

  //Creating the variables for the safe lanes
  Lane(int index, PImage laneImage2) {
    super(0, index*grid, width, grid);
    type = safety;
    obstacles = new Obstacle[0];
    this.laneImage2 = laneImage2;
  }

  //Creating the variables for the log and car lanes
  Lane(int index, int t, int n, int len, float spacing, float speed, PImage laneImage) {
    super(0, index*grid, width, grid);
    obstacles = new Obstacle[n];
    type = t;
    this.laneImage = laneImage;
    float offset = random(0, 200);
    for (int i = 0; i < n; i++) {
      obstacles[i] = new Obstacle(offset + spacing * i, index*grid, grid*len, grid, speed, type);
    }
    noStroke();
  }

  //Checks for fox intersection with obstacles within the lanes
  void check(Fox fox) {
    if (type == CAR) {
      for (Obstacle o : obstacles) {
        if (fox.intersects(o)) {
          resetGame();
        }
      }
    } else if (type == LOG) {
      boolean ok = false;
      for (Obstacle o : obstacles) {
        if (fox.intersects(o)) {
          ok = true;
          fox.attach(o);
        }
      }
      if (!ok) {
        resetGame();
      }
    }
  }

  //Displaying images for lanes and updating them
  void run() {
    if (laneImage != null) {
      image(laneImage, x, y, w, h);
    }
    if (laneImage2!= null) {
      image(laneImage2, x, y, w, h);
    }
    for (Obstacle o : obstacles) {
      o.show();
      o.update();
    }
  }
}
