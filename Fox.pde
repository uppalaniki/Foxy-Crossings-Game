class Fox extends Rectangle {

  Obstacle attached = null;

  //Sets variables for fox
  Fox(float x, float y, float w) {
    super(x, y, w, w);
  }


  //function to attach fox to logs
  void attach(Obstacle log) {
    attached = log;
  }


  //Updates movement of fox
  void update() {
    if (attached != null) {
      x += attached.speed;
    }

    x = constrain(x, 0, width-w);
  }

  //Displays fox image
  void show() {
    image(foxCharacter, x, y, w, w);
  }

  //Moves the fox in accordance of the grid
  void move(float xdir, float ydir) {
    x += xdir * grid;
    y += ydir * grid;
    attach(null);
  }
}
