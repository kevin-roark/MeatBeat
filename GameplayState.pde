class GameplayState extends BaseState{
  /** 
    BACKGROUND VARIABLES
  **/
  int totalHills = 3;
  Hill[] hills = new Hill[totalHills];
  int totalTrees = 3;
  Tree[] trees = new Tree[totalTrees];
  int[] soundTimes;
  
  Level currentLevel;
  int currentTrackNum;
  Panel[] panelArray;
  MeatChunk[] chunkArray;
  int offset = 60;
  float thresholdMS = 650;
  int timingErrorControl = 10;
  int[] shouldCheckBeat;
  
  void setup(){
    background(0);
    
    /**
      BACKGROUND SETUP
    **/
    setupHills(hills);  //hill setup
    trees = setupTrees(totalTrees);  //tree setup

    /** LIVES **/
    player = new Player(INITIAL_LIVES,0);  //new player instance
    
//    player = new Player(INITIAL_LIVES, meatLife);  //player instance
//    player.setupLives();
    currentLevel = new Level(beatsarray,soundNames[0]);
    getBeats(levelNames[1]);
    currentTrackNum = currentLevel.getNumTracks();
    panelArray = new Panel[currentTrackNum];
    chunkArray = new MeatChunk[currentTrackNum];
    soundTimes = new int[currentTrackNum];
    shouldCheckBeat = new int[currentTrackNum];
    for(int i = 0; i < currentTrackNum; i++){
      int xpos = offset + (width - offset * 2) / (currentTrackNum - 1) * i;
      chunkArray[i] = new MeatChunk(xpos, GROUND, 0, 0, currentLevel.getTrack(i));
      panelArray[i] = new Panel(xpos, GROUND+(PANEL_HEIGHT/2));
      soundTimes[i] = millis();
      shouldCheckBeat[i] = 0;
    }
  }
 
  void draw(){
      background(0);
          
      /** 
        BACKGROUND DRAW
      **/
      //drawHills(hills);
//      drawTrees(trees);

      /** LIVES **/
      player.drawLives();
      player.drawScore();
      
      stroke(255);
      line(0,GROUND,width,GROUND);  // line possibly temp for location of GROUND.
      
      for(int i = 0; i < currentTrackNum; i++){
        shouldCheckBeat[i] = chunkArray[i].move();
        panelArray[i].draw();
      }
      if (shouldCheckBeat[0]==1) {
          checkBeatSuccess(0);
          playSound(currentLevel.getTrack(0).getSound());
          //soundTimes[0] = millis();
      }
  }
 
  void keyPressed(){
    //setState(FINISH_STATE);
    //player.decreaseLives();
    
    for (int i = 0; i < currentLevel.getNumTracks(); i++) {
      if (key==currentLevel.getTrack(i).getKey()) {
        if (panelArray[i].offScreen) {
          panelArray[i].drawIt();
          //checkBeatSuccess(i);
        }
      }
    }
    
    if(key=='q') println(frameRate);
    if(key=='w') playSound(failsound);
  }
    
  void cleanup(){
   
  }
  
  boolean checkBeatSuccess(int track) {
    int diff = abs(panelArray[track].getLastDraw() - chunkArray[track].shouldBounceAgain);
    //println(diff);
    if (diff <= thresholdMS) {
    //if ((abs((chunkArray[track].yPosition+MEAT_HEIGHT/2) - (panelArray[track].origY-PANEL_HEIGHT/2)) <= threshold)) {
      beatSuccess(track);
    }
    else {
      beatFailure(track);
    }
  }
  
  void beatSuccess(int track) {
    //playSound(currentLevel.getTrack(track).getSound());
    //chunkArray[track].track.canSound=true;
    currentLevel.getTrack(track).canSound=true;
    player.changeScore(1);
    //chunkArray[track].canBounce=true;
    
  }
  
  void beatFailure(int track) {
    //playSound(failsound);
    //chunkArray[track].track.canSound=false;
    currentLevel.getTrack(track).canSound=false;
    player.decreaseLives();
    chunkArray[track].fail();
  }
  
}
