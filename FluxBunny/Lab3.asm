####################################################################################
# Created by:  Mahendru, Rahul
#              ramahend
#              5 November, 2018
#
# Assignment:  Lab 3: Flux Bunny
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program checks if the given input is divisible by 5 or 7 or
#              both and prints Flux, Bunny or FLux Bunny respectively. The number
#              itself is printed if none of the three conditions are satisfied
#
# Notes:       This program is intended to be run from the MARS IDE.
####################################################################################

# Text Segment
.text

# main tag
main:
       # User Prompt
       li $v0 4                  # to read the data as string
       la $a0 prompt             # to load the prompt to be displayed to ask for user input
       syscall                   # issue a system call

       # User Input
       li $v0 5                  # to accept the next input as an integer
       syscall              
       move $t0 $v0              # t0: temporary register that stores the user input
        
       # initialize temporary register as a counter register for the loop
       add $t1 $zero $zero       # $t1: temporary register with initial value 0
 
# Loop to analyse the numbers and print the required output
beginLoop:
 
       # loop increment and check
       sle $t2 $t1 $t0           # $t2: temporary register sets to 0 if counter is greater than user input
       beqz $t2 endLoop          # ends the loop if the counter is greater than user input

       # to check if the number is divisible by 5 and store the remainder in $t3
       rem $t3 $t1 5
       
       # to check if the number is divisible by 7 and store the remainder in $t4
       rem $t4 $t1 7
       
       # to check if the number is divisible by 5 and 7 and store the result of the relational operation in $t5
       # $t5 results in 0 if the number gives a remainder of 0 with both 5 and 7
       or $t5 $t3 $t4
 
       # check for which condition is fulfilled and branch to the appropriate label to print the output
       beqz $t5, fluxBunny       # branch to label which outputs in Flux Bunny if $t5 contains 0
       beqz $t3, flux            # branch to label which outputs in Flux if $t3 contains 0 and $t5 does not
       beqz $t4, bunny           # branch to label which outputs in Bunny if $t4 contains 0 and $t5 does not
       b number                  # branch to label which outputs in the number itself if none of the conditions are satisfied
    
# label block to print Flux if number is divisble by 5
flux:
       li $v0, 4
       la $a0, f
       syscall 
       b increment               # branches to the increment label to increase value of counter after output for current value of counter
 
# label block to print Bunny if number is divisble by 7
bunny:
       li $v0, 4
       la $a0, bn
       syscall
       b increment
 
# label block to print Flux Bunny if number is divisble by both 5 and 7
fluxBunny:
       li $v0, 4
       la $a0, fb
       syscall
       b increment
 
# label block to print the number itself if none of the conditions are satisfied
number:
       li $v0,1
       move $a0, $t1
       syscall
       li $v0, 4
       
       # to print a new line
       la $a0, newLine
       syscall
       b increment

# label block to increment the counter after the output for the current counter value
increment:
       add $t1, $t1, 1
       b beginLoop                # branch back to the beginning of the loop to repeat the steps for the next counter value
 
# label to mark the end of the loop and the continuation of the rest of the program
endLoop:

       # issue a System call to exit
       li $v0,10
       syscall 

# Data Segment
.data

prompt: .asciiz "Please input a positive integer: "
f: .asciiz "Flux\n"
bn: .asciiz "Bunny\n"
fb: .asciiz "Flux Bunny\n"
newLine: .asciiz "\n"