import oscP5.*;

OscP5 oscP5;
//String inString

void setup() { 
  oscP5 = new OscP5(this,57120);
} 

void draw(){
}

void oscEvent(OscMessage theOscMessage) { 

  
  // check if message is from brix1
//  if(theOscMessage.checkAddrPattern("/brix/6")==true) {
    // split string into values int array
   // theOscMessage.print();
   int counter = 0;
   while(String i != "END"){
   counter ++;
   i = theOscMessage.get(counter);
   print (i);
   }

    //values = int(trim(theOscMessage.get(0).stringValue()).split(","));
    // increment smoothing counter
 
    // add up values in every smoothing 

}

