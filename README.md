# CPC Cowsay

Expansion ROM for the Amstrad CPC range of computers. Provides similar functionality to the Fortune and Cowsay programs for Unix-like operating systems.

# RSX Commands

|FORTUNE
  
Displays a random quote from the ROM. Optionally, the quote can be written to a string variable by passing a pointer to the variable as a parameter. The variable must be initialised with a string long enough to contain the quote otherwise the quote will be truncated, to be safe the length should ideally be 255. (Probabaly the easiest way to do this is to use the SPACE$ function e.g. n$=SPACE$(255) followed by |FORTUNE,@n$.) The string length will automatically be reduced to match the length of the quote.
  
|COWSAY
  
Displays an ASCII-art cow with a speech bubble. If a string is passed as a parameter then that string is shown within the speech bubble. If no parameters are passed then a random quote from the ROM is shown. Because the cow is wider than 20 characters the command only works in modes 1 and 2, nothing is displayed in mode 0.
  
|COWTHINK
  
Identical to COWSAY except the speech bubble is a thought bubble.
    
# Examples

|COWSAY,"Hello, World!"

  
10 n$=SPACE$(255)

20 |FORTUNE,@n$

30 PRINT n$

Assembled using WinAPE's built-in Z80 assembler.

Quotes taken from Shlomi Fish's collection at https://www.shlomifish.org/humour/fortunes/

Original Cowsay program by Tony Monroe
