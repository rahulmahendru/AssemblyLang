############################################################################
# Created by:  Mahendru, Rahul
#              ramahend
#              4 December 2018
#
# Assignment:  Lab 5: Subroutines (Typer Racer Test)
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program contains the subroutines to run a Typer racer
#              test game. A prompt appears to the user, and the user is
#              required to type in the exact string within a given
#              time limit (which is 10 seconds for this  program). 
#              If the user fails to type the correct string, or if
#              more time is taken than is allowed to type a string, the game 
#              is over.
#
# Notes:       This program is intended to be run from the MARS IDE. This version
#              of the code is intended to follow the Extra Credit part. Therefore,
#              it does not check for correct punctuation and is case insensitive.
#              Thus, "Hello, it's me" will be the regarded the same as 
#              "hello its me". This file is not intended to be played, since it
#              contains subroutines. All of the functions are executed through
#              the Lab5Test.asm file
############################################################################
#
# REGISTER USAGE
#
# $t0: Stores the times taken to input the string
#      Stores a relational value to check for the various conditions while 
#      checking for punctuatuion and case for extra credit
#
# $t1: Stores the stop time when the user has finished typing the string in
#      the check_user_input_string subroutine
#      Stores a relational value to check for the various conditions while 
#      checking for punctuatuion and case for extra credit
#
# $t2: Stores the start time to find the difference in check_user_input_string
#      subroutine
#      Stores the check value for upper case character in compare_strings
#
# $t3: Stores the check value for lower case character in compare_strings
#
# $t4: Stores the check value for number in compare_strings
#
# $t5: Stores the check value for space in compare_strings
#
# $t6: Stores the check value for new line character in compare_strings
#
# $s1: Stores the user input string in check_user_input_string
#      Stores the prompt string in check_strings subroutine
#
# $s2: Stores the User Prompt for comparison in check_strings subroutine
#
# $a0: Passes address of type prompt in give_type_prompt,check_user_input_string
#      and compare_strings,
#      Passes the address of individual character byte for comparison 
#      to compare_chars
#      Used to pass values for display throughout the subroutines
#
# $a1: Passes the time type prompt was given to the user to 
#      check_user_input_string,
#      Passes the address of the user input string to compare_strings
#      Passes the address of individual character byte for comparison
#      to compare_chars
#
# $a2: Passes the amount of time allowed for response by the user to 
#      check_user_input_string
#
# $v0: Returns the start time as lower 32 bits of time to the Lab5Test.asm
#      file from give_type_prompt,
#      Return success or loss value from all three functions of
#      check_user_input_string, compare_strings and compare_chars,
#      Used for syscall functions throughout the program
#
# $sp: Used to initialize stacks during subroutine calls, and store 
#      values to later recover while returning to the return address
#
# $ra: Used to store the return address while jumping to a subroutine
#      in order to link the subroutine with the main program
#
############################################################################
      
#--------------------------------------------------------------------
# give_type_prompt
#
# input:  $a0 - address of type prompt to be printed to user
#
# output: $v0 - lower 32 bit of time prompt was given in milliseconds
#--------------------------------------------------------------------
.text
give_type_prompt:

       # Push Stack with a space of 12 bytes
       subu  $sp   $sp 12
       sw    $ra  ($sp)               # Push $ra to stack
       sw    $s0 4($sp)               # Push $s0 to stack
       sw    $a0 8($sp)               # Push the address of the type prompt to stack
       

       # Print "Type Prompt: " to screen
       la  $a0 outputPrompt           # Load address of outputPrompt from .data section
       li  $v0 4                      # Syscall to print string
       syscall                        # Issue a syscall

       # Print the type prompt to screen
       lw  $a0 8($sp)                 # Load the address of the type prompt from the stack   
       li  $v0 4               
       syscall 

       # Store the current time when the type prompt is displayed to the user
       li  $v0 30                     # Syscall 30 stores the current time in $a0 and $a1 as lower and upper 32 bits
       syscall

       # Store the lower 32 bits of time in $v0 to return to Lab5Test.asm
       move  $v0 $a0

       # Pop Recover all the data from the stack
       lw    $s0 4($sp)                # Load the save register value from stack
       lw    $ra  ($sp)                # Recover the return address value to $ra
       addu  $sp   $sp  12             # Empty the memory and pop the whole stack
       
       # Jump back to the return address
       jr  $ra
       nop
       
.data
.align 4
outputPrompt: .asciiz "Type Prompt: "

#--------------------------------------------------------------------
# check_user_input_string
#
# input:  $a0 - address of type prompt printed to user
#         $a1 - time type prompt was given to user
#         $a2 - contains amount of time allowed for response
#
# output: $v0 - success or loss value (1 or 0)
#--------------------------------------------------------------------
.text
check_user_input_string:

       # Push stack with space of 12 bytes and save all the data to the stack
       subu  $sp   $sp  12
       sw    $ra  ($sp)
       sw    $a0 4($sp)
       sw    $a1 8($sp)

       # Get the input from the user 
       li    $v0 8                   # syscall to read a string
       la    $a0 size                # allocates size to $a0 to read the string
       li    $a1 100                 # allocates 100 readable characters from the user
       move  $s1 $a0                 # stores the user input to $s1
       syscall
 
       # Gets the time when the user has finished typing the string
       li  $v0 30   
       syscall
       
       # Store the lower 32 bits of the ending time to a temporary register
       move  $t1 $a0                 

       # Load the start time from the stack to a temporary register
       lw  $t2 8($sp)

       # Calculate the difference in the ending and start times to get the time taken by the user to type the string
       sub  $t0 $t1 $t2 

       # load prompt from the stack to be passed to compare_strings
       lw  $a0 4($sp)
       
       # Load the user input string to be passed to compare_strings
       move $a1 $s1

       # If the user takes more than the allowed time to type the string, the game ends
       bge  $t0 $a2 timeExceeded
       nop

       # else continue to jump to compare_strings
       b continue
       nop

       timeExceeded:
       
              # Pop the stack and recover all the data from the stack
              lw   $ra ($sp)
              addu $sp  $sp  12
              
              # Load a 0 into the $v0 to return to Lab5Test.asm since time has been exceeded
              li  $v0 0
              
              # Jump to the return address
              jr  $ra
              nop
              
       continue:
              
              # Jump to compare_strings to compare both the user input and the type prompt
              jal  compare_strings
              nop
              
       # After returning from compare_strings
       # Pop the stack and recover all the stored data
       lw   $ra ($sp)
       addu $sp  $sp  12
       
       # Jump to the return address
       jr  $ra
       nop
       
.data
.align 4
size: .space 100

#--------------------------------------------------------------------
# compare_strings
#
# input:  $a0 - address of first string to compare
#         $a1 - address of second string to compare
#
# output: $v0 - comparison result (1 == strings the same, 0 == strings not the same)
#--------------------------------------------------------------------
.text
compare_strings:
 
       # Push the stack and store all the data to be recovered later
       subu $sp   $sp  12
       sw   $ra  ($sp)
       sw   $a0 4($sp)
       sw   $a1 8($sp)
       
       # Store the type prompt string and user input string in save registers for comparison
       lw  $s2 8($sp)
       lw  $s1 4($sp)
       
       # Loop to load each individual byte and and send to compare_chars for comparison
       checkLoop:
       
              # Load each individual byte in the pass registers to pass to compare_chars
              lb  $a0 ($s1)
              lb  $a1 ($s2)
              
              # Condition to terminate the loop when any of the bytes is invalid (When the stirng finishes)
              beqz  $a0 endLoop
              nop
              beqz  $a1 endLoop
              nop

              # Check for punctuation for extra credit and load next byte if punctuation character encountered for first string
              # A check is made for alpha-numeric characters, a space and newline character
              # The other punctuation characters are skipped
              checkPunc1:
                     # Check for Upper Case Alphabet
                     sge  $t0 $a0 65
                     sle  $t1 $a0 90
                     and  $t2 $t0 $t1
                     
                     # Check for Lower Case Alphabet
                     sge  $t0 $a0 97
                     sle  $t1 $a0 122
                     and  $t3 $t0 $t1
                     
                     # Check for Numbers
                     sge  $t0 $a0 48
                     sle  $t1 $a0 57
                     and  $t4 $t0 $t1
                     
                     # Check for a space
                     seq  $t5 $a0 32
                     
                     # Check for a new line character
                     seq  $t6 $a0 10
                     
                     # Check if any of the above conditions are true
                     or  $t0 $t2 $t3
                     or  $t1 $t4 $t5
                     or  $t0 $t0 $t6
                     or  $t0 $t0 $t1 
                     
                     # If none of conditions are true then increment address and repeat loop
                     # Else continue to checking for second string
                     beq $t0 1 checkPunc2
                     addi $s1 $s1 1
                     b checkLoop
                     
              # Check for punctuation for extra credit and load next byte if punctuation character encountered for second string        
              checkPunc2:
                     
                     # Check for upper case alphabet
                     sge  $t0 $a1 65
                     sle  $t1 $a1 90
                     and  $t2 $t0 $t1
                     
                     # Check for lower case alphabet 
                     sge  $t0 $a1 97
                     sle  $t1 $a1 122
                     and  $t3 $t0 $t1
                     
                     # Check for numbers
                     sge  $t0 $a1 48
                     sle  $t1 $a1 57
                     and  $t4 $t0 $t1
                     
                     # Check for a space
                     seq  $t5 $a1 32
                     
                     # Check for a new line character
                     seq $t6 $a1 10
                     
                     # Check if any of the above conditions are true
                     or $t0 $t2 $t3
                     or $t1 $t4 $t5
                     or $t0 $t0 $t1 
                     or $t0 $t0 $t6
                     
                     # If none of conditions are true then increment address and repeat loop
                     # Else continue to jump
                     beq $t0 1 jump
                     addi $s2 $s2 1
                     b checkLoop
                     
             # Jump to compare_chars to compare the individual bytes
             jump:
                     jal  compare_chars
                     nop

             # if a 0 is returned from compare_chars, end the loop
             beqz  $v0 endLoop
             nop
             
             # increment the byte addresses of the two strings
             addi  $s1 $s1 1
             addi  $s2 $s2 1
             
             # repeat the loop until loop is terminated by given conditions
             b  checkLoop
             nop

       endLoop:
            
              # Pop the stack and recover all the data to the registers
              lw   $a1 8($sp)
              lw   $a0 4($sp)
              lw   $ra  ($sp)
              addu $sp   $sp  12
              
              # jump to the return address
              jr $ra
              nop

 .data
 
#--------------------------------------------------------------------
# compare_chars
#
# input:  $a0 - first char to compare (contained in the least significant byte)
#         $a1 - second char to compare (contained in the least significant byte)
#
# output: $v0 - comparison result (1 == chars the same, 0 == chars not the same)
#
#--------------------------------------------------------------------
.text 
compare_chars:

       # Push the stack and store all the data to be recovered later
       subu $sp   $sp  4
       sw   $ra  ($sp)
       
       # Check if the first character is upper case and convert it to lower case
       # This code is used for the extra credit part to disregard case insensitivity
       checkCase1:
              sge   $t0 $a0 65
              sle   $t1 $a0 90
              and   $t0 $t0 $t1
              beqz  $t0 checkCase2            # If the character is lower case, continue to checking for second string
              addi  $a0 $a0 32
       
       # Check if the second character is upper case and convert it into lower case
       checkCase2:
              sge   $t0 $a1 65
              sle   $t1 $a1 90
              and   $t0 $t0 $t1
              beqz  $t0 equal                 # If the character is lower case, continue to check if both characters are equal
              addi  $a1 $a1 32
       
       # Check if both the characters are the same and set $v0 to 1 if they are, or else 0
       equal:
              seq  $v0 $a0 $a1
       
       # Pop the stack and recover all the data to the registers
       lw   $ra  ($sp)
       addu $sp   $sp  4
       
       # Jump to return address
       jr  $ra 
       nop
       
 .data