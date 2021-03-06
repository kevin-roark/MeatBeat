class TitleState extends BaseState{
  int startTime;
  String[] quotes = {"When Meat Attacks", "Meat me at the Meat shop","The Meatshop Chronicles","Meat and Destroy","Meat and Prejudice","The Meat Files","Meatocracy","To Meat or not to Meat","Baconbacond and bacon","Meat Zone 2","Mega Meat","Meating of the Meats","Meatups","Meat Raider","That's a Meat","Beauty and the Meat","The pen is not Beatlier than the Meat","M for Meatdetta", "I came here to Beat Meat and chew bubble gum. I'm out of gum..."};
  int quote;
  String word;
  PImage logo;
  void setup(){
    background(200, 0, 0);
    playIntro();
    quote = int(random(quotes.length-1));
    fill(255);
    text(quotes[quote], width/2, height*7/8);
    logo = loadImage("sprite sheets/logo.png");
    imageMode(CENTER);
  }
 
  void draw(){
    background(200, 0, 0);
    image(logo, width/2, height/2, (700/860) * width * 3/4, (860/700) * height * 3/4);
    fill(255);
    text(quotes[quote], width/2, height*7/8);
}
 
  void keyPressed(){
      if(key=='p') stopIntro();
      else if(key=='o') playMaster();
      else if(key=='y') playIntro();
      else
        setState(GAMEPLAY_STATE);
  }

  void cleanup(){
    stopIntro();
    imageMode(CORNER);
  }
}
