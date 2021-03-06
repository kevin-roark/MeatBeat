class GameplayState extends BaseState{
  /** 
    BACKGROUND VARIABLES
  **/
  int totalHills = width * 0.00375;
  Hill[] hills = new Hill[totalHills];
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  int totalClouds = 3;
  Cloud[] clouds = new Cloud[totalClouds];
  boolean showLineOrCloud;
  ColorWheel cw;
  color[] c;
  int levelStart;
  static final int NEW_LEVEL_TIME = 1500;
  
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float thresholdMS = 550;
  int timingErrorControl = 10;
  int[] shouldCheckBeat;
  Baseline bl;
  
  int colorShifter;
  
  void setup(){    
    /**  BACKGROUND SETUP **/
    setupHills(hills);  //hill setup
    trees = setupTrees(totalTrees);  //tree setup
    setupClouds(clouds);  //cloud setup
    cw = new ColorWheel(42f,50f);
    colorShifter=1;
    setupLine();
    setNextLevel();
    playMaster();
  }
  
  void setNextLevel() {
    fist = loadImage(fists[int(random(0,fists.length))]);
    currentLevel = new Level(beatsarray);
    levelIndex++;
    getBeats(levelNames[levelIndex]); // get next level loaded
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    shouldCheckBeat = new int[currentTrackNum];
    bl = new Baseline();
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos - MEAT_WIDTH/2, GROUND, 0, 0, currentLevel.getTrack(i));
      panelArray[i] = new Panel(xpos - PANEL_WIDTH/2, GROUND - 15);
      bl.addEmptyZone(xpos);
      shouldCheckBeat[i] = 0;
    }
    levelStart = millis();
  }
 
  void draw(){
      levelComplete = true;
      colorShifter--;
      if(colorShifter == 0) {
        c = cw.getColor();
        colorShifter=5;
      }
      background(c[1]);
      
      /** 
        BACKGROUND DRAW
      **/
      drawLine();
      if(showLineOrCloud == "true"){
        drawLine();
       }
       else{
        drawClouds(clouds,c);
       }
      drawHills(hills,c);
      drawTrees(trees,c);

      /** LIVES **/
      player.drawLives();
      player.drawScore();
      bl.draw();
      
      for(int i = 0; i < currentTrackNum; i++){
        panelArray[i].draw();
        shouldCheckBeat[i] = chunkArray[i].move();
        if (shouldCheckBeat[i]==1) {
          checkBeatSuccess(i);
        }
        if (chunkArray[i].state != COMPLETE) {
          levelComplete = false;
        }
      }
      /*if (shouldCheckBeat[0]==1) {
          checkBeatSuccess(0);
          //playSound(currentLevel.getTrack(0).getSound());
          //soundTimes[0] = millis();
      }*/
      if (levelComplete) {
        //setState(BETWEEN_LEVELS_STATE);
        //setState(GAMEPLAY_STATE);
        setNextLevel();
      }
      if ((millis() - levelStart) <= NEW_LEVEL_TIME) {
        image(lvlImages[levelIndex-1], width/2-100, height/4,400,80);
      }
  }
  
 
  void keyPressed(){
    for (int i = 0; i < currentLevel.getNumTracks(); i++) {
      if (key==currentLevel.getTrack(i).getKey()) {
        if (panelArray[i].offScreen) {
          panelArray[i].drawIt();
        }
      }
    }
    
    if(key=='p') noLoop();
  }
    
  void cleanup(){
    stopMaster();
  }
  
  boolean checkBeatSuccess(int track) {
    int diff = abs(panelArray[track].getLastDraw() - chunkArray[track].previousBounceTime);
    //if (!panelArray[track].offScreen) {
    //if ((abs((chunkArray[track].yPosition+MEAT_HEIGHT/2) - (panelArray[track].origY-PANEL_HEIGHT/2)) <= threshold)) {
    if( abs(diff) <= thresholdMS) {
      beatSuccess(track);
    }
    else {
      beatFailure(track);
    }
  }
  
  void beatSuccess(int track) {
    currentLevel.getTrack(track).canSound=true;
    player.changeScore(1);    
  }
  
  void beatFailure(int track) {
    player.decreaseLives();
    chunkArray[track].fail();
    //playFail();
  }
  
}
