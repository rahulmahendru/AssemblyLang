------------------------
CMPE 012 Fall 2018

Mahendru, Rahul
-------------------------

This program will display a string and prompt the user to type the same string in a given time limit. It will check if this string is identical to the given one and whether the user made the time limit. If the user types in the prompt incorrectly or does not finish the prompt in the given time limit, the game is over.

The subroutines in this program are as follows:

#--------------------------------------------------------------------
# give_type_prompt
#
# input:  $a0 - address of type prompt to be printed to user
#
# output: $v0 - lower 32 bit of time prompt was given in milliseconds
#--------------------------------------------------------------------#--------------------------------------------------------------------
# check_user_input_string
#
# input:  $a0 - address of type prompt printed to user
#         $a1 - time type prompt was given to user
#         $a2 - contains amount of time allowed for response
#
# output: $v0 - success or loss value (1 or 0)
#--------------------------------------------------------------------#--------------------------------------------------------------------
# compare_strings
#
# input:  $a0 - address of first string to compare
#         $a1 - address of second string to compare
#
# output: $v0 - comparison result (1 == strings the same, 0 == strings not the same)
#--------------------------------------------------------------------#--------------------------------------------------------------------
# compare_chars
#
# input:  $a0 - first char to compare (contained in the least significant byte)
#         $a1 - second char to compare (contained in the least significant byte)
#
# output: $v0 - comparison result (1 == chars the same, 0 == chars not the same)
#
#--------------------------------------------------------------------


