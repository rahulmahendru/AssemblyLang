############################################################################
# Created by:  Mahendru, Rahul
#              ramahend
#              27 November 2018
#
# Assignment:  Lab 4 Part B: ASCII String to 2's Complement
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This part of the program contains the pseudocode and the main 
#              functioning to be implemented for the funtion of taking two 
#              program arguments as inputs and printing their sum as well as 
#              the 2's Complement Binary representation of their sum by converting 
#              it into a string. It also contains the programming code to 
#              display the Morse Code representation of the decimal sum.
#
# Notes:       This file is intended to be run by the MASRS IDE. The program
#              accepts program arguments as input. The program arguments can be
#              passed to the program by writing the values in the 'program arguments'
#              text box in the execution window. The program arguments settings need to 
#              be turned on from the settings drop down option. 
#
############################################################################
#
# Pseudocode
#
# main:
#      Print (Prompt to display the user input)
#
#      Load Address of program arguments and store into temporary registers
#      
#      firstInput:
#      $t0 = program argument 1
#      go to display for $t0
#      go to ToDecimal for $t0
#      go to store to store the number in save register
#      go to 2SC to check id it is a negative number and take 2's complement
#
#      secondInput:
#      $t0 = program argument 2
#      go to display for secondInput
#      go to ToDecimal for secondInput
#      go to store to store the number in save register
#      go to 2SC to check for a negative number and convert it into 2's Complement
#
#      go to add
#      
# ToDecimal: 
#      convert the strings into decimal 
#      $t2 = byte for the current address of argument
#      if first byte contains a '-' (check for ASCII value 45)
#           if (negative) 
#                flagneg = true
#                $t2++
#           else 
#                change to Decimal by adding the running sum by loop
#                go to toDecimalLoop
# toDecimalLoop:
#      $t2 = address of $t0
#      if $t2 = invalid
#           go to 2SC
#      $t2 = $t2 - 48 (to get ASCII decimal value of the string character)
#      $t3 = ($t3 * 10) + $t2 
#      $t0++
#      goto toDecimalLoop
#
# store: 
#      store the value of temporary register to save register
#
# 2SC: 
#      check if (flagneg == true) for negative number 
#           if (flag == true)
#                     $s = $s xor -1
#                     $s = $s + 1
#
# Add:
#      Add the two numbers
#      $s0 = $s1 + $s2
#
# DisplaySum:
#      Print the prompt
#      Display the sum as a Decimal by converting to string
#      Address of each byte + 48 (to get ASCII value of string)
#      
#      Check if sum<0 
#      print '-' sign
#      loop:
#            while($s != 0)
#            sp = sp-4
#            push stack
#            store current byte ( $s % 2)
#            $s = $s /2
#            go to loop
#
#            print: 
#                  while(stack!=empty)
#                  pop stack element = $t
#                  $t= $t + 48
#                  print($t)
#                  return             
#
# Mask: 
#      Print the Prompt
#      create the initial mask to start checking with the MSB for sign 
#           if (Mask && $s0 == 1)
#                Print 1 to screen
#           else 
#                Print 0 to screen
#
# Morse Code:
#      Print the prompt
#      Display the morse code by getting each byte and printing the
#      corresponding morse code for the digit
#    
#      check if sum<0
#      print mprse code for a minus sign = '-...-'
#      
#      loop:
#            while($s != 0)
#            sp = sp-4
#            push stack
#            store current byte ( $s % 2)
#            $s = $s /2
#            go to loop
#
#            print: 
#                  while(stack!=empty)
#                  pop stack element = $t
#                  if $t<5
#                       print dots followed by dashes
#                       number of dots = $t
#                       number of dashes = 5 - $t
#                  if $t>=5
#                       print dashes followed by dots
#                       number of dashes = $t-5
#                       number of dots = 10 - $t
#                  
#           return    
#
# EndProgram: 
#      Exit code
#
########################################################################
# 
# REGISTER USAGE:
# $t0 : Holds the program arguments, 
#       Holds the value of the sum for digit extraction while printing 
#       the decimal sum and the Morse Code,
#       Holds the masked value for printing the binary representation of sum
#
# $t1 : Holds the value 10 for multiplication while converting program arguments 
#       to decimals,
#       Holds the last digit of the sum as a remainder while extraction of
#       digits to print sum and morse code,
#       Holds the mask while the masking process to print binary representation
#
# $t2 : Holds the byte for conversion of inputs into decimal,
#       Used a scounter for stack pointer while printing sum and Morse Code
#
# $t3 : Used as flag for negative number while converting inputs to decimals,
#       Holds the individual stack elements while popping for printing them
#
# $t4 : Holds the decimal ASCII value of inputs after converting them form strings,
#      Holds number of dashes or dots to be printed while printing Morse Code
#
# $t5 : Holds 5 for logical subtracting while printing Morse Code
#
# $t6 : Holds 10 for logical subtraction while printing Morse Code
#
# $s0 : Holds the 32 bit sign extended sum of the two inputs
#
# $s1 : Holds the 32 bit sign extended integer value of first input
#
# $s2 : Holds the 32 bit sign extended integer value of second input
#
# $a0 : Used to print the values by accepting the arguments
#
# $a1 : Holds the address of the program argument
#
# $v0 : Used to return syscall instructions 
#
########################################################################

.text

# main label
main:

#print prompt to display user input
printPrompt:
       li $v0 4
       la $a0 prompt
       syscall

# accept first input, print it and convert it to 32 bit integer
firstInput:
       lw $t0 ($a1)                # load first argument into $t0
       la $a0 ($t0)                # load address $t0 in $a0 to print
       li $v0 4                    # syscall 4 to print string
       syscall                     # issue a system call

       # Print a space
       li $v0 4
       la $a0 space
       syscall

       # t1: hold the value 10 for multiplication in converting ADSCII string to decimal
       add $t1 $t1 10

       # Convert the ASCII string to Decimal 
       toDec1:

           # Check if the input value is a negative value
           checkNeg1:
                  lb $t2 ($t0)                 # Load first byte of the input string
                  beq $t2 45 negative1         # branch to negative1 if ASCII value of this byte equals 45 
                                               #(ASCII value of '-' = 45
                  nop                             
                  b loop1                      # else branch to loop1
                  nop 

           # Sets $t3 to  1 as a flag for negative input
           negative1:
                  addi $t3 $zero 1
                  addi $t0 $t0 1               # increase address of $t0 

           # loop to convert each byte to decimal and create the decimal number
           loop1:
                  lb $t2 ($t0)
                  beqz $t2 store1              # exit loop if $t2 is invalid
                  nop
                  sub $t2 $t2 48               # subtract 48 from the byte to get Decimal ASCII representation of byte
                  mult $t4 $t1                 # Multiply the result by 10 to get the new byte at one's place
                  mflo $t4                     # store the LO register (32 bit)
                  add $t4 $t4 $t2              # Add current byte to the integer
                  addi $t0 $t0 1               # increment address of the input
                  b loop1
                  nop

       # Store the 32 bit integer value of user input to $s1
       store1:
              add $s1 $s1 $t4

       # if the flag for negative number is 1, take two's complement of input to chnage into 32 bit
       # sign extended 2's complement value
       bnez $t3 twoSC1
       nop
       b reset                     # if flag is 0, continue to next segment of code
       nop

       # Take 2's complement of input, if it is negative
       twoSC1:
              xori $s1 $s1 -1             # Flip the bits
              addi $s1 $s1 1              # Add 1

       # reset temporary register for reusability
       reset:
              add $t0 $zero $zero
              add $t2 $zero $zero
              add $t3 $zero $zero
              add $t4 $zero $zero

# Accept second input and repeat the same steps to display and convert to 32 bit sign extended integer
secondInput:
       lw $t0 4($a1)
       la $a0 ($t0)
       li $v0 4
       syscall 

       # Convert String to Decimal for second input
       toDec2:
       
           # Check if the input value is a negative value
           checkNeg2:
                  lb $t2 ($t0)
                  beq $t2 45 negative2
                  nop
                  b loop2
                  nop
                  
           # Sets $t3 to 1 as a flag for negative input
           negative2:
                  addi $t3 $zero 1
                  addi $t0 $t0 1

           # loop to convert each byte to decimal and create the decimal number
           loop2:
                  lb $t2 ($t0)
                  beqz $t2 store2
                  nop
                  sub $t2 $t2 48
                  mult $t4 $t1
                  mflo $t4
                  add $t4 $t4 $t2
                  addi $t0 $t0 1
                  b loop2
                  nop

       # Store the 32 bit integer value of user input to $s2
       store2:
              add $s2 $s2 $t4

       # if the flag for negative number is 1, take two's complement of input to chnage into 32 bit
       # sign extended 2's complement value
       bnez $t3 twoSC2
       nop
       b sum
       nop

       # Take 2's complement of input, if it is negative
       twoSC2:
              xori $s2 $s2 -1
              addi $s2 $s2 1

# Take the sum of the 32 bit sign extended integers ans store them to $s0
sum:
       add $s0 $s1 $s2

# Reset the temporary registers for reusability
reset1:
       add $t0 $zero $zero
       add $t1 $zero $zero
       add $t2 $zero $zero
       add $t3 $zero $zero

# Print the prompt to display the sum
printSumPrompt:

       # Print new lines for format of output
       li $v0 4
       la $a0 newLine
       syscall
       li $v0 4
       la $a0 newLine
       syscall

       # Print the prompt
       li $v0 4
       la $a0 promptSum
       syscall

       # Print to sum as a decimal by converting it into string
       printSum:
              add $t0 $t0 $s0                   # Store the sum in $t0
              bltz $t0 negt                     # go to negt to print a minus sign if sum is less than 0
              nop
              b continue                        # else continue
              nop

       # Prints a minus sign if number is negative
       negt: 
              sub $t0 $zero $t0                 # to store the negative number as a positive for the stack
 
              # Print the minus sign
              li $v0 4
              la $a0 minus
              syscall

       continue:
              jal printSumloop
              nop                  
              b reset2
              nop

       # Assign each byte to the stack and and print them by converting them to String ASCII representations
       printSumloop:
              beqz $t0 print                   # stop pushing stack if $t0 becomes 0
              nop
              rem $t1 $t0 10                   # get the last digit of $t0

              sub $t2 $t2 4                    # use counter for stack pointer
              add $sp $sp -4                   # push new address of stack
              sw $t1 0($sp)                    # load the last digit into current address of stack

              div $t0 $t0 10                   # divide $t0 by 10 to remove the last digit which we already have
              b printSumloop                   # repeat loop
              nop

       # print the sum by popping the satck until it is empty, and adding 48 to get ASCII string representaion
       print: 
              bgez $t2 return                  # if stack is empty, return
              nop
              add $t2 $t2 4                    # increase counter
              lw $t3 0($sp)                    # pop current byte from stack
              add $sp $sp 4                    # increase stack pointer address

              add $t3 $t3 48                   # add 48 to current byte to get ASCII String representation

              # Print the current digit 
              li $v0 11
              move $a0 $t3
              syscall
              
              b print                          # repeat print loop until stack is empty
              nop

       return:
              jr $ra

#reset temporary registers for reusability
reset2:
       add $t0 $zero $zero
       add $t1 $zero $zero

# Print prompt to display the sum represented as a 32 bit extended binary representation
printBinaryPrompt:

       # Print new lines for format
       li $v0 4
       la $a0 newLine
       syscall
       li $v0 4
       la $a0 newLine
       syscall

       # Print the prompt to display the binary representation of the sum
       li $v0 4
       la $a0 prompt2SC
       syscall

# Mask method to print sign extended binary representaion of the sum 
mask:
       addi $t1 $zero 1
       ror $t1 $t1 1                     # Initial mask

       # Loop to mask each digit of the sum and print the string representation of the sum 
       maskLoop:
              and $t0 $s0 $t1                     # AND the mask and the sum and to store the value in $t0
              beqz $t0 pZero                      # if $t0 equals 0, then print 0
              nop
              bnez $t0 pOne                       # else print 1
              nop

       # Print 0 to the output
       pZero:
              li $v0 4
              la $a0 zero
              syscall
              b shft
              nop

       # Print 1 to the output
       pOne:
              li $v0 4
              la $a0 one
              syscall
              b shft
              nop

       # method to shift the 1 in the mask to the right to check for the next digit in the 
       # sum until 1 falls off the number on the right
       shft:
              srl $t1 $t1 1                     # shift 1 to the right by 1 bit
              beqz $t1 reset3                   # continue to the next segment if 1 has fallen off the mask 
              nop
              b maskLoop
              nop

# reset the temporary registers for reusability 
reset3:
       add $t0 $zero $zero
       add $t1 $zero $zero
       add $t2 $zero $zero
       add $t3 $zero $zero

# Print the prompt to display the Sum as a Morse Cose Representation 
printPromptMorse:

       # Print New Line for output format
       li $v0 4
       la $a0 newLine
       syscall
       li $v0 4
       la $a0 newLine
       syscall

       # Print the prompt
       li $v0 4
       la $a0 promptMorse
       syscall

# Convert the sum into Morse Code to print it 
morseCode: 
       add $t0 $t0 $s0                          # Store the sum into $t0 
       addi $t5 $zero 5                         # Store 5 in $t5 for morse code logic
       addi $t6 $zero 10                        # Store 10 in $t6 for morse code logic

       bltz $t0 negtMorse                       # Branch to print morse code for minus sign if number is negative
       nop
       b nextMorse                              # Else continue t0 the next section 
       nop

       negtMorse:
       
              # Store the absolute part of the sum
              sub $t0 $zero $t0           

              # print the minus morse code
              li $v0 4
              la $a0 minusMorse
              syscall

              # print a space
              li $v0 4
              la $a0 space
              syscall

       nextMorse:
              jal loopMorse
              nop
              b exit
              nop

       # Assign each byte to the stack and and print the morse code for each digit
       loopMorse:
              beqz $t0 printMorse               # Stop pushing stack if the value of the sum become 0
              nop
              rem $t1 $t0 10                    # Store the last digit of the sum 

              sub $t2 $t2 4                     # decrease counter for stack pointer
              add $sp $sp -4                    # decrease the address of the stack pointer
              sw $t1 0($sp)                     # store the digit at the current address location in the stack 

              div $t0 $t0 $t6                   # divide the sum by 10 to remove the last digit from the sum
              b loopMorse                       # repeat the loop until all digits are extracted 
              nop

       printMorse:
              bgez $t2 returnMorse              # stop popping if the stack is empty
              nop
              add $t2 $t2 4                     # add to the counter to check if the stack has any elements
              lw $t3 0($sp)                     # load the word at the current address 
              add $sp $sp 4                     # increase the stack pointer to load the next digit

              # check if the current digit is less than 5 or greater than equal to 5 for morse code logic
              ble $t3 4 less                    # branch to less if number is less than 5           
              nop       
              bge $t3 5 great                   # branch to great if number is greater than or equal to 5
              nop

              # less prints morse code where dots are followed by dashes for a number which is less than 5
              less:
                     sub $t4 $t5 $t3                   # stores number of dashes to be printed
                     bnez $t3 printDotLess             # if $t3 is not 0, print $t3 number of dots
                     nop
                     beqz $t3 printDashLess            # if $t3 is 0, print $t4 number of dashes
                     nop

              # method to print dots
              printDotLess:
                     beqz $t3 printDashLess            # print dashes if no more dots are to be printed
                     nop

                     # print dots 
                     li $v0 4
                     la $a0 dot
                     syscall
                     sub $t3 $t3 1                     # decrement number of dots to be printed 
                     b printDotLess                    # repeat loop until no more dots are to be printed
                     nop

              # method to print dashes 
              printDashLess: 
                     beqz $t4 sp                       # print a space if the morse code has finished printing
                     nop
                   
                     # print a dash
                     li $v0 4 
                     la $a0 dash 
                     syscall
                     sub $t4 $t4 1                     # decrement the counter for the number of dashes to be printed 
                     b printDashLess                   # repeat loop until there are no more dashes to be printed 
                     nop

              # great prints morse code where dots are followed by dashes for a number which is gretaer than or equal to 5
              great:
                     sub $t4 $t3 $t5                   # Number of dashes to be printed
                     sub $t3 $t6 $t3                   # Number of dots to be printed 
                     bnez $t4 printDashGreat           # Print dashes if $t4 is not 0
                     nop
                     beqz $t4 printDotGreat            # Print dots if $t4 is 0
                     nop
 
              # Method to print dashes
              printDashGreat:
                     beqz $t4 printDotGreat            # go to print dots if no more dahse sare to be printed
                     nop
                   
                     # Print a dash
                     li $v0 4
                     la $a0 dash
                     syscall
                     sub $t4 $t4 1                    # Decrement the counter for the number of dashes to be be printed 
                     b printDashGreat                 # repeat until there are no more dashes to be printed
                     nop

              # Method to print the dots
              printDotGreat:
                     beqz $t3 sp                      # print a space if no more dots are to be printed
                     nop

                     # print a dot
                     li $v0 4 
                     la $a0 dot
                     syscall
                     sub $t3 $t3 1                    # decrease the counter for the number of dots to be printed
                     b printDotGreat                  # repeat until there are no more dots to be printed
                     nop

              # method to print a space
              sp:
                     li $v0 4
                     la $a0 space
                     syscall

              #Repeat loop for the next byte in the stack 
              b printMorse
              nop

       returnMorse:
              jr $ra

exit:

       # Print a new line for the output format 
       li $v0 4
       la $a0 newLine
       syscall

       # Issue an exit syscall
       li $v0 10
       syscall

.data
.align 4
prompt: .asciiz "You entered the decimal numbers:\n"
promptSum: .asciiz "The sum in decimal is:\n"
prompt2SC: .asciiz "The sum in two's complement binary is:\n"
promptMorse: .asciiz "The sum in Morse code is:\n"
newLine: .asciiz "\n"
space: .asciiz " "
zero: .asciiz  "0"
one: .asciiz "1"
minus: .asciiz "-"
minusMorse: .asciiz "-...-"
dash: .asciiz "-"
dot: .asciiz "."
