//////////////////////////////
// 2012 by KopfKopfKopfAffe //
//////////////////////////////

public class AnimatedText{
  //List to hold our word
  ArrayList<PImage> wordImages = new ArrayList<PImage>();
  //List of character images
  PImage[] alphabet = new PImage[39];
  //Fontsize
  float fontSize;
  //Processed values for scaling and fading the text
  float[] scaleValues;
  int[] alphaValues;
  //Mapping from Curves to Values
  int[] scaleCounters; 
  int[] alphaCounters; 
  //Lookup table of precalculated scaling/fading curves
  int[] scaleCurve = new int[100];
  int[] alphaCurve = new int[100];
  //Text position
  int xpos, ypos;
  //Is the animation finished?
  boolean finished = false;
  
  //Constructor
  AnimatedText(String theTxt, float fontSze, int xposi, int yposi){
    //put constructor variables into local variables
    xpos = xposi;
    ypos = yposi;
    fontSize = fontSze;
    //Our font only supports upper case
    String theText = theTxt.toUpperCase();
    //Initialize arrays matching to text length
    scaleValues = new float[theText.length()];
    scaleCounters = new int[theText.length()];
    alphaValues = new int[theText.length()];
    alphaCounters = new int[theText.length()];
    //Generate array of character images
    fillAlphabet();
    //Reset the Counter arrays
    resetArrays();
    //Generate the function lookup tables for scaling/fading
    generateCurves();
    //Create the array of images for our custom text from the input string
    for (int characters = 0; characters < theText.length(); characters ++){
      //Get ascii number of character
      int asc = int(theText.charAt(characters));
      //Is it a character or number or '!' or '?' or ' ' ? 
      //Load the matching image from alphabet
      if (asc>64)wordImages.add(alphabet[asc-55]);
      if (asc<58 && asc > 47)wordImages.add(alphabet[asc-48]);
      if (asc==63)wordImages.add(alphabet[37]);
      if (asc==33)wordImages.add(alphabet[36]);
      if (asc==32)wordImages.add(alphabet[38]);
    } 
  }
  
  //Push the text animation one step forward
  void animate(int updateRate){
    //For all characters in our input text
    for (int i = 0;i<scaleCounters.length;i++){
      //Increment counters for scale/fade 
      scaleCounters[i] = scaleCounters[i] + updateRate;
      alphaCounters[i] = alphaCounters[i] + updateRate;
      //If value is off limits, wait for the last value to get to limit
      if (scaleCounters[i] > 99) scaleCounters[i] = 99;
      if (alphaCounters[i] > 99) alphaCounters[i] = 99;
    }
    //Last value is at limit, which means all characters have completed the animation
    if (scaleCounters[scaleCounters.length-1] > 99) finished = true;
    //Load the current animation state for scale/fade from lookup table of curves
    for (int i = 0;i<scaleCounters.length;i++){
      if (scaleCounters[i] >= 0)scaleValues[i] = scaleCurve[scaleCounters[i]]/100.0;
      if (alphaCounters[i] >= 0)alphaValues[i] = 256-alphaCurve[alphaCounters[i]];
   }   
  }
  
  //can be called to determine if more calls of animate() are necessary
  boolean animationFinished(){
    return finished;
  }
  
  //Must be called to display the text
  void display(){
    //Counter over all characters in our text image list
    int charCounter = 0;
    //Move to designated textposition
    translate(xpos,ypos);
    //Iterate over all character images in our text
    for (PImage img : wordImages){ 
      pushMatrix();
        rectMode(CENTER);
        //Move to next character
        //Character images are 150 pixels wide
        translate(charCounter *int(150*fontSize) ,0);
        //Scale the character image to current scaleValue
        //Modify by font size 
        scale (scaleValues[charCounter]*fontSize);
        //Display character image
        image(img,-img.width/2,-img.height/2);
        //Draw a black rectangle with current alpha value
        //over the character image to implement fading
        fill(0,alphaValues[charCounter]);
        rect(0,0,img.width,img.height);
     charCounter ++;
    popMatrix();
   }
  
  }
  
  //Generate preset values for scale/fade counters.
  //Negative Values for the characters after the first
  //one lead to delayed scaling up / fading in.
  //If all values would be 0, every character scales up/
  //fades in at the same time.
  void resetArrays(){
    for (int i = 0; i<scaleValues.length;i ++){
      scaleCounters[i] = (i * 20)*-1;
      alphaCounters[i] = (i * 20)* -1;
    } 
  }
  
  //Put the character images into the alphabet
  void fillAlphabet(){
    alphabet[0] = loadImage("0.png");
    alphabet[1] = loadImage("1.png");
    alphabet[2] = loadImage("2.png");
    alphabet[3] = loadImage("3.png");
    alphabet[4] = loadImage("4.png");
    alphabet[5] = loadImage("5.png");
    alphabet[6] = loadImage("6.png");
    alphabet[7] = loadImage("7.png");
    alphabet[8] = loadImage("8.png");
    alphabet[9] = loadImage("9.png");
    alphabet[10] = loadImage("A.png");
    alphabet[11] = loadImage("B.png");
    alphabet[12] = loadImage("C.png");
    alphabet[13] = loadImage("D.png");
    alphabet[14] = loadImage("E.png");
    alphabet[15] = loadImage("F.png");
    alphabet[16] = loadImage("G.png");
    alphabet[17] = loadImage("H.png");
    alphabet[18] = loadImage("I.png");
    alphabet[19] = loadImage("J.png");
    alphabet[20] = loadImage("K.png");
    alphabet[21] = loadImage("L.png");
    alphabet[22] = loadImage("M.png");
    alphabet[23] = loadImage("N.png");
    alphabet[24] = loadImage("O.png");
    alphabet[25] = loadImage("P.png");
    alphabet[26] = loadImage("Q.png");
    alphabet[27] = loadImage("R.png");
    alphabet[28] = loadImage("S.png");
    alphabet[29] = loadImage("T.png");
    alphabet[30] = loadImage("U.png");
    alphabet[31] = loadImage("V.png");
    alphabet[32] = loadImage("W.png");
    alphabet[33] = loadImage("X.png");
    alphabet[34] = loadImage("Y.png");
    alphabet[35] = loadImage("Z.png");
    alphabet[36] = loadImage("ex.png");
    alphabet[37] = loadImage("qu.png");
    alphabet[38] = loadImage("_.png");
  }
  
  //Generate lookup tables for scale/fade curves
  void generateCurves(){
    for (int i = 0; i < alphaCurve.length; i ++){
      alphaCurve[i] = int((pow(i,3))/3800);
      scaleCurve[i] = int(sin(i/55.0)*110.0);
      println (alphaCurve[i]);
    }
  }
}
