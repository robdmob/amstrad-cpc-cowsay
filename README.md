# CPC Cowsay

Expansion ROM for the Amstrad CPC range of computers. Provides similar functionality to the Fortune and Cowsay programs for Unix-like operating systems.

# Commands:

|FORTUNE
  
Displays a random quote from the ROM. The quote can be writted to a string variable by passing a pointer to the variable as a parameter. The string variable must be initialised with a length long enough to contain the quote otherwise the quote will be truncated (probabaly the easiest way to do this is to use the SPACE$ function with 255 as the parameter). If the string is longer than the quote then it will automatically be shortened.
  
|COWSAY
  
Displays an ASCII-art cow with a speech bubble. If a string is passed as a parameter then that string is shown within the speech bubble. If no parameters are passed then a random quote from the ROM is shown. Because the cow is wider than 20 characters the command only works in modes 1 and 2, nothing is displayed in mode 0.
  
|COWTHINK
  
Identical to COWSAY but displays cow with a thought bubble instead of a speech bubble.
    
# Examples:

|COWSAY,"Hello, World!"

  
10 n$=SPACE$(255)

20 |FORTUNE,@n$

30 PRINT n$

Assembled using WinAPE's built-in Z80 assembler.

Quotes taken from Shlomi Fish's collection at https://www.shlomifish.org/humour/fortunes/

Original Cowsay program by Tony Monroe
