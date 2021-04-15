------------------------
CMPE 012 Fall 2018

Mahendru, Rahul
-------------------------

The functionality of this program is as follows:
1. Read two program arguments: signed decimal numbers [-64, 63].
2. Print the user inputs.
3. Convert the ASCII strings into two sign-extended integer values.
	a.Convert the first program argument to a 32-bit two’s complement number, stored in register 	$s1.
	b.Convert the second program argument to a 32-bit two’s complement number, stored in register $s2.
4. Add the two integer values, store the sum in $s0.
5. Print the sum as a decimal to the console.
6. Print the sum as 32-bit two’s complement binary number to the console.
7. Print the sum as a decimal number expressed in Morse code.
	a.Use a period (ASCII code 0x2E) for “dots” and a hyphen (ASCII code 0x2D)for “dashes”.
	b.Insert a space (ASCII code 0x20) between characters.
	c.Print the Morse code for a minus sign if the number is negative!
