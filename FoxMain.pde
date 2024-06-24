//Booleans for screen transitions  //<>//
boolean blnInitialScreen = true;
boolean blnLoadingScreen = false;
boolean blnGameCompleted = false;

//Fox' lives and lane objects 
Fox fox;
Lane[] lanes;
int lives = 6;
int safety = 0;
int finishedLives = 0;
int CAR = 1;
int LOG = 2;

//variables for level 1 & 2
int currentLevel = 1;
PImage car, foxCharacter, log, grassLeft, grassRight, road, river, concrete, blueCar;
float grid = 50;

//Font & Inital text size
PFont gameFont;
float textSizeBase = 30;

//Different screens
PImage homeScreen, arrows, levelsScreen, finalScreen ;
PImage  level1Sky, level2Sky;


void resetGame() {
  //Creating new fox and reseting lanes
  fox = new Fox(width/2-grid/2, height-grid, grid);
  fox.attach(null);
  lives--;
  resetLanes();
}

void resetLanes() {
  //Reseting lanes based on the current level
  int totalLanes = int(height / grid);
  lanes = new Lane[totalLanes];
  if (currentLevel == 1) {
    createLevel1Lanes();
  } else if (currentLevel == 2) {
    createLevel2Lanes();
  }
}

void createLevel1Lanes() {
  //Creating lanes for level 1
  lanes[0] = new Lane(0, level1Sky);
  lanes[1] = new Lane(1, grassRight);
  lanes[2] = new Lane(2, LOG, 5, 3, 350, -2.5, river);
  lanes[3] = new Lane(3, LOG, 5, 2, 200, 1, river);
  lanes[4] = new Lane(4, LOG, 5, 2, 270, -1.7, river);
  lanes[5] = new Lane(5, grassRight);
  lanes[6] = new Lane(6, CAR, 5, 2, 300, 1, road);
  lanes[7] = new Lane(7, grassLeft);
  lanes[8] = new Lane(8, CAR, 5, 2, 300, -3.5, road);
  lanes[9] = new Lane(9, grassRight);
  lanes[10] = new Lane(10, CAR, 4, 2, 300, 1.5, road);
  lanes[11] = new Lane(11, grassLeft);
  lanes[12] = new Lane(12, CAR, 4, 2, 300, -1.5, road);
  lanes[13] = new Lane(13, concrete);
}


void createLevel2Lanes() {
  //Creating lanes for level 2
  lanes[0] = new Lane(0, level2Sky);
  lanes[1] = new Lane(1, LOG, 3, 1, 150, 3, river);
  lanes[2] = new Lane(2, LOG, 2, 3, 350, -2.5, river);
  lanes[3] = new Lane(3, LOG, 4, 1, 200, 3, river);
  lanes[4] = new Lane(4, LOG, 3, 2, 250, -2, river);
  lanes[5] = new Lane(5, LOG, 5, 2, 200, -4, river);
  lanes[6] = new Lane(6, concrete);
  lanes[7] = new Lane(7, CAR, 2, 2, 330, -1.9, road);
  lanes[8] = new Lane(8, CAR, 1, 3, 330, 1.9, road);
  lanes[9] = new Lane(9, CAR, 4, 2, 330, -1.9, road);
  lanes[10] = new Lane(10, CAR, 5, 2, 330, 1.9, road);
  lanes[11] = new Lane(11, CAR, 5, 2, 330, -1.9, road);
  lanes[12]= new Lane(12, CAR, 5, 2, 330, 1.9, road);
  lanes[13] = new Lane(13, concrete);
}


void setup() {
  size(600, 700);

  //Loading all images for lanes
  foxCharacter = loadImage("fox.png");
  grassLeft = loadImage("grassLeft.jpg");
  grassRight = loadImage("grassRight.jpg");
  road = loadImage("road.jpg");
  river = loadImage("river.png");
  concrete = loadImage("concrete.png");
  blueCar = loadImage("blueCar.png");
  log = loadImage("log.png");

  //Images for different screen transitions
  level1Sky = loadImage("day_level1.png");
  level2Sky = loadImage("night.jpg");

  homeScreen = loadImage("homeScreen.jpg");
  arrows = loadImage("arrows.png");
  levelsScreen = loadImage("day.png");
  finalScreen = loadImage("finalScreen.jpg");
  gameFont = createFont("ka1.ttf", textSizeBase);

  textFont(gameFont);
  textAlign(CENTER);
  noLoop();

  //Creating lanes for grid
  int totalLanes = int(height / grid);
  lanes = new Lane[totalLanes];

  //Creating lanes based on the current level
  if (currentLevel == 1) {
    createLevel1Lanes();
  } else if (currentLevel == 2) {
    createLevel2Lanes();
  }
}


void draw() {
  //Displaying the initial screen (homescreen for game)
  if (blnInitialScreen) {
    homeScreen = loadImage("homeScreen.jpg");
    image(homeScreen, 0, 0, width, height); //Displaying the image as a background
    arrows = loadImage("arrows.png");
    image(arrows, 35, height / 2/5 - 6, width/8, height/10);

    //Text for homescreen
    fill(255);
    textFont(gameFont, 30);
    text("Foxy Crossings", width / 2, height / 2 - 20);
    text("Press Enter to Play", width / 2, height / 2 + 20);
    textFont(gameFont, 17);
    text("Use arrow keys to dodge the cars and", width / 2 + 35, height / 2/4);
    text("use the logs to cross the river", width / 2 + 35, height / 2/3);

    if (keyPressed && keyCode == ENTER) {
      //Starting the game when Enter is pressed
      lives = 6;
      blnInitialScreen = false;
      blnLoadingScreen = true;
      blnGameCompleted = false;
      loop();
    }
  } else if (blnLoadingScreen) {
    //Loading screen
    blnGameCompleted = false;
    levelsScreen = loadImage("day.png"); // Load the image
    image(levelsScreen, 0, 0, width, height);
    textAlign(CENTER);
    textFont(gameFont, 32);
    fill(255);
    text("Level " + currentLevel + " Loading...", width / 2, height / 2);

    if (frameCount % 150 == 0) {
      //Exiting loading screen after 150 frames
      blnLoadingScreen = false;
      resetGame();
    }
  } else {
    //Gameplay screen
    for (Lane lane : lanes) {
      lane.run();
    }

    int laneIndex = int(fox.y / grid);
    lanes[laneIndex].check(fox);
    fox.update();
    fox.show();

    if (lives <= finishedLives) {
      //When all lives are used the game over screen comes up, instructing the player to press Enter to restart the game
      blnGameCompleted = true;
      displayFinished();

      fill(255);
      textAlign(CENTER);
      textFont(gameFont, 20);
      text("Press Enter to Restart", width / 2, height / 2 + 80);

      if (keyPressed && keyCode == ENTER) {
        //Restarting the game by returning to the initial screen
        lives = 6;
        blnInitialScreen = true;
        blnLoadingScreen = false;
        resetGame();
      }
    } else if (fox.y <= 25) {
      if (currentLevel == 1) {
        //Loading Level 2
        blnGameCompleted = false;
        currentLevel = 2;
        lives = 6;
        resetGame();
        blnLoadingScreen = true;
      } else if (currentLevel == 2) {
        blnGameCompleted = true;
        //Displaying the "Congratulations, game completed" message
        finalScreen = loadImage("finalScreen.jpg"); // Load the image
        image(finalScreen, 0, 0, width, height);
        fill(255);
        textAlign(CENTER);
        textFont(gameFont, 25);
        text("Congratulations, game complete", width / 2, height / 2 - 10);

        //Instructing the player to press Enter to return to the initial screen
        fill(255);
        textAlign(CENTER);
        textFont(gameFont, 20);
        text("Press Enter to Return to Home Screen", width / 2, height / 2 + 20);

        if (keyCode == ENTER) {
          //Returning to the initial screen when Enter is pressed
          lives = 6;
          blnInitialScreen = true;
          blnLoadingScreen = false;
          blnGameCompleted = false;
          currentLevel = 1;
        }
      }
    } else {
      //else game over
      displayLives();
    }
  }
}



void keyPressed() {
  if (blnInitialScreen) {
    if (keyCode == ENTER) {
      //Starting the game when Enter is pressed
      lives = 6;
      blnInitialScreen = false;
      blnLoadingScreen = true;
      redraw();
      loop();
    }
  } else {
    if (keyCode == UP) {
      //Checking different conditions for up arrow so fox only moves when approriate
      if (fox != null) {
        if (blnGameCompleted == true) {
          return;
        }
        fox.move(0, -1);
      }
    } else if (keyCode == DOWN) {
      //Checking different conditions for down arrow so fox only moves when approriate
      if (fox != null && fox.y < 650) {
        if (blnGameCompleted == true) {
          return;
        }
        fox.move(0, 1);
      }
    } else if (keyCode == RIGHT) {
      //Checking different conditions for right arrow so fox only moves when approriate
      if (fox != null) {
        if (blnGameCompleted == true) {
          return;
        }
        fox.move(1, 0);
      }
    } else if (keyCode == LEFT) {
      //Checking different conditions for left arrow so fox only moves when approriate
      if (fox != null) {
        if (blnGameCompleted == true) {
          return;
        }
        fox.move(-1, 0);
      }
    } else if (lives <= finishedLives && keyCode == ENTER) {
      //Restarting the game by returning to the initial screen when Enter is pressed
      blnInitialScreen = true;
      blnLoadingScreen = false;
      resetGame();
      currentLevel = 1;
      loop();
    } else if (currentLevel == 2 && keyCode == ENTER) {
      // If the game is completed and Enter is pressed, return to the initial screen
      lives = 6;
      blnInitialScreen = true;
      blnLoadingScreen = false;
      resetGame();
      currentLevel = 1;
      loop();
    }
  }
}

void displayLives() {
  //Displaying lives 
  textFont(gameFont, 20);
  fill(255);
  textAlign(CENTER);
  text("Lives left " + lives, width / 6, height - 10);
}

void displayFinished() {
  //Displaying game over 
  textFont(gameFont, 50);
  fill(255);
  textAlign(CENTER);
  text("GAME OVER", width / 2, height / 2 + 20);
}
