import oscP5.*;

OscP5 oscP5;
//String inString

void setup() { 
  oscP5 = new OscP5(this,57120);
} 

void draw(){
}

void oscEvent(OscMessage theOscMessage) { 
   int counter = 0;
   String i = "fg";
   while(true){
  
     i = (theOscMessage.get(counter).stringValue());
     println (i);
     if (i.equals("END"))break;
   
     counter ++;
   }
}

