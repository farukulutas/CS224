/*
Attention!
Configuration  for push-button project :

Connect portA to LEDs
Jumpers of portA are : 5V, pull up ( both of the to the left side )

Connect portE to push-buttons
Jumpers of portE are : 3V3, pull up ( top one to right, other to left )

*/

void main() {

 AD1PCFG = 0xFFFF; // Configure AN pins as digital I/O

 DDPCON.JTAGEN = 0; // disable JTAG

 TRISA = 0x0000;  //portA is output to turn on LEDs.
 TRISE = 0XFFFF;  //portE is inputs to read push-buttons.

 while(1)
 {
  // When both buttons are clicked, motor should not turn so ICQ called
  if ( portE.RE0 && portE.RE1 ) {
    portA = 0x0000;
  }
  else {
    portA.RA2 = portE.RE0; // button 0 is equal to 1, direction of the motor should be clockwise
    portA.RA1 = portE.RE1; // button 1 is equal to 1 its direction should be counterclockwise
  }
 }//while

}//main
