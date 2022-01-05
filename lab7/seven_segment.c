/*
Configuration for the code below:

Connect portA to J1 Port of 4 Digit Seven Segment Module
Jumpers of portA are : 5V, pull down ( top one to left, other to right )

Connect portE to J2 Port of 4 Digit Seven Segment Module
Jumpers of portE are : 5V, pull down ( top one to left, other to right )

*/

// Hexadecimal values for digits in 7 segment
unsigned char binary_pattern[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

int n1 = 1; // value of 7-segment 1st displayer
int n2 = 2; // value of 7-segment 2nd displayer
int n3 = 3; // value of 7-segment 3rd displayer
int n4 = 4; // value of 7-segment 4th displayer
int i = 0;
void main() {

 AD1PCFG = 0xFFFF; // Configure AN pins as digital I/O
 JTAGEN_bit = 0; // Disable JTAG

 TRISA = 0x00;  // portA is output to D
 TRISE = 0X00;  // portE is output to AN

 while(1)
 {
     // 250 times 4 *(1ms) for updating once per second
     for ( ; i < 250; i++ ) {
         // Digit 1
         PORTA=binary_pattern[n1];  // assign 7-segment representation of value inside n1 to portA from binary_pattern array
         PORTE=0x01;                  // Open first digit
         Delay_ms(1);                 // Wait 1 milisecond and switch to next digit

         // Digit 2
         PORTA=binary_pattern[n2];  // assign 7-segment representation of value inside n2 to portA from binary_pattern array
         PORTE=0x02;                  // Open second digit
         Delay_ms(1);                 // Wait 1 milisecond and switch to next digit

         // Digit 3
         PORTA=binary_pattern[n3];  // assign 7-segment representation of value inside n3 to portA from binary_pattern array
         PORTE=0x04;                  // Open third digit
         Delay_ms(1);                 // Wait 1 milisecond and switch to next digit

         // Digit 4
         PORTA=binary_pattern[n4];  // assign 7-segment representation of value inside n4 to portA from binary_pattern array
         PORTE=0x08;                  // Open fourth digit
         Delay_ms(1);                 // Wait 1 milisecond and switch to next digit

         // Since the numbers rotate between 1 and 9, if it reaches 9, reset it.
         if ( n1 == 10 ) {
            n1 = 1;
         }
         if ( n2 == 10 ) {
            n2 = 1;
         }
         if ( n3 == 10 ) {
            n3 = 1;
         }
         if ( n4 == 10 ) {
            n4 = 1;
         }
     }
     n1 += 1;
     n2 += 1;
     n3 += 1;
     n4 += 1;
     i=0;
 }//while

}//main
